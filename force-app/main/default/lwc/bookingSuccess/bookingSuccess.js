import { LightningElement, api } from 'lwc';

export default class BookingSuccess extends LightningElement {

    @api bookingId;
    @api selectedFlight;
    @api passengers;

    handleNewBooking() {

        this.dispatchEvent(
            new CustomEvent('newbooking')
        );

    }

    get passengerName() {

        if (!this.passengers || this.passengers.length === 0) {
            return '';
        }

        const p = this.passengers[0];

        return `${p.title} ${p.firstName} ${p.lastName}`;

    }

    get totalFare() {

        return new Intl.NumberFormat('en-IN', {

            style: 'currency',

            currency: 'INR'

        }).format(this.selectedFlight.price);

    }

}