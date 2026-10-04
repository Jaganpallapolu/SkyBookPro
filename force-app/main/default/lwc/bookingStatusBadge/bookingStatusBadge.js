import { LightningElement, api } from 'lwc';

export default class BookingStatusBadge extends LightningElement {

    @api value;

    get status() {
        return this.value;
    }

    get badgeClass() {

        switch (this.value) {

            case 'Confirmed':
                return 'confirmed';

            case 'Cancelled':
                return 'cancelled';

            default:
                return 'draft';

        }

    }

}