import { LightningElement, api } from 'lwc';

export default class PassengerCard extends LightningElement {

    @api passenger;

    get cardTitle() {
        return `Passenger ${this.passenger.passengerNumber}`;
    }

    titleOptions = [
        { label: 'Mr', value: 'Mr' },
        { label: 'Mrs', value: 'Mrs' },
        { label: 'Miss', value: 'Miss' },
        { label: 'Ms', value: 'Ms' }
    ];

    genderOptions = [
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' }
    ];

    passengerTypeOptions = [
        { label: 'Adult', value: 'Adult' },
        { label: 'Child', value: 'Child' },
        { label: 'Infant', value: 'Infant' }
    ];

    mealOptions = [
        { label: 'Vegetarian', value: 'Vegetarian' },
        { label: 'Non-Vegetarian', value: 'Non-Vegetarian' },
        { label: 'Vegan', value: 'Vegan' },
        { label: 'Jain Meal', value: 'Jain Meal' },
        { label: 'Kosher', value: 'Kosher' },
        { label: 'Halal', value: 'Halal' }
    ];


    handleChange(event) {

        const field = event.target.dataset.field;

        const updatedPassenger = {

            ...this.passenger,

            [field]: event.detail.value

        };

        this.dispatchEvent(

            new CustomEvent('passengerchange', {

                detail: updatedPassenger,

                bubbles: true,

                composed: true

            })

        );

    }
    @api validate(){

        let isValid = true;

        const fields = this.template.querySelectorAll(
            'lightning-input, lightning-combobox'
        );

        fields.forEach(field => {

            if (!field.checkValidity()) {

                field.reportValidity();

                isValid = false;

            }

        });

        return isValid;

    }
}