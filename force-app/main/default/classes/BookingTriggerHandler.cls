public with sharing class BookingTriggerHandler {

    public static void beforeInsert(List<Booking__c> newBookings){
        
        for(Booking__c booking : newBookings){
            
            // Set Booking Date
            if(booking.Booking_Date__c == null){
                booking.Booking_Date__c = Date.today();
            }
            
            // Set Default Status
            if(String.isBlank(booking.Booking_Status__c)){
                booking.Booking_Status__c = 'Draft';
            }
            
        }
        
    }

    public static void beforeUpdate(
        List<Booking__c> newBookings,
        Map<Id, Booking__c> oldMap
    ){
        
        for(Booking__c booking : newBookings){
            
            Booking__c oldBooking = oldMap.get(booking.Id);
            
            // Prevent Cancelled -> Confirmed
            if(
                oldBooking.Booking_Status__c == 'Cancelled' &&
                booking.Booking_Status__c == 'Confirmed'
            ){
                booking.addError(
                    'A cancelled booking cannot be changed back to Confirmed.'
                );
            }
            
        }
        
    }

    public static void afterInsert(List<Booking__c> newBookings){
        
        
        
        BookingEmailService.sendBookingConfirmation(newBookings);
        
    }

    public static void afterUpdate(
        List<Booking__c> newBookings,
        Map<Id, Booking__c> oldMap
    ){
        
        
        List<Booking__c> confirmedBookings = new List<Booking__c>();
        List<Booking__c> cancelledBookings = new List<Booking__c>();
        
        for(Booking__c booking : newBookings){
            
            Booking__c oldBooking = oldMap.get(booking.Id);
            
            // Draft -> Confirmed
            if(
                oldBooking.Booking_Status__c != 'Confirmed' &&
                booking.Booking_Status__c == 'Confirmed'
            ){
                confirmedBookings.add(booking);
            }
            
            // Status -> Cancelled
            if(
                oldBooking.Booking_Status__c != 'Cancelled' &&
                booking.Booking_Status__c == 'Cancelled'
            ){
                cancelledBookings.add(booking);
            }
            
        }
        
        if(!confirmedBookings.isEmpty()){
            BookingEmailService.sendBookingConfirmation(
                confirmedBookings
            );
        }
        
        if(!cancelledBookings.isEmpty()){
            BookingEmailService.sendBookingCancellation(
                cancelledBookings
            );
        }
        
    }

}