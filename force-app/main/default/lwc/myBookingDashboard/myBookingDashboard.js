import { LightningElement, wire } from 'lwc';
import getMyBookings from '@salesforce/apex/BookingController.getMyBookings';
import { NavigationMixin } from 'lightning/navigation';
import cancelBooking from '@salesforce/apex/BookingController.cancelBooking';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { publish, MessageContext } from 'lightning/messageService';
import BOOKING_REFRESH_CHANNEL from '@salesforce/messageChannel/BookingRefresh__c';
import { subscribe, unsubscribe, APPLICATION_SCOPE } from 'lightning/messageService';

const ACTIONS = [

    { label: 'View Details', name: 'view' },

    { label: 'Cancel Booking', name: 'cancel' },

    { label: 'Track Refund', name: 'refund' },

    { label: 'Download Itinerary', name: 'download' }

];
const COLUMNS = [

    {
        label: 'Booking Ref',
        fieldName: 'bookingUrl',
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'bookingRef' },
            target: '_blank'
        }
    },

    {
        label: 'Passenger',
        fieldName: 'passenger'
    },

    {
        label: 'Flight',
        fieldName: 'flight'
    },

    {
        label: 'Departure',
        fieldName: 'departure',
        type: 'date'
    },

    {
        label: 'Seat Class',
        fieldName: 'seatClass'
    },

    {
        label: 'Status',

        fieldName: 'status',

        type: 'bookingStatus',

        typeAttributes: {

            value: { fieldName: 'status' }

        }
    },

    {
        label: 'Total Amount',
        fieldName: 'totalAmountInr',
        type: 'currency',
        typeAttributes: {
            currencyCode: 'INR'
        }
    },

    {
        type: 'action',

        typeAttributes: {

            rowActions: ACTIONS

        }
    }

];

export default class MyBookingsDashboard extends NavigationMixin(LightningElement) {

    columns = COLUMNS;

    bookings = [];

    error;
    allBookings = [];

    showCancellationModal = false;

    selectedBookingId;

    wiredBookingsResult;

    subscription = null;

    showCancellationModal = false;

    showRefundTracker = false;

    selectedBookingId;

    // Pagination

    pageSize = 5;

    pageNumber = 1;

    pagedBookings = [];

    @wire(MessageContext) messageContext;

    get totalPages() {

        return Math.ceil(
            this.bookings.length / this.pageSize
        ) || 1;

    }

    get disablePrevious() {

        return this.pageNumber === 1;

    }

    get disableNext() {

        return this.pageNumber >= this.totalPages;

    }

    @wire(getMyBookings)
    wiredBookings(result) {

        this.wiredBookingsResult = result;

        const { error, data } = result;

        if (data) {

            this.allBookings = data.map(record => {

                return {

                    id: record.Id,

                    bookingRef: record.Name,

                    bookingUrl: '/' + record.Id,

                    passenger:
                        (record.Passenger__r?.FirstName || '') +
                        ' ' +
                        (record.Passenger__r?.LastName || ''),

                    flight:
                        record.Flight__r?.Flight_Number__c,

                    departure:
                        record.Flight__r?.Depature_DateTime__c,

                    seatClass:
                        record.Seat_Class__c,

                    status:
                        record.Booking_Status__c,

                    totalAmountInr:
                        Number(record.Total_Amount__c || 0) * 86.50

                };

            });

            this.bookings = [...this.allBookings];

            this.pageNumber = 1;

            this.updatePagedBookings();

            this.error = undefined;

        }

        else if (error) {

            this.error = error;

            this.bookings = [];

        }

    }

    handleRowAction(event) {

        const action = event.detail.action.name;

        const row = event.detail.row;

        switch (action) {

            case 'view':

                this[NavigationMixin.Navigate]({

                    type: 'standard__recordPage',

                    attributes: {

                        recordId: row.id,

                        objectApiName: 'Booking__c',

                        actionName: 'view'

                    }

                });

                break;

            case 'cancel':

                this.selectedBookingId = row.id;

                this.showCancellationModal = true;

                break;


            case 'refund':

    if (row.status !== 'Cancelled') {

        this.dispatchEvent(

            new ShowToastEvent({

                title: 'Refund Not Available',

                message:
                    'Refund tracking is available only for cancelled bookings.',

                variant: 'warning'

            })

        );

        return;

    }

    this.selectedBookingId = row.id;

    this.showRefundTracker = true;

    break;

            case 'download':

                this[NavigationMixin.Navigate]({

                    type: 'standard__webPage',

                    attributes: {

                        url: '/apex/ItineraryPDF?id=' + row.id

                    }

                });

                break;


        }



    }

    showAll() {

        this.bookings = [...this.allBookings];

        this.pageNumber = 1;

        this.updatePagedBookings();

    }

    showUpcoming() {

        const today = new Date();

        this.bookings =
            this.allBookings.filter(record => {

                return new Date(record.departure) >= today &&
                    record.status !== 'Cancelled';

            });

        this.pageNumber = 1;

        this.updatePagedBookings();

    }

    showPast() {

        const today = new Date();

        this.bookings =
            this.allBookings.filter(record => {

                return new Date(record.departure) < today;

            });

        this.pageNumber = 1;

        this.updatePagedBookings();

    }

    showCancelled() {

        this.bookings =
            this.allBookings.filter(record => {

                return record.status === 'Cancelled';

            });

        this.pageNumber = 1;

        this.updatePagedBookings();

    }

    handleCloseModal() {

        this.showCancellationModal = false;

    }

    async handleConfirmCancellation(event) {

        try {

            await cancelBooking({

                bookingId: event.detail.bookingId,

                cancellationReason: event.detail.reason

            });

            this.dispatchEvent(

                new ShowToastEvent({

                    title: 'Success',

                    message: 'Booking cancelled successfully.',

                    variant: 'success'

                })

            );

            this.showCancellationModal = false;

            await refreshApex(this.wiredBookingsResult);
            this.pageNumber = 1;

            publish(
                this.messageContext,
                BOOKING_REFRESH_CHANNEL,
                {
                    action: 'cancelled'
                }
            );

        }

        catch (error) {

            console.error('FULL ERROR', JSON.stringify(error));
            console.error(error);

            this.dispatchEvent(

                new ShowToastEvent({

                    title: 'Error',

                    message:
                        error?.body?.message ||
                        error?.message ||
                        JSON.stringify(error),

                    variant: 'error'

                })

            );

        }

    }


    subscribeToMessageChannel() {

        if (this.subscription) {
            return;
        }

        this.subscription = subscribe(
            this.messageContext,
            BOOKING_REFRESH_CHANNEL,
            () => {

                refreshApex(this.wiredBookingsResult);

            },
            {
                scope: APPLICATION_SCOPE
            }
        );

    }

    connectedCallback() {

        this.subscribeToMessageChannel();

    }

    disconnectedCallback() {

        if (this.subscription) {

            unsubscribe(this.subscription);

            this.subscription = null;

        }

    }

    updatePagedBookings() {

        const start =
            (this.pageNumber - 1) * this.pageSize;

        const end =
            start + this.pageSize;

        this.pagedBookings =
            this.bookings.slice(start, end);

    }
    handlePrevious() {

        if (this.pageNumber > 1) {

            this.pageNumber--;

            this.updatePagedBookings();

        }

    }

    handleNext() {

        if (this.pageNumber < this.totalPages) {

            this.pageNumber++;

            this.updatePagedBookings();

        }

    }

    handleCloseRefundTracker() {

        this.showRefundTracker = false;

    }

}