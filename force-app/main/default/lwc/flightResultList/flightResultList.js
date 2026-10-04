import { LightningElement, api } from 'lwc';

export default class FlightResultList extends LightningElement {

    _offers = [];

    selectedAirline = 'All';

    selectedCabin = 'All';

    selectedSort = 'priceLow';

    @api
    set offers(value) {

        this._offers = value || [];

        this.pageNumber = 1;

    }

    get offers() {

        return this._offers;

    }

    @api selectedOfferId;

    pageNumber = 1;

    pageSize = 10;

    get totalPages() {

        return Math.max(
            1,
            Math.ceil(
                this.filteredOffers.length / this.pageSize
            )
        );

    }

    get filteredOffers() {

        let offers = [...this.offers];

        if (this.selectedAirline !== 'All') {

            offers = offers.filter(o =>

                o.airline === this.selectedAirline

            );

        }

        if (this.selectedCabin !== 'All') {

            offers = offers.filter(o =>

                o.cabinClass === this.selectedCabin

            );

        }

        switch (this.selectedSort) {

            case 'priceLow':

                offers.sort((a, b) => a.price - b.price);

                break;

            case 'priceHigh':

                offers.sort((a, b) => b.price - a.price);

                break;

            case 'departure':

                offers.sort(

                    (a, b) =>

                        new Date(a.departureTime) -

                        new Date(b.departureTime)

                );

                break;

            case 'duration':

                offers.sort(

                    (a, b) =>

                        (a.durationMinutes || 0) -

                        (b.durationMinutes || 0)

                );

                break;

        }

        return offers;

    }

    get visibleOffers() {

        return this.currentPageOffers.map(offer => {

            return {

                ...offer,

                isSelected:

                    offer.offerId === this.selectedOfferId

            };

        });

    }

    get disablePrevious() {

        return this.pageNumber === 1;

    }

    get disableNext() {

        return this.pageNumber >= this.totalPages;

    }

    get showingText() {

        if (!this.filteredOffers.length) {

            return 'No Flights Found';

        }

        const start =

            (this.pageNumber - 1)

            *

            this.pageSize

            +

            1;

        const end = Math.min(

            this.pageNumber *

            this.pageSize,

            this.filteredOffers.length

        );

        return `Showing ${start}-${end} of ${this.filteredOffers.length} Flights`;

    }

    handlePrevious() {

        if (this.pageNumber > 1) {

            this.pageNumber -= 1;

        }

    }
    handleNext() {

        if (this.pageNumber < this.totalPages) {

            this.pageNumber += 1;

        }

    }

    handleFlightSelect(event) {

        this.dispatchEvent(

            new CustomEvent(

                'flightselect',

                {

                    detail: event.detail

                }

            )

        );

    }

    get airlineOptions() {

        const airlines = [...new Set(this.offers.map(o => o.airline))];

        return [

            { label: 'All Airlines', value: 'All' },

            ...airlines.map(a => ({

                label: a,

                value: a

            }))

        ];

    }

    get cabinOptions() {

        const cabins = [...new Set(this.offers.map(o => o.cabinClass))];

        return [

            { label: 'All Classes', value: 'All' },

            ...cabins.map(c => ({

                label: c,

                value: c

            }))

        ];

    }

    sortOptions = [

        {

            label: 'Lowest Price',

            value: 'priceLow'

        },

        {

            label: 'Highest Price',

            value: 'priceHigh'

        },

        {

            label: 'Departure Time',

            value: 'departure'

        },

        {

            label: 'Shortest Duration',

            value: 'duration'

        }

    ];

    handleAirlineChange(event) {

        this.selectedAirline = event.detail.value;

        this.pageNumber = 1;

    }

    handleCabinChange(event) {

        this.selectedCabin = event.detail.value;

        this.pageNumber = 1;

    }

    handleSortChange(event) {

        this.selectedSort = event.detail.value;

        this.pageNumber = 1;

    }

    get currentPageOffers() {

        const start = (this.pageNumber - 1) * this.pageSize;

        return this.filteredOffers.slice(

            start,

            start + this.pageSize

        );

    }

}