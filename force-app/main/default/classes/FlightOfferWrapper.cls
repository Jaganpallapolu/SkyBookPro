public class FlightOfferWrapper {

    @AuraEnabled
    public String offerId;

    @AuraEnabled
    public String airline;

    @AuraEnabled
    public String airlineCode;

    @AuraEnabled
    public String flightNumber;

    @AuraEnabled
    public String origin;

    @AuraEnabled
    public String destination;

    @AuraEnabled
    public String originAirport;

    @AuraEnabled
    public String destinationAirport;

    @AuraEnabled
    public String departureTime;

    @AuraEnabled
    public String arrivalTime;

    @AuraEnabled
    public Decimal price;

    @AuraEnabled
    public String currencyCode;

    @AuraEnabled
    public String duration;
    
    @AuraEnabled
    public String passengerId;
    
    @AuraEnabled
    public String cabinClass;

    @AuraEnabled
    public String offerJson;

}