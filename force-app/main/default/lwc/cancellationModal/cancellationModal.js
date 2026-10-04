import { LightningElement, api } from 'lwc';

export default class CancellationModal extends LightningElement {

    @api isOpen = false;

    @api bookingId;

    reason = '';

    handleReason(event) {

        this.reason = event.target.value;

        const textarea = this.template.querySelector('lightning-textarea');

        textarea.setCustomValidity('');

        textarea.reportValidity();

    }

    handleClose() {

        this.dispatchEvent(
            new CustomEvent('close')
        );

    }

    handleCancel() {

        if (!this.reason.trim()) {

            const textarea =
                this.template.querySelector('lightning-textarea');

            textarea.setCustomValidity(
                'Cancellation Reason is required.'
            );

            textarea.reportValidity();

            return;

        }

        this.dispatchEvent(

            new CustomEvent('confirm', {

                detail: {

                    bookingId: this.bookingId,

                    reason: this.reason

                }

            })

        );

    }

}