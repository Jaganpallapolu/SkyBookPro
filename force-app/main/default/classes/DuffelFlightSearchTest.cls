@IsTest
public class DuffelFlightSearchTest {

    @IsTest
    static void testSearchFlights() {

        Test.startTest();

        List<FlightOfferWrapper> flights =
            DuffelFlightSearchService.searchFlights(
                'HYD',
                'DEL',
                Date.today().addDays(15),
                1,
                'economy'
            );

        Test.stopTest();

        System.debug('Flights : ' + flights);

    }

}