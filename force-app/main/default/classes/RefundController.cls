public with sharing class RefundController {

    public class RefundWrapper{

        @AuraEnabled public Refund__c refund;

        @AuraEnabled public Integer progress;

    }

    @AuraEnabled(cacheable=true)
    public static RefundWrapper getRefundStatus(Id bookingId){

        if(bookingId == null){

            throw new AuraHandledException(
                'Booking Id is required.'
            );

        }

        List<Refund__c> refunds=[

            SELECT

                Id,
                Name,
                Refund_Status__c,
                Refund_Amount__c,
                Refund_Reference__c,
                Requested_Date__c,
                Completed_Date__c,

                Booking__r.Name,
                Booking__r.Booking_Status__c,
                Booking__r.Total_Amount__c

            FROM Refund__c

            WHERE Booking__c=:bookingId

            LIMIT 1

        ];

        if(refunds.isEmpty()){

            throw new AuraHandledException(
                'Refund record not found.'
            );

        }

        RefundWrapper wrapper = new RefundWrapper();

        wrapper.refund = refunds[0];

        String status = refunds[0].Refund_Status__c;

        if(status == 'Requested'){

            wrapper.progress = 25;

        }
        else if(status == 'Approved'){

            wrapper.progress = 50;

        }
        else if(status == 'Processing'){

            wrapper.progress = 75;

        }
        else if(status == 'Completed'){

            wrapper.progress = 100;

        }
        else{

            wrapper.progress = 0;

        }

        return wrapper;

    }

}