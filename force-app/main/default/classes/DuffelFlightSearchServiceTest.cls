@isTest
private class DuffelFlightSearchServiceTest {

    @isTest
    static void testSearchFlights(){

        Test.setMock(
            HttpCalloutMock.class,
            new DuffelFlightSearchMock()
        );

        Test.startTest();

        List<FlightOfferWrapper> offers =
            DuffelFlightSearchService.searchFlights(
                'HYD',
                'DEL',
                Date.newInstance(2026,8,15),
                1,
                'Economy'
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            offers,
            'Offers should not be null.'
        );

        System.assertEquals(
            1,
            offers.size(),
            'One offer should be returned.'
        );

        FlightOfferWrapper offer = offers[0];

        System.assertEquals(
            'off_test123',
            offer.offerId
        );

        System.assertEquals(
            'Air India',
            offer.airline
        );

        System.assertEquals(
            5500,
            offer.price
        );

        System.assertEquals(
            'INR',
            offer.currencyCode
        );

        System.assertEquals(
            'HYD',
            offer.origin
        );

        System.assertEquals(
            'DEL',
            offer.destination
        );

        System.assertEquals(
            '101',
            offer.flightNumber
        );

    }

}