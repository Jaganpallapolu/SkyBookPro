@isTest
private class BookingServiceTest {
    @testSetup
    static void setup(){
        
        Account acc = TestDataFactory.createAccount();
        
        Contact con = TestDataFactory.createPassenger(acc.Id);
        
    }
    
    private static String getOfferJson(){
        
        return '{' +
            '"id":"off_test123",' +
            '"total_amount":"1000.00",' +
            '"total_currency":"INR",' +
            '"owner":{' +
            '"name":"Air India",' +
            '"iata_code":"AI"' +
            '},' +
            '"slices":[{' +
            '"duration":"PT2H",' +
            '"segments":[{' +
            '"departing_at":"2026-12-25T10:00:00Z",' +
            '"arriving_at":"2026-12-25T12:00:00Z",' +
            '"operating_carrier_flight_number":"AI101",' +
            '"origin":{' +
            '"iata_code":"HYD",' +
            '"name":"Hyderabad"' +
            '},' +
            '"destination":{' +
            '"iata_code":"DEL",' +
            '"name":"Delhi"' +
            '}' +
            '}]' +
            '}]' +
            '}';
        
    }
    
    @isTest
    static void testCreateBookingSuccessfully(){
        
        Contact passenger = [
            SELECT Id
            FROM Contact
            LIMIT 1
        ];
        
        Flight__c flight = TestDataFactory.createFlight();
        
        Test.startTest();
        
        Booking__c booking = BookingService.createBooking(
            passenger.Id,
            flight.Id,
            'off_test123',
            getOfferJson(),
            1,
            'Economy',
            Date.newInstance(1995,5,15),
            'Male',
            'Mr',
            'P1234567'
        );
        
        Test.stopTest();
        
        System.assertNotEquals(
            null,
            booking.Id,
            'Booking should be created.'
        );
        
        Booking__c insertedBooking = [
            SELECT Id,
            Passenger__c,
            Booking_Status__c
            FROM Booking__c
            WHERE Id = :booking.Id
        ];
        
        System.assertEquals(
            passenger.Id,
            insertedBooking.Passenger__c
        );
        
        Passenger_Detail__c passengerDetail = [
            SELECT Id
            FROM Passenger_Detail__c
            WHERE Booking__c = :booking.Id
            LIMIT 1
        ];
        
        System.assertNotEquals(
            null,
            passengerDetail.Id
        );
        
        Flight_Segment__c segment = [
            SELECT Id
            FROM Flight_Segment__c
            WHERE Booking__c = :booking.Id
            LIMIT 1
        ];
        
        System.assertNotEquals(
            null,
            segment.Id
        );
        
    }
    
    @isTest
    static void testCreateBooking_NullPassenger(){
        
        Flight__c flight = TestDataFactory.createFlight();
        
        Boolean exceptionThrown = false;
        
        try{
            
            BookingService.createBooking(
                null,
                flight.Id,
                'off_test123',
                getOfferJson(),
                1,
                'Economy',
                Date.newInstance(1995,5,15),
                'Male',
                'Mr',
                'P123456'
            );
            
        }catch(Exception e){
            
            exceptionThrown = true;
            
        }
        
        System.assertEquals(true, exceptionThrown);
        
    }
    
    
    @isTest
    static void testCreateBooking_NullFlight(){
        
        Account acc = TestDataFactory.createAccount();
        
        Contact con = TestDataFactory.createPassenger(acc.Id);
        
        Boolean exceptionThrown = false;
        
        try{
            
            BookingService.createBooking(
                con.Id,
                null,
                'off_test123',
                getOfferJson(),
                1,
                'Economy',
                Date.newInstance(1995,5,15),
                'Male',
                'Mr',
                'P123456'
            );
            
        }catch(Exception e){
            
            exceptionThrown = true;
            
        }
        
        System.assertEquals(true, exceptionThrown);
        
    }
    
    @isTest
    static void testCreateBooking_BlankOfferId(){
        
        Account acc = TestDataFactory.createAccount();
        
        Contact con = TestDataFactory.createPassenger(acc.Id);
        
        Flight__c flight = TestDataFactory.createFlight();
        
        Boolean exceptionThrown = false;
        
        try{
            
            BookingService.createBooking(
                con.Id,
                flight.Id,
                '',
                getOfferJson(),
                1,
                'Economy',
                Date.newInstance(1995,5,15),
                'Male',
                'Mr',
                'P123456'
            );
            
        }catch(Exception e){
            
            exceptionThrown = true;
            
        }
        
        System.assertEquals(true, exceptionThrown);
        
    }
    
    
}