@isTest
global class DuffelFlightSearchMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {

        HttpResponse res = new HttpResponse();

        res.setStatusCode(200);

        res.setHeader('Content-Type','application/json');

        res.setBody(
        '{'+
            '"data":{'+
                '"offers":['+
                    '{'+
                        '"id":"off_test123",'+
                        '"total_amount":"5500.00",'+
                        '"total_currency":"INR",'+
                        '"owner":{'+
                            '"name":"Air India",'+
                            '"iata_code":"AI"'+
                        '},'+
                        '"slices":['+
                            '{'+
                                '"duration":"PT2H",'+
                                '"segments":['+
                                    '{'+
                                        '"departing_at":"2026-08-15T10:00:00Z",'+
                                        '"arriving_at":"2026-08-15T12:00:00Z",'+
                                        '"operating_carrier_flight_number":"101",'+
                                        '"origin":{'+
                                            '"iata_code":"HYD",'+
                                            '"name":"Rajiv Gandhi International Airport"'+
                                        '},'+
                                        '"destination":{'+
                                            '"iata_code":"DEL",'+
                                            '"name":"Indira Gandhi International Airport"'+
                                        '}'+
                                    '}'+
                                ']'+
                            '}'+
                        ']'+
                    '}'+
                ']'+
            '}'+
        '}'
        );

        return res;

    }

}