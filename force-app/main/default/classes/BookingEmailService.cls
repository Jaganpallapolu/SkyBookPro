public with sharing class BookingEmailService {

    public static void sendBookingConfirmation(
        List<Booking__c> bookings
    ){
        
    

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        for(Booking__c booking : bookings){

            // Booking must have a passenger
            if(booking.Passenger__c == null){
                continue;
            }

            Contact passenger = [
                SELECT FirstName, Email
                FROM Contact
                WHERE Id = :booking.Passenger__c
                LIMIT 1
            ];

            if(String.isBlank(passenger.Email)){
                continue;
            }

            Messaging.SingleEmailMessage email =
                new Messaging.SingleEmailMessage();

            email.setToAddresses(
                new List<String>{ passenger.Email }
            );

            email.setSubject(
                'Booking Confirmation'
            );

            email.setPlainTextBody(
                'Hi ' + passenger.FirstName + ',' +
                '\n\nYour booking has been created successfully.' +
                '\n\nBooking Status: ' + booking.Booking_Status__c +
                '\n\nThank you for choosing SkyBook Pro.'
            );

            emails.add(email);

        }
        
        

        if(!emails.isEmpty()){
           
            Messaging.sendEmail(emails);
        }

    }
    
    public static void sendBookingCancellation(
        List<Booking__c> bookings
    ){
        
        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();
        
        Set<Id> contactIds = new Set<Id>();
        
        for(Booking__c booking : bookings){
            if(booking.Passenger__c != null){
                contactIds.add(booking.Passenger__c);
            }
        }
        
        Map<Id, Contact> contacts = new Map<Id, Contact>(
            [
                SELECT Id, FirstName, Email
                FROM Contact
                WHERE Id IN :contactIds
            ]
        );
        
        for(Booking__c booking : bookings){
            
            Contact passenger = contacts.get(booking.Passenger__c);
            
            if(passenger == null || String.isBlank(passenger.Email)){
                continue;
            }
            
            Messaging.SingleEmailMessage email =
                new Messaging.SingleEmailMessage();
            
            email.setToAddresses(
                new List<String>{passenger.Email}
            );
            
            email.setSubject('Booking Cancelled');
            
            email.setPlainTextBody(
                'Hi ' + passenger.FirstName +
                ',\n\nYour booking has been cancelled.' +
                '\n\nIf applicable, your refund will be processed shortly.'
            );
            
            emails.add(email);
        }
        
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
        
    }
    
    public static void sendDepartureReminder(
        List<Booking__c> bookings
    ){
        
        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();
        
        Set<Id> contactIds = new Set<Id>();
        
        for(Booking__c booking : bookings){
            
            if(booking.Passenger__c != null){
                contactIds.add(booking.Passenger__c);
            }
            
        }
        
        Map<Id, Contact> contacts = new Map<Id, Contact>(
            [
                SELECT Id,
                FirstName,
                Email
                FROM Contact
                WHERE Id IN :contactIds
            ]
        );
        
        for(Booking__c booking : bookings){
            
            Contact passenger =
                contacts.get(booking.Passenger__c);
            
            if(
                passenger == null ||
                String.isBlank(passenger.Email)
            ){
                continue;
            }
            
            Messaging.SingleEmailMessage email =
                new Messaging.SingleEmailMessage();
            
            email.setToAddresses(
                new List<String>{ passenger.Email }
            );
            
            email.setSubject(
                'Flight Departure Reminder'
            );
            
            email.setPlainTextBody(
                'Hi ' + passenger.FirstName +
                ',\n\nThis is a reminder that your flight departs tomorrow.' +
                '\n\nPlease arrive at the airport at least 2 hours before departure.' +
                '\n\nThank you for choosing SkyBook Pro.'
            );
            
            emails.add(email);
            
        }
        
        if(!emails.isEmpty()){
            
            Messaging.sendEmail(emails);
            
        }
        
    }

}