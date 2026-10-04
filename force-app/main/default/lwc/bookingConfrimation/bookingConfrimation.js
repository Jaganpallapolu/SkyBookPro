import { LightningElement, api } from 'lwc';

export default class BookingConfrimation extends LightningElement {

    @api selectedFlight;
    @api passengers;

    @api isBooking = false;

    get passengerCount() {
        return this.passengers ? this.passengers.length : 0;
    }

    get formattedTotalFare() {

        return new Intl.NumberFormat('en-IN', {
            style: 'currency',
            currency: 'INR',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(
            Number(this.selectedFlight.price || 0)
        );

    }

    handleBack() {

        this.dispatchEvent(
            new CustomEvent('back')
        );

    }

    handleConfirmBooking() {

        this.dispatchEvent(
            new CustomEvent('confirmbooking')
        );

    }

}