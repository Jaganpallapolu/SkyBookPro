import { LightningElement, api } from 'lwc';

export default class PassengerDetailsForm extends LightningElement {

    @api selectedFlight;
    @api passengerCount;

    passengers = [];

    connectedCallback() {

        this.initializePassengers();

    }

    initializePassengers() {

        this.passengers = [];

        for (let i = 1; i <= this.passengerCount; i++) {

            this.passengers.push({

                id: i,

                passengerNumber: i,

                title: 'Mr',

                firstName: '',

                lastName: '',

                email: '',

                phone: '',

                dateOfBirth: '',

                gender: '',

                passengerType: 'Adult',

                passportNumber: '',

                mealPreference: ''

            });

        }

    }

    handlePassengerChange(event) {

        const updatedPassenger = event.detail;

        this.passengers = this.passengers.map(passenger => {

            if (passenger.id === updatedPassenger.id) {

                return updatedPassenger;

            }

            return passenger;

        });

       // console.log(
        //    'Updated Passenger List:',
        //    JSON.stringify(this.passengers,null,2)
       // );

    }

    @api
    validateAllPassengers() {

        let isValid = true;

        const passengerCards =
            this.template.querySelectorAll(
                'c-passenger-card'
            );

        passengerCards.forEach(card => {

            if (!card.validate()) {

                isValid = false;

            }

        });

        return isValid;

    }

    handleReviewBooking() {

        if (!this.validateAllPassengers()) {
            return;
        }

        this.dispatchEvent(

            new CustomEvent('reviewbooking', {

                detail: {

                    passengers: this.passengers

                }

            })

        );

    }

}