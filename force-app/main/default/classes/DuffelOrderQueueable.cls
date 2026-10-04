public with sharing class DuffelOrderQueueable
implements Queueable, Database.AllowsCallouts {
    
    private Id bookingId;
    
    public DuffelOrderQueueable(Id bookingId){
        this.bookingId = bookingId;
    }
    
    public void execute(QueueableContext context){
        
        // Get Booking
        Booking__c booking = [
            SELECT Id,
            Passenger__c,
            Booking_Status__c,
            Duffel_Order_Id__c
            FROM Booking__c
            WHERE Id = :bookingId
            LIMIT 1
        ];
        
        // Create Duffel Order
        String orderId =
            DuffelOrderService.createOrder(booking);
        
        // Save Duffel Order Id
        if(!String.isBlank(orderId)){
            
            booking.Duffel_Order_Id__c = orderId;
            
            update booking;
            
        }
        
    }
    
}