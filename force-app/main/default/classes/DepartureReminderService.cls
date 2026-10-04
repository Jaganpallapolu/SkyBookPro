public with sharing class DepartureReminderService {

    public static void sendTomorrowDepartureReminders(){

        List<Booking__c> bookings = [
            SELECT Id,
                   Name,
                   Passenger__c,
                   Booking_Status__c,
                   Flight__r.Depature_DateTime__c
            FROM Booking__c
            WHERE Booking_Status__c = 'Confirmed'
            AND Flight__r.Depature_DateTime__c = TOMORROW
        ];

        System.debug(
            'Bookings departing tomorrow: ' + bookings.size()
        );

    }

}