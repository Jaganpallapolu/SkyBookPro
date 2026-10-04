import LightningDatatable from 'lightning/datatable';

import bookingStatusTemplate from './bookingStatusTemplate.html';

export default class BookingDatatable extends LightningDatatable {

    static customTypes = {

        bookingStatus: {

            template: bookingStatusTemplate,

            standardCellLayout: true,

            typeAttributes: ['value']

        }

    };

}