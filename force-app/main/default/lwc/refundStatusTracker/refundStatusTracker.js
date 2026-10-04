import { LightningElement, api, wire } from 'lwc';
import getRefundStatus from '@salesforce/apex/RefundController.getRefundStatus';

export default class RefundStatusTracker extends LightningElement {

    @api bookingId;

    refund;

    progress = 0;

    error;

    @wire(getRefundStatus, { bookingId: '$bookingId' })
    wiredRefund({ error, data }) {

        if (data) {

            this.refund = data.refund;

            this.progress = data.progress;

            this.error = undefined;

        }

        else if (error) {

            this.error = error;

            this.refund = undefined;

        }

    }

    // -----------------------------
    // Amount
    // -----------------------------

    get formattedRefundAmount() {

    const inr =
        Number(this.refund?.Refund_Amount__c || 0) * 86.50;

    return new Intl.NumberFormat('en-IN', {

        style: 'currency',

        currency: 'INR',

        minimumFractionDigits: 2,

        maximumFractionDigits: 2

    }).format(inr);

}

    // -----------------------------
    // Status Badge
    // -----------------------------

    get statusClass() {

        if (!this.refund) {

            return 'status-badge';

        }

        switch (this.refund.Refund_Status__c) {

            case 'Requested':

                return 'status-badge requested';

            case 'Approved':

                return 'status-badge approved';

            case 'Processing':

                return 'status-badge processing';

            case 'Completed':

                return 'status-badge completed';

            default:

                return 'status-badge';

        }

    }

    // -----------------------------
    // Timeline Classes
    // -----------------------------

    get requestedClass() {

        return 'timeline-item active';

    }

    get processingClass() {

        if (

            this.progress >= 50

        ) {

            return 'timeline-item active';

        }

        return 'timeline-item';

    }

    get completedClass() {

        if (

            this.progress === 100

        ) {

            return 'timeline-item active';

        }

        return 'timeline-item';

    }

    // -----------------------------
    // Close
    // -----------------------------

    handleClose() {

        this.dispatchEvent(

            new CustomEvent(

                'close'

            )

        );

    }

}