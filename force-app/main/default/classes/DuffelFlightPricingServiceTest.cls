@isTest
private class DuffelFlightPricingServiceTest {
    
    private static String getOfferJson() {
        
        return '{' +
            '"id":"off_test123",' +
            '"total_amount":"5500.00",' +
            '"total_currency":"INR",' +
            '"owner":{' +
            '"name":"Air India",' +
            '"iata_code":"AI"' +
            '},' +
            '"slices":[{' +
            '"duration":"PT2H",' +
            '"segments":[{' +
            '"departing_at":"2026-08-15T10:00:00Z",' +
            '"arriving_at":"2026-08-15T12:00:00Z",' +
            '"operating_carrier_flight_number":"101",' +
            '"origin":{' +
            '"iata_code":"HYD",' +
            '"name":"Rajiv Gandhi International Airport"' +
            '},' +
            '"destination":{' +
            '"iata_code":"DEL",' +
            '"name":"Indira Gandhi International Airport"' +
            '}' +
            '}]' +
            '}]' +
            '}';
    }
    
    @isTest
    static void testConfirmFlightPrice(){
        
        Test.startTest();
        
        FlightOfferWrapper wrapper =
            DuffelFlightPricingService.confirmFlightPrice(
                'off_test123',
                getOfferJson()
            );
        
        Test.stopTest();
        
        System.assertEquals(
            'off_test123',
            wrapper.offerId
        );
        
        System.assertEquals(
            5500,
            wrapper.price
        );
        
        System.assertEquals(
            'INR',
            wrapper.currencyCode
        );
        
        System.assertEquals(
            'Air India',
            wrapper.airline
        );
        
        System.assertEquals(
            'HYD',
            wrapper.origin
        );
        
        System.assertEquals(
            'DEL',
            wrapper.destination
        );
        
        System.assertEquals(
            '101',
            wrapper.flightNumber
        );
        
    }
    
    @isTest
    static void testOfferIdMismatch(){
        
        Test.startTest();
        
        Boolean exceptionThrown = false;
        
        try{
            
            DuffelFlightPricingService.confirmFlightPrice(
                'wrong_offer',
                getOfferJson()
            );
            
        }catch(Exception e){
            
            exceptionThrown = true;
            
        }
        
        Test.stopTest();
        
        System.assertEquals(
            true,
            exceptionThrown,
            'Expected an exception for Offer ID mismatch.'
        );
        
    }
    
    @isTest
    static void testEmptyJson(){
        
        Test.startTest();
        
        Boolean exceptionThrown = false;
        
        try{
            
            DuffelFlightPricingService.confirmFlightPrice(
                'off_test123',
                ''
            );
            
        }catch(Exception e){
            
            exceptionThrown = true;
            
        }
        
        Test.stopTest();
        
        System.assertEquals(
            true,
            exceptionThrown,
            'Expected an exception for empty JSON.'
        );
        
    }
    
}