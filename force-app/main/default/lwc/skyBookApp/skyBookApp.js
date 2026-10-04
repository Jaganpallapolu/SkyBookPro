import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createBooking from '@salesforce/apex/BookingController.createBooking';

export default class SkyBookApp extends LightningElement {

    // Flight Search
    flightOffers = [];

    // Selected Flight
    selectedOfferId;
    selectedFlight;

    // Search Information
    passengerCount = 1;
    selectedCabinClass;

    // Passenger Data
    passengers = [];

    // Screen Control
    showPassengerForm = false;
    showBookingConfrimation = false;
    showBookingSuccess = false;
    isBooking = false;

    // Booking Information
    bookingId;

    currentView = 'home';

    // -----------------------------
    // Search Success
    // -----------------------------
    handleSearchSuccess(event) {

        if (Array.isArray(event.detail)) {

            this.flightOffers = event.detail;

        } else {

            this.flightOffers = event.detail.offers;
            this.passengerCount = event.detail.passengerCount;
            this.selectedCabinClass = event.detail.cabinClass;

        }

        this.selectedFlight = null;
        this.selectedOfferId = null;
        this.passengers = [];

        this.showPassengerForm = false;
        this.showBookingConfrimation = false;
        this.showBookingSuccess = false;

        this.bookingId = null;

    }

    // -----------------------------
    // Flight Selected
    // -----------------------------
    handleFlightSelect(event) {

        this.selectedFlight = event.detail;
        this.selectedOfferId = event.detail.offerId;

        this.showPassengerForm = true;
        this.showBookingConfrimation = false;
        this.showBookingSuccess = false;

    }

    // -----------------------------
    // Review Booking
    // -----------------------------
    handleReviewBooking(event) {

        this.passengers = event.detail.passengers;

        this.showPassengerForm = false;
        this.showBookingConfrimation = true;
        this.showBookingSuccess = false;

    }

    // -----------------------------
    // Back Button
    // -----------------------------
    handleBack() {

        this.showBookingConfrimation = false;
        this.showPassengerForm = true;

    }

    // -----------------------------
    // Confirm Booking
    // -----------------------------
    async handleConfirmBooking() {

        this.isBooking = true;

        try {

            const result = await createBooking({

                selectedFlightJson: JSON.stringify(this.selectedFlight),

                passengersJson: JSON.stringify(this.passengers)

            });

            this.bookingId = result;

            this.showBookingConfrimation = false;
            this.showBookingSuccess = true;

            this.dispatchEvent(

                new ShowToastEvent({

                    title: 'Booking Successful',

                    message: 'Your booking has been confirmed.',

                    variant: 'success'

                })

            );

        }
        catch (error) {

            this.dispatchEvent(

                new ShowToastEvent({

                    title: 'Booking Failed',

                    message:
                        error?.body?.message ||
                        error?.message ||
                        'Unknown Error',

                    variant: 'error'

                })

            );

        }
        finally {

            this.isBooking = false;

        }

    }

    // -----------------------------
    // Book Another Flight
    // -----------------------------
    handleNewBooking() {

        this.flightOffers = [];
        this.selectedOfferId = null;
        this.selectedFlight = null;
        this.passengers = [];
        this.bookingId = null;
        this.passengerCount = 1;
        this.selectedCabinClass = null;

        this.showPassengerForm = false;
        this.showBookingConfrimation = false;
        this.showBookingSuccess = false;

    }

    // -----------------------------
    // Getters
    // -----------------------------
    get hasFlightOffers() {

        return this.flightOffers &&
            this.flightOffers.length > 0;

    }


    handleSearchFlight() {

        this.showBookingSuccess = false;
        this.showPassengerForm = false;
        this.showBookingConfrimation = false;

        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        })

    }

    handleNavigation(event) {

        const section = event.detail;

        switch (section) {

            case 'home':

                this.currentView = 'home';

                break;

            case 'bookings':

                this.currentView = 'bookings';

                break;

            case 'dashboard':

                this.currentView = 'dashboard';

                break;

            case 'search':

                this.currentView = 'home';

                setTimeout(() => {

                    const search = this.template.querySelector(
                        '.search-section'
                    );

                    if (search) {

                        search.scrollIntoView({

                            behavior: 'smooth'

                        });

                    }

                }, 100);

                break;

        }

    }


    get showHome() {

        return this.currentView === 'home';

    }

    get showBookings() {

        return this.currentView === 'bookings';

    }

    get showDashboard() {

        return this.currentView === 'dashboard';

    }

}