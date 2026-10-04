@isTest
global class DuffelOrderMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req){

        HttpResponse res = new HttpResponse();

        res.setStatusCode(201);

        res.setHeader('Content-Type','application/json');

        res.setBody(
            '{' +
                '"data":{' +
                    '"id":"ord_test123"' +
                '}' +
            '}'
        );

        return res;

    }

}