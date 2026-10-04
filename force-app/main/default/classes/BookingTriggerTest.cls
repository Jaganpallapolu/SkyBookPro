@isTest
private class BookingTriggerTest {
    
    @testSetup
    static void setup(){
        
        Account acc = TestDataFactory.createAccount();
        
        Contact con = TestDataFactory.createPassenger(acc.Id);
        
        Booking__c booking =
            TestDataFactory.createBooking(con.Id);

        
    }
    
    
    @isTest
    static void testBeforeInsert_DefaultValues(){
        
        Account acc = TestDataFactory.createAccount();
        
        Contact con = TestDataFactory.createPassenger(acc.Id);

		Flight__c flight = TestDataFactory.createFlight();
        
        Booking__c booking = new Booking__c();
        
        booking.Passenger__c = con.Id;
        
        booking.Seat_Class__c = 'Economy';
        
        booking.Number_of_Seats__c = 1;
        
        booking.Base_Fare__c = 1000;
        
        booking.Taxes_Fees__c = 100;
        
        booking.Agent__c = UserInfo.getUserId();

		booking.Flight__c = flight.Id;
        
        Test.startTest();
        
        insert booking;
        
        Test.stopTest();
        
        Booking__c insertedBooking = [
            SELECT Booking_Date__c,
            Booking_Status__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];
        
        System.assertEquals(
            Date.today(),
            insertedBooking.Booking_Date__c,
            'Booking Date should default to today.'
        );
        
        System.assertEquals(
            'Draft',
            insertedBooking.Booking_Status__c,
            'Booking Status should default to Draft.'
        );
        
    }
    
    
    @isTest
    static void testCancelledBookingCannotBeConfirmed(){
        
        Booking__c booking = [
            SELECT Id,
            Booking_Status__c,
            Cancellation_Reason__c
            FROM Booking__c
            LIMIT 1
        ];
        
        // Cancel the booking
        booking.Booking_Status__c = 'Cancelled';
        booking.Cancellation_Reason__c = 'Customer Request';
        
        update booking;
        
        // Try to confirm again
        booking.Booking_Status__c = 'Confirmed';
        
        Test.startTest();
        
        try{
            
            update booking;
            
            System.assert(false,
                          'Expected an exception but none was thrown.');
            
        }
        catch(DmlException e){
            
            System.assert(
                e.getMessage().contains(
                    'A cancelled booking cannot be changed back to Confirmed.'
                )
            );
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testAfterUpdate_DraftToConfirmed(){
        
        Account acc = TestDataFactory.createAccount();
        
        Contact con = TestDataFactory.createPassenger(acc.Id);
        
        Flight__c flight = TestDataFactory.createFlight();
        
        Booking__c booking = new Booking__c();
        
        booking.Passenger__c = con.Id;
        booking.Flight__c = flight.Id;
        booking.Seat_Class__c = 'Economy';
        booking.Number_of_Seats__c = 1;
        booking.Base_Fare__c = 1000;
        booking.Taxes_Fees__c = 100;
        booking.Agent__c = UserInfo.getUserId();
        
        insert booking;
        
        // Default status is Draft from beforeInsert()
        
        booking.Booking_Status__c = 'Confirmed';
        
        Test.startTest();
        
        update booking;
        
        Test.stopTest();
        
        Booking__c updatedBooking = [
            SELECT Booking_Status__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];
        
        System.assertEquals(
            'Confirmed',
            updatedBooking.Booking_Status__c
        );
        
    }
    
    @isTest
    static void testAfterUpdate_ConfirmedToCancelled(){
        
        Booking__c booking = [
            SELECT Id,
            Booking_Status__c,
            Cancellation_Reason__c
            FROM Booking__c
            LIMIT 1
        ];
        
        booking.Booking_Status__c = 'Cancelled';
        
        booking.Cancellation_Reason__c = 'Customer Request';
        
        Test.startTest();
        
        update booking;
        
        Test.stopTest();
        
        Booking__c updatedBooking = [
            SELECT Booking_Status__c,
            Cancellation_Reason__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];
        
        System.assertEquals(
            'Cancelled',
            updatedBooking.Booking_Status__c
        );
        
        System.assertEquals(
            'Customer Request',
            updatedBooking.Cancellation_Reason__c
        );
        
    }

}