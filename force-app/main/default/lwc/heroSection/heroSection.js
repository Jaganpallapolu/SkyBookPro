import { LightningElement } from 'lwc';

export default class HeroSection extends LightningElement {

    scrollToSearch() {

        const section = document.querySelector(
            'c-flight-search-form'
        );

        if (section) {

            section.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });

        }

    }

    scrollToDashboard() {

        const section = document.querySelector(
            'c-agent-dashboard'
        );

        if (section) {

            section.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });

        }

    }

}