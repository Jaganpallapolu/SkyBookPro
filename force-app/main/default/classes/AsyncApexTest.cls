@isTest
private class AsyncApexTest {
    
    @testSetup
    static void setup(){
        
        Account acc = TestDataFactory.createAccount();
        
        Contact con = TestDataFactory.createPassenger(acc.Id);
        
        Flight__c flight = TestDataFactory.createFlight();
        
        Booking__c booking = TestDataFactory.createBooking(con.Id);
        
        booking.Flight__c = flight.Id;
        
        booking.Booking_Status__c = 'Confirmed';
        
        update booking;
        
    }
    
    @isTest
    static void testFutureBookingConfirmationEmail(){
        
        Set<Id> bookingIds = new Set<Id>();
        
        for(Booking__c booking : [
            SELECT Id
            FROM Booking__c
        ]){
            bookingIds.add(booking.Id);
        }
        
        Test.startTest();
        
        BookingEmailFutureService.sendBookingConfirmationEmail(
            bookingIds
        );
        
        Test.stopTest();
        
        System.assertEquals(
            1,
            bookingIds.size(),
            'One booking should exist.'
        );
        
    }
    
    
    @isTest
    static void testDuffelTokenRefreshJob(){
        
        Test.startTest();
        
        System.enqueueJob(
            new DuffelTokenRefreshJob()
        );
        
        Test.stopTest();
        
        AsyncApexJob job = [
            SELECT Id,
            Status,
            JobType,
            NumberOfErrors
            FROM AsyncApexJob
            WHERE JobType = 'Queueable'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        
        System.assertEquals(
            'Completed',
            job.Status
        );
        
        System.assertEquals(
            0,
            job.NumberOfErrors
        );
        
    }
    
    @isTest
    static void testBookingArchiveBatch(){
        
        // Create a cancelled booking
        Booking__c booking = [
            SELECT Id,
            Booking_Status__c,
            Booking_Date__c,
            Archive__c
            FROM Booking__c
            LIMIT 1
        ];
        
        booking.Booking_Status__c = 'Cancelled';
        booking.Cancellation_Reason__c = 'Customer Request';
        booking.Booking_Date__c = Date.today().addYears(-3);
        
        update booking;
        
        Test.startTest();
        
        Database.executeBatch(
            new BookingArchiveBatch(),
            200
        );
        
        Test.stopTest();
        
        Booking__c updatedBooking = [
            SELECT Archive__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];
        
        System.assertEquals(
            true,
            updatedBooking.Archive__c
        );
        
    }
    
    @isTest
    static void testDailyDepartureReminderScheduler(){
        
        Test.startTest();
        
        System.schedule(
            'SchedulerTest' + System.currentTimeMillis(),
            '0 0 0 15 12 ? 2099',
            new DailyDepartureReminderScheduler()
        );
        
        Test.stopTest();
        
        System.assert(true);
        
    }
}