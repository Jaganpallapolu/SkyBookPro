public with sharing class ItineraryController {

    public Booking__c booking {get;set;}

    public ItineraryController() {

        Id bookingId = ApexPages.currentPage().getParameters().get('id');

        booking = [

            SELECT
                Name,
                Booking_Date__c,
                Booking_Status__c,
                Seat_Class__c,
                Base_Fare__c,
                Total_Amount__c,

                Passenger__r.FirstName,
                Passenger__r.LastName,

                Flight__r.Airline_Name__c,
                Flight__r.Flight_Number__c,
                Flight__r.Origin_Airport__c,
                Flight__r.Destination_Airport__c,
                Flight__r.Depature_DateTime__c,
                Flight__r.Arrival_DateTime__c

            FROM Booking__c

            WHERE Id = :bookingId

            LIMIT 1

        ];

    }

}