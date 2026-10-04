@isTest
private class BookingEmailServiceTest {

    @testSetup
    static void setup(){

        Account acc = TestDataFactory.createAccount();

        Contact con = TestDataFactory.createPassenger(acc.Id);

        Flight__c flight = TestDataFactory.createFlight();

        Booking__c booking = TestDataFactory.createBooking(con.Id);

        booking.Flight__c = flight.Id;

        update booking;
      
    }
    @isTest
    static void testSendBookingConfirmation(){
        
        List<Booking__c> bookings = [
            SELECT Id,
            Passenger__c,
            Booking_Status__c
            FROM Booking__c
        ];
        
        Test.startTest();
        
        BookingEmailService.sendBookingConfirmation(
            bookings
        );
        
        Test.stopTest();
        
        System.assertEquals(
            1,
            bookings.size()
        );
        
    }
    @isTest
    static void testSendBookingCancellation(){
        
        Booking__c booking = [
            SELECT Id,
            Passenger__c,
            Booking_Status__c,
            Cancellation_Reason__c
            FROM Booking__c
            LIMIT 1
        ];
        
        booking.Booking_Status__c='Cancelled';
        
        booking.Cancellation_Reason__c='Customer Request';
        
        update booking;
        
        Test.startTest();
        
        BookingEmailService.sendBookingCancellation(
            new List<Booking__c>{booking}
        );
        
        Test.stopTest();
        
        System.assertEquals(
            'Cancelled',
            booking.Booking_Status__c
        );
        
    }
    @isTest
    static void testSendDepartureReminder(){
        
        List<Booking__c> bookings = [
            SELECT Id,
            Passenger__c
            FROM Booking__c
        ];
        
        Test.startTest();
        
        BookingEmailService.sendDepartureReminder(
            bookings
        );
        
        Test.stopTest();
        
        System.assertEquals(
            1,
            bookings.size()
        );
        
    }
  
}