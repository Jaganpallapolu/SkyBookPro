@isTest
public class TestDataFactory {
    public static Account createAccount(){
        
        Account acc = new Account();
        
        acc.Name = 'Test Account';
        
        insert acc;
        
        return acc;
        
    }
    
    public static Contact createPassenger(Id accountId){
        
        Contact con = new Contact();
        
        con.FirstName = 'John';
        
        con.LastName = 'Doe';
        
        con.Email = 'john.doe@test.com';
        
        con.Phone = '9876543210';
        
        con.AccountId = accountId;
        
        insert con;
        
        return con;
        
    }
    
    public static Booking__c createBooking(Id passengerId){

        Flight__c flight = createFlight();
        
        Booking__c booking = new Booking__c();
        
        booking.Passenger__c = passengerId;
        
        booking.Booking_Date__c = Date.today();
        
        booking.Booking_Status__c = 'Confirmed';
        
        booking.Seat_Class__c = 'Economy';
        
        booking.Number_of_Seats__c = 1;
        
        booking.Base_Fare__c = 10000;
        
        booking.Taxes_Fees__c = 500;
        
        booking.Agent__c = UserInfo.getUserId();
        
        booking.Flight__c = flight.Id;
        
        insert booking;
        
        return booking;
        
    }
    
    public static Passenger_Detail__c createPassengerDetail(Id bookingId){
        
        Passenger_Detail__c passengerDetail = new Passenger_Detail__c();
        
        passengerDetail.Booking__c = bookingId;
        
        passengerDetail.First_Name__c = 'John';
        
        passengerDetail.Last_Name__c = 'Doe';
        
        passengerDetail.Passenger_Type__c = 'Adult';
        
        passengerDetail.Gender__c = 'Male';
        
        passengerDetail.Title__c = 'Mr';
        
        passengerDetail.Date_of_Birth__c = Date.newInstance(1995, 5, 15);
        
        insert passengerDetail;
        
        return passengerDetail;
        
    }
    
    public static Flight_Segment__c createFlightSegment(Id bookingId){
        
        Flight_Segment__c segment = new Flight_Segment__c();
        
        segment.Booking__c = bookingId;
        
        segment.Flight_Number__c = 'AI101';
        
        segment.Origin__c = 'HYD';
        
        segment.Destination__c = 'DEL';
        
        segment.Depature_DateTime__c = System.now().addDays(10);
        
        segment.Arrival_DateTime__c =
            System.now().addDays(10).addHours(2);
        
        segment.Carrier_Code__c = 'AI';
        
        segment.Segment_Order__c = 1;
        
        insert segment;
        
        return segment;
        
    }

    public static Flight__c createFlight(){
        
        Flight__c flight = new Flight__c();
        
        flight.Name = 'AI101 Hyderabad - Delhi';
        
        flight.Flight_Number__c = 'AI101';
        
        flight.Origin_Airport__c = 'HYD';
        
        flight.Destination_Airport__c = 'DEL';
        
        flight.Depature_DateTime__c = System.now().addDays(5);
        
        flight.Arrival_DateTime__c =
            System.now().addDays(5).addHours(2);
        
        flight.Airline_Name__c = 'Air India';
        
        flight.Duration_Minutes__c = 120;
        
        flight.Status__c = 'Active';
        
        insert flight;
        
        return flight;
        
    }

}