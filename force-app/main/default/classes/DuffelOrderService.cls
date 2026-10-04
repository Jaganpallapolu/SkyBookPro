public with sharing class DuffelOrderService {

    @AuraEnabled
    public static String createOrder(
        String offerId,
        String passengerId,
        Contact passenger,
        Passenger_Detail__c passengerDetail,
        Decimal amount,
        String currencyCode
    ){
        
        HttpRequest req = new HttpRequest();
        
       req.setEndpoint('https://api.duffel.com/air/orders');
        
        req.setMethod('POST');
        
        req.setHeader('Content-Type', 'application/json');
        
        req.setHeader('Accept', 'application/json');
        
        req.setHeader('Duffel-Version', 'v2');
        
        req.setHeader(
            'Authorization',
            'Bearer duffel_test_H6etSEcpnuGYo3qs0mDuX4-1F5_48Aa8M4WslVHN8zs'
        );
        
        
        
        Map<String,Object> passengerMap = new Map<String,Object>();
        
        passengerMap.put('id', passengerId);
        
        passengerMap.put('given_name', passenger.FirstName);
        passengerMap.put('family_name', passenger.LastName);
        passengerMap.put('email', passenger.Email);
        passengerMap.put('phone_number', passenger.Phone);
        passengerMap.put('born_on', String.valueOf(passengerDetail.Date_of_Birth__c));
        if(passengerDetail.Gender__c == 'Male'){
            passengerMap.put('gender', 'm');
        }
        else if(passengerDetail.Gender__c == 'Female'){
            passengerMap.put('gender', 'f');
        }
        if(passengerDetail.Title__c == 'Mr'){
            passengerMap.put('title', 'mr');
        }
        else if(passengerDetail.Title__c == 'Mrs'){
            passengerMap.put('title', 'mrs');
        }
        else if(passengerDetail.Title__c == 'Miss'){
            passengerMap.put('title', 'miss');
        }
        else if(passengerDetail.Title__c == 'Ms'){
            passengerMap.put('title', 'ms');
        }
        
        Map<String,Object> data = new Map<String,Object>();
        
        data.put('type', 'instant');
        data.put('selected_offers', new List<String>{offerId});
        data.put('passengers', new List<Object>{passengerMap});
        
        Map<String,Object> body = new Map<String,Object>();
        
        body.put('data', data);
        
        req.setBody(JSON.serialize(body));
        
        Http http = new Http();
        
        HttpResponse res = http.send(req);
        
        System.debug('Status Code: ' + res.getStatusCode());
        System.debug('Response: ' + res.getBody());
        
        if(res.getStatusCode() != 201){
            System.debug('Status Code: ' + res.getStatusCode());
            System.debug('Response Body: ' + res.getBody());
            
            throw new AuraHandledException(res.getBody());
        }
        
        Map<String,Object> response =
            (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
        
        Map<String,Object> responseData =
            (Map<String,Object>)response.get('data');
        
        String orderId = (String)responseData.get('id');
        
        return orderId;

    }

}