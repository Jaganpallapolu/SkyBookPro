public with sharing class BookingService {
    private static final String STATUS_CONFIRMED = 'confirmed';
    private static final String PASSENGER_TYPE_ADULT = 'Adult';
    @AuraEnabled
    public static Booking__c createBooking(
        Id passengerId,
        Id flightId,
        String offerId,
        String offerJson,
        Integer numberOfSeats,
        String seatClass,
        PassengerWrapper passenger
    ){

        // Validate Passenger
        if(passengerId == null){
            throw new AuraHandledException(
                'Passenger is required.'
            );
        }

        // Validate Flight
        if(flightId == null){
            throw new AuraHandledException(
                'Flight is required.'
            );
        }
        
        // Validate Offer Id
        if(String.isBlank(offerId)){
            throw new AuraHandledException(
                'Offer Id is required.'
            );
        }
        
        // Validate Offer JSON
        if(String.isBlank(offerJson)){
            throw new AuraHandledException(
                'Offer JSON is required.'
            );
        }
        
        // Validate Number of Seats
        if(numberOfSeats == null || numberOfSeats <= 0){
            throw new AuraHandledException(
                'Number of seats should be greater than zero.'
            );
        }
        
        // Validate Seat Class
        if(String.isBlank(seatClass)){
            throw new AuraHandledException(
                'Seat Class is required.'
            );
        }
        
       if(passenger == null){

            throw new AuraHandledException(
                'Passenger information is required.'
            );

        }
        
        
        // Validate and Get Latest Flight Details
        FlightOfferWrapper flight = DuffelFlightPricingService.confirmFlightPrice(
                offerId,
                offerJson
            );
        
        
        // Create Savepoint
        Savepoint sp = Database.setSavepoint();
        
        Booking__c booking;
        
        try{
            // Create Booking Record
            booking = new Booking__c();
            
            
            booking.Passenger__c = passengerId;
            
            booking.Flight__c = flightId;
            
            booking.Booking_Date__c = Date.today();
            
            booking.Booking_Status__c = STATUS_CONFIRMED;
            
            booking.Seat_Class__c = seatClass;	
            
            booking.Number_of_Seats__c = numberOfSeats;
            
            booking.Base_Fare__c = flight.price;
            
            booking.Taxes_Fees__c = 0.0;
            
            booking.Agent__c = UserInfo.getUserId();
            
            // Save Booking
            Database.SaveResult sr = Database.insert(booking, false);
            
            if(!sr.isSuccess()){
                
                throw new AuraHandledException(
                    sr.getErrors()[0].getMessage()
                );
                
            }
            
            // Get Contact Details
            List<Contact> contacts = [
                SELECT FirstName, LastName
                FROM Contact
                WHERE Id = :passengerId
            ];
            
            if(contacts.isEmpty()){
                throw new AuraHandledException(
                    'Passenger not found.'
                );
            }
            
            Contact passengerContact = contacts[0];
            
            // Create Passenger Detail
            Passenger_Detail__c passengerDetail =
                new Passenger_Detail__c();
            
            passengerDetail.Booking__c = booking.Id;
            
            passengerDetail.First_Name__c =
                passengerContact.FirstName;
            
            passengerDetail.Last_Name__c =
                passengerContact.LastName;
            
            passengerDetail.Date_of_Birth__c =
                    passenger.dateOfBirth;
            
            passengerDetail.Gender__c =
                passenger.gender;
            
            passengerDetail.Title__c =
                passenger.title;
            
            passengerDetail.Passenger_Type__c =
                passenger.passengerType;

            
            if(!String.isBlank(passenger.passportNumber)){
                passengerDetail.Passport_Number__c =
                    passenger.passportNumber;
            }
            
            insert passengerDetail;
            
            // Create Flight Segment
            Flight_Segment__c segment = new Flight_Segment__c();
            
            segment.Booking__c = booking.Id;
            
            segment.Flight_Number__c = flight.flightNumber;
            
            segment.Origin__c = flight.origin;
            
            segment.Destination__c = flight.destination;
            
            // Convert String to Datetime
            if(!String.isBlank(flight.departureTime)){
                segment.Depature_DateTime__c =
                    Datetime.valueOfGmt(
                        flight.departureTime.replace('T',' ').replace('Z','')
                    );
            }
            
            if(!String.isBlank(flight.arrivalTime)){
                segment.Arrival_DateTime__c =
                    Datetime.valueOfGmt(
                        flight.arrivalTime.replace('T',' ').replace('Z','')
                    );
            }
            
            segment.Carrier_Code__c = flight.airlineCode;
            
            segment.Segment_Order__c = 1;
            
            insert segment;
            
        }
        catch(Exception e){
            
            Database.rollback(sp);
            
            System.debug('Exception Type: ' + e.getTypeName());
            System.debug('Exception Message: ' + e.getMessage());
            System.debug('Exception Stack: ' + e.getStackTraceString());
            
            throw e;
        }
        
        return booking;
    }

}