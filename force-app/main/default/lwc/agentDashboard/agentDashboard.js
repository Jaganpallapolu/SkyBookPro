import { LightningElement, wire } from 'lwc';

import getDashboardData from '@salesforce/apex/AgentDashboardController.getDashboardData';

import { NavigationMixin } from 'lightning/navigation';

import { refreshApex } from '@salesforce/apex';

import {
    subscribe,
    unsubscribe,
    MessageContext,
    APPLICATION_SCOPE
} from 'lightning/messageService';

import BOOKING_REFRESH_CHANNEL
    from '@salesforce/messageChannel/BookingRefresh__c';

const columns = [

    {
        label: 'Booking Ref',

        fieldName: 'bookingUrl',

        type: 'url',

        typeAttributes: {

            label: {

                fieldName: 'Name'

            },

            target: '_blank'

        }

    },

    {
        label: 'Passenger',
        fieldName: 'passengerName'
    },

    {
        label: 'Status',
        fieldName: 'Booking_Status__c'
    },

    {
        label: 'Booking Date',
        fieldName: 'Booking_Date__c',
        type: 'date'
    },

    {

        label: 'Amount',
        fieldName: 'totalAmountInr',
        type: 'currency',
        typeAttributes: {
            currencyCode: 'INR'
        }
    }

];
export default class AgentDashboard extends NavigationMixin(LightningElement) {

    dashboard = {};
    columns = columns;
    subscription = null;
    wiredDashboardResult;

    @wire(MessageContext)
    messageContext;

    @wire(getDashboardData)

    wiredDashboard(result) {

        this.wiredDashboardResult = result;

        const { data, error } = result;

        if (data) {

            this.dashboard = {

                ...data,

                recentBookings: data.recentBookings
                    .slice(0, 5)
                    .map(record => {

                        return {

                            ...record,

                            passengerName:
                                (record.Passenger__r?.FirstName || '') +
                                ' ' +
                                (record.Passenger__r?.LastName || ''),

                            totalAmountInr:
                                Number(record.Total_Amount__c || 0) * 86.50,

                            bookingUrl: '/' + record.Id

                        };

                    })

            };

        }
        else if (error) {

            console.error(error);

        }

    }

    get formattedTodaysRevenue() {

        const USD_TO_INR = 86.50;

        return new Intl.NumberFormat('en-IN', {
            style: 'currency',
            currency: 'INR',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(
            Number(this.dashboard.todaysRevenue || 0) * USD_TO_INR
        );

    }

    handleSearchFlight() {

        this.dispatchEvent(

            new CustomEvent('searchflight', {

                detail: 'search',

                bubbles: true,

                composed: true

            })

        );

    }

    handleWalkInBooking() {

        // this[NavigationMixin.Navigate]({

        //     type: 'standard__flow',

        //     attributes: {

        //         flowApiName: 'Create_Walk_In_Booking'

        //     }

        // });

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

    subscribeToMessageChannel() {

        if (this.subscription) {
            return;
        }

        this.subscription = subscribe(

            this.messageContext,

            BOOKING_REFRESH_CHANNEL,

            () => {

                refreshApex(this.wiredDashboardResult);

            },

            {
                scope: APPLICATION_SCOPE
            }

        );

    }

    handleViewAll() {

        this[NavigationMixin.Navigate]({

            type: 'standard__navItemPage',

            attributes: {

                apiName: 'Bookings'

            }

        });

    }

}