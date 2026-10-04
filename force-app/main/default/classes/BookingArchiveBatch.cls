public with sharing class BookingArchiveBatch
    implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator([
            SELECT Id,
                   Booking_Date__c,
                   Booking_Status__c,
                   Archive__c
            FROM Booking__c
            WHERE Booking_Date__c <= :Date.today().addYears(-2)
            AND Archive__c = false
            AND (
                Booking_Status__c = 'Completed'
                OR Booking_Status__c = 'Cancelled'
            )
        ]);
    }

    public void execute(
        Database.BatchableContext bc,
        List<Booking__c> scope
    ){
        for(Booking__c booking : scope){
            
            booking.Archive__c = true;
            
        }
        
        if(!scope.isEmpty()){
            update scope;
        }


    }

    public void finish(Database.BatchableContext bc){
		
         System.debug('Booking Archive Batch Completed Successfully.');

    }

}