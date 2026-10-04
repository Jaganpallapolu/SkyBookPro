import { LightningElement, api } from 'lwc';

const USD_TO_INR = 87;

export default class FlightResultCard extends LightningElement {

    @api offer;

    @api isSelected;

    get formattedDepartureDate() {

        if (!this.offer.departureTime) return '';

        return new Intl.DateTimeFormat('en-IN', {

            day: '2-digit',
            month: 'short',
            year: 'numeric'

        }).format(new Date(this.offer.departureTime));

    }

    get formattedDepartureTime() {

        if (!this.offer.departureTime) return '';

        return new Intl.DateTimeFormat('en-IN', {

            hour: '2-digit',
            minute: '2-digit',
            hour12: true

        }).format(new Date(this.offer.departureTime));

    }

    get formattedArrivalDate() {

        if (!this.offer.arrivalTime) return '';

        return new Intl.DateTimeFormat('en-IN', {

            day: '2-digit',
            month: 'short',
            year: 'numeric'

        }).format(new Date(this.offer.arrivalTime));

    }

    get formattedArrivalTime() {

        if (!this.offer.arrivalTime) return '';

        return new Intl.DateTimeFormat('en-IN', {

            hour: '2-digit',
            minute: '2-digit',
            hour12: true

        }).format(new Date(this.offer.arrivalTime));

    }

    get formattedDuration() {

        if (!this.offer.duration) return '';

        return this.offer.duration
            .replace('PT', '')
            .replace('H', 'h ')
            .replace('M', 'm');

    }

    get formattedPrice() {

        if (!this.offer || this.offer.price == null) {

            return '';

        }

        let price = this.offer.price;

        if (this.offer.currencyCode === 'USD') {

            price = price * USD_TO_INR;

        }

        return new Intl.NumberFormat('en-IN', {

            style: 'currency',
            currency: 'INR'

        }).format(price);

    }

    get cardClass() {

        return this.isSelected
            ? 'flight-card selected'
            : 'flight-card';

    }

    get buttonLabel() {

        return this.isSelected
            ? 'Selected'
            : 'Select Flight';

    }

    get buttonVariant() {

        return this.isSelected
            ? 'success'
            : 'brand';

    }

    selectFlight() {

        let selectedOffer = {

            ...this.offer

        };

        if (selectedOffer.currencyCode === 'USD') {

            selectedOffer.price =
                selectedOffer.price * USD_TO_INR;

            selectedOffer.currencyCode = 'INR';

        }

        this.dispatchEvent(

            new CustomEvent('select', {

                detail: selectedOffer

            })

        );

    }

}