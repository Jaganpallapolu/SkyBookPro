@isTest
private class DuffelOrderServiceTest {

    @testSetup
    static void setup(){

        Account acc = TestDataFactory.createAccount();

        Contact con = TestDataFactory.createPassenger(acc.Id);

        Flight__c flight = TestDataFactory.createFlight();

        Booking__c booking = TestDataFactory.createBooking(con.Id);

        booking.Flight__c = flight.Id;

        update booking;

        TestDataFactory.createPassengerDetail(
            booking.Id
        );

    }

    @isTest
    static void testCreateOrder(){

        Test.setMock(
            HttpCalloutMock.class,
            new DuffelOrderMock()
        );

        Contact passenger = [
            SELECT Id,
                   FirstName,
                   LastName,
                   Email,
                   Phone
            FROM Contact
            LIMIT 1
        ];

        Passenger_Detail__c passengerDetail = [
            SELECT Date_of_Birth__c,
                   Gender__c,
                   Title__c
            FROM Passenger_Detail__c
            LIMIT 1
        ];

        Test.startTest();

        String orderId =
            DuffelOrderService.createOrder(
                'off_test123',
                'pas_123',
                passenger,
                passengerDetail,
                5500,
                'INR'
            );

        Test.stopTest();

        System.assertEquals(
            'ord_test123',
            orderId
        );

    }

}