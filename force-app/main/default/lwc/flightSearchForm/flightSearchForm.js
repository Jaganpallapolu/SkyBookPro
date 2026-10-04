import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchFlights from '@salesforce/apex/DuffelFlightSearchService.searchFlights';

export default class FlightSearchForm extends LightningElement {

    isLoading = false;
    origin = 'HYD';
    destination = 'DEL';
    departureDate = '';
    adults = 1;
    cabinClass = 'Economy';

    airportOptions = [
        { label: 'Hyderabad (HYD)', value: 'HYD' },
        { label: 'Delhi (DEL)', value: 'DEL' },
        { label: 'Mumbai (BOM)', value: 'BOM' },
        { label: 'Bengaluru (BLR)', value: 'BLR' },
        { label: 'Chennai (MAA)', value: 'MAA' },
        { label: 'Kolkata (CCU)', value: 'CCU' },
        { label: 'Goa (GOI)', value: 'GOI' },
        { label: 'Pune (PNQ)', value: 'PNQ' },
        { label: 'Ahmedabad (AMD)', value: 'AMD' },
        { label: 'Kochi (COK)', value: 'COK' }
    ];
    departureDate = '';
    adults = 1;
    cabinClass = 'Economy';

    cabinOptions = [
        { label: 'Economy', value: 'Economy' },
        { label: 'Premium Economy', value: 'Premium Economy' },
        { label: 'Business', value: 'Business' },
        { label: 'First', value: 'First' }
    ];

    connectedCallback() {

        const tomorrow = new Date();

        tomorrow.setDate(tomorrow.getDate() + 1);

        this.departureDate =
            tomorrow.toISOString().split('T')[0];

    }

    validateFields() {

        const inputFields = this.template.querySelectorAll(
            'lightning-input, lightning-combobox'
        );

        let isValid = true;

        inputFields.forEach(field => {
            if (!field.checkValidity()) {
                field.reportValidity();
                isValid = false;
            }
        });

        if (this.origin === this.destination) {
            isValid = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Validation Error',
                    message: 'Origin and Destination cannot be the same.',
                    variant: 'error'
                })
            );
        }

        return isValid;
    }

    handleOrigin(event) {
        this.origin = event.detail.value;
    }

    handleDestination(event) {
        this.destination = event.detail.value;
    }

    handleDepartureDate(event) {
        this.departureDate = event.target.value;
    }

    handleAdults(event) {
        this.adults = event.target.value;
    }

    handleCabinClass(event) {
        this.cabinClass = event.detail.value;
    }

    async handleSearch() {

        if (!this.validateFields()) {
            return;
        }

        this.isLoading = true;

        try {

            const offers = await searchFlights({

                origin: this.origin,
                destination: this.destination,
                departureDate: this.departureDate,
                adults: Number(this.adults),
                cabinClass: this.cabinClass

            });

            this.dispatchEvent(
                new CustomEvent('searchsuccess', {
                    detail: {
                        offers: offers,
                        passengerCount: Number(this.adults),
                        cabinClass: this.cabinClass
                    }
                })
            );

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: offers.length + ' flights found.',
                    variant: 'success'
                })
            );

        }
        catch(error){

            console.error(error);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Search Failed',
                    message:
                        error?.body?.message ||
                        'Unable to search flights.',
                    variant: 'error'
                })
            );

        }
        finally{
            this.isLoading = false;
        }
    }

}