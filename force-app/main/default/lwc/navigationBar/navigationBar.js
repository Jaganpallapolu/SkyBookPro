import { LightningElement, api } from 'lwc';

export default class NavigationBar extends LightningElement {

    @api currentView = 'home';

    navigate(event) {

        const section = event.target.dataset.section;

        this.dispatchEvent(
            new CustomEvent('navigate', {
                detail: section,
                bubbles: true,
                composed: true
            })
        );

    }

    get homeClass() {
        return this.currentView === 'home'
            ? 'nav-link active'
            : 'nav-link';
    }

    get searchClass() {
        return this.currentView === 'home'
            ? 'nav-link active'
            : 'nav-link';
    }

    get bookingClass() {
        return this.currentView === 'bookings'
            ? 'nav-link active'
            : 'nav-link';
    }

    get dashboardClass() {
        return this.currentView === 'dashboard'
            ? 'nav-link active'
            : 'nav-link';
    }

}