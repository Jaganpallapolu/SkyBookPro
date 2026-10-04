public with sharing class DuffelFlightPricingService {
    @AuraEnabled(cacheable=false)
    public static FlightOfferWrapper confirmFlightPrice(
        String offerId,
        String offerJson
    ){
        
        // Validate Offer Id
        if(String.isBlank(offerId)){
            throw new AuraHandledException('Offer Id cannot be empty.');
        }
        
        // Validate Offer JSON
        if(String.isBlank(offerJson)){
            throw new AuraHandledException('Offer JSON cannot be empty.');
        }
        // Convert JSON String into Apex Map
        Map<String, Object> offer = (Map<String, Object>)JSON.deserializeUntyped(offerJson);
        
        // Get Offer Id from JSON
        String jsonOfferId = (String)offer.get('id');
        
        // Validate Offer Id
        if(jsonOfferId == null || jsonOfferId != offerId){
            throw new AuraHandledException(
                'Offer ID mismatch.'
            );
        }
        // Create Wrapper
        FlightOfferWrapper wrapper = new FlightOfferWrapper();
        // Basic Details
        wrapper.offerId = jsonOfferId;
        
        String totalAmount = (String)offer.get('total_amount');
        
        if(String.isBlank(totalAmount)){
            throw new AuraHandledException(
                'Price not found.'
            );
        }
        
        wrapper.price = Decimal.valueOf(totalAmount);
        
        wrapper.currencyCode =
            (String)offer.get('total_currency');
        
        // Airline Information
        Map<String, Object> owner = (Map<String, Object>)offer.get('owner');
        
        if(owner != null){
            
            wrapper.airline = (String)owner.get('name');
            
            wrapper.airlineCode = (String)owner.get('iata_code');
            
        }
        // Flight Slice
        List<Object> slices =
            (List<Object>)offer.get('slices');
        
        if(slices != null && !slices.isEmpty()){
            
            Map<String,Object> slice =
                (Map<String,Object>)slices[0];
            
            wrapper.duration =
                (String)slice.get('duration');
            
            // Flight Segment
            List<Object> segments = (List<Object>)slice.get('segments');
            
            if(segments != null && !segments.isEmpty()){
                
                Map<String,Object> segment = (Map<String,Object>)segments[0];
                
                // Flight Details
                wrapper.departureTime = (String)segment.get('departing_at');
                
                wrapper.arrivalTime = (String)segment.get('arriving_at');
                
                wrapper.flightNumber = (String)segment.get('operating_carrier_flight_number');
                
                // Origin Airport
                Map<String,Object> origin = (Map<String,Object>)segment.get('origin');
                
                if(origin != null){
                    
                    wrapper.origin = (String)origin.get('iata_code');
                    
                    wrapper.originAirport = (String)origin.get('name');
                    
                }
                
                // Destination Airport
                Map<String,Object> destination = (Map<String,Object>)segment.get('destination');
                
                if(destination != null){
                    
                    wrapper.destination = (String)destination.get('iata_code');
                    
                    wrapper.destinationAirport = (String)destination.get('name');
                    
                }
                
            }
            
        }
        
        return wrapper;
    }
}