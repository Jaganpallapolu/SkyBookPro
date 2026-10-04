public with sharing class DuffelFlightSearchService {

    @AuraEnabled(cacheable=false)
    public static List<FlightOfferWrapper> searchFlights(
        String origin,
        String destination,
        Date departureDate,
        Integer adults,
        String cabinClass
    ) {

        List<FlightOfferWrapper> flightList = new List<FlightOfferWrapper>();

        try {

            // Get API Key
            String apiKey = DuffelAuthService.getApiKey();

            // Build Request Body
            DuffelSearchRequest requestBody = new DuffelSearchRequest();

            // Slice
            DuffelSearchRequest.Slice slice = new DuffelSearchRequest.Slice();
            slice.origin = origin;
            slice.destination = destination;
            slice.departure_date = departureDate;

            requestBody.data.slices.add(slice);

            // Passengers
            for(Integer i = 0; i < adults; i++){

                DuffelSearchRequest.Passenger passenger =
                    new DuffelSearchRequest.Passenger();

                passenger.type = 'adult';

                requestBody.data.passengers.add(passenger);
            }

            // Cabin Class
            requestBody.data.cabin_class = cabinClass.toLowerCase();

            // Convert Request to JSON
            String jsonBody = JSON.serialize(requestBody);

            // HTTP Request
            HttpRequest req = new HttpRequest();

            req.setEndpoint('https://api.duffel.com/air/offer_requests');
            req.setMethod('POST');

            req.setHeader('Authorization', 'Bearer ' + apiKey);
            req.setHeader('Duffel-Version', 'v2');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');

            req.setBody(jsonBody);

            // Send Request
            Http http = new Http();
            HttpResponse response = http.send(req);

            // Success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){

                Map<String,Object> result =
                    (Map<String,Object>)JSON.deserializeUntyped(response.getBody());

                Map<String,Object> data =
                    (Map<String,Object>)result.get('data');
				
                List<Object> passengers =
                    (List<Object>)data.get('passengers');
                
                String passengerId;
                
                if(passengers != null && !passengers.isEmpty()){
                    
                    Map<String,Object> passengerMap =
                        (Map<String,Object>)passengers[0];
                    
                    passengerId = (String)passengerMap.get('id');
                }

                List<Object> offers =
                    (List<Object>)data.get('offers');

                for(Object obj : offers){

                    Map<String,Object> offer =
                        (Map<String,Object>)obj;

                    FlightOfferWrapper wrapper =
                        new FlightOfferWrapper();

                    wrapper.offerJson = JSON.serialize(offer);

                    // Basic Details
                    wrapper.offerId =
                        (String)offer.get('id');
                    
					wrapper.passengerId = passengerId;
                    
                    wrapper.price =
                        Decimal.valueOf(
                            (String)offer.get('total_amount')
                        );

                    wrapper.currencyCode =
                        (String)offer.get('total_currency');
                    wrapper.cabinClass = cabinClass;

                    // Airline
                    Map<String,Object> owner =
                        (Map<String,Object>)offer.get('owner');

                    if(owner != null){
                        wrapper.airline =
                            (String)owner.get('name');
                    }

                    // Slice
                    List<Object> slices =
                        (List<Object>)offer.get('slices');

                    if(slices != null && !slices.isEmpty()){

                        Map<String,Object> firstSlice =
                            (Map<String,Object>)slices[0];

                        wrapper.duration =
                            (String)firstSlice.get('duration');

                        // Segment
                        List<Object> segments =
                            (List<Object>)firstSlice.get('segments');

                        if(segments != null && !segments.isEmpty()){

                            Map<String,Object> segment =
                                (Map<String,Object>)segments[0];

                            wrapper.departureTime =
                                (String)segment.get('departing_at');

                            wrapper.arrivalTime =
                                (String)segment.get('arriving_at');

                            wrapper.flightNumber =
                                (String)segment.get('operating_carrier_flight_number');

                            // Origin
                            Map<String,Object> originMap =
                                (Map<String,Object>)segment.get('origin');

                            if(originMap != null){

                                wrapper.origin =
                                    (String)originMap.get('iata_code');

                                wrapper.originAirport =
                                    (String)originMap.get('name');
                            }

                            // Destination
                            Map<String,Object> destinationMap =
                                (Map<String,Object>)segment.get('destination');

                            if(destinationMap != null){

                                wrapper.destination =
                                    (String)destinationMap.get('iata_code');

                                wrapper.destinationAirport =
                                    (String)destinationMap.get('name');
                            }
                        }
                    }

                    flightList.add(wrapper);
                }

            } else {

                System.debug('Status Code : ' + response.getStatusCode());
                System.debug('Response : ' + response.getBody());

                throw new AuraHandledException(
                    'Duffel API Error : ' + response.getBody()
                );
            }

        } catch(Exception e){

            throw new AuraHandledException(e.getMessage());

        }

        return flightList;
    }

}