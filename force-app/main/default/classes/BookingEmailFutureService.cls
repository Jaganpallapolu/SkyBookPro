public with sharing class BookingEmailFutureService {

    @future
    public static void sendBookingConfirmationEmail(Set<Id> bookingIds) {
        
        if(bookingIds == null || bookingIds.isEmpty()){
            return;
        }
        
        List<Booking__c> bookings = [
            SELECT Id,
            Name,
            Booking_Date__c,
            Booking_Status__c,
            Passenger__r.FirstName,
            Passenger__r.LastName,
            Passenger__r.Email
            FROM Booking__c
            WHERE Id IN :bookingIds
        ];
        
        
        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();
        
        for(Booking__c booking : bookings){
            
            if(String.isBlank(booking.Passenger__r.Email)){
                continue;
            }
            
            Messaging.SingleEmailMessage email =
                new Messaging.SingleEmailMessage();
            
            email.setToAddresses(
                new List<String>{ booking.Passenger__r.Email }
            );
            
            email.setSubject(
                'Booking Confirmation - ' + booking.Name
            );
            
            String body =
                'Dear ' +
                booking.Passenger__r.FirstName +
                ',\n\n' +
                'Your booking has been created successfully.\n\n' +
                'Booking Reference : ' + booking.Name + '\n' +
                'Booking Date : ' + booking.Booking_Date__c + '\n' +
                'Booking Status : ' + booking.Booking_Status__c + '\n\n' +
                'Thank you for choosing SkyBook Pro.';
            
            email.setPlainTextBody(body);
            
            emails.add(email);
        }
        
        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
        
    }

}