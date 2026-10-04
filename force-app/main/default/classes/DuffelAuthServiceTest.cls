@isTest
private class DuffelAuthServiceTest {

    @isTest
    static void testGetApiKey(){

        Test.startTest();

        String apiKey = DuffelAuthService.getApiKey();

        Test.stopTest();

        System.assertNotEquals(
            null,
            apiKey,
            'API Key should not be null.'
        );

        System.assert(
            apiKey.length() > 0,
            'API Key should not be empty.'
        );

    }

}