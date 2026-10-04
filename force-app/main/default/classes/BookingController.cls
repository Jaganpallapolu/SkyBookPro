public with sharing class BookingController {

    @AuraEnabled
    public static String createBooking(
        String selectedFlightJson,
        String passengersJson
    ) {

        // -----------------------------
        // Convert Flight JSON
        // -----------------------------

        FlightOfferWrapper selectedFlight =
            (FlightOfferWrapper)JSON.deserialize(
                selectedFlightJson,
                FlightOfferWrapper.class
            );

        System.debug('Selected Flight');
        System.debug(JSON.serializePretty(selectedFlight));

        if (selectedFlight == null) {
            throw new AuraHandledException('Selected Flight is required.');
        }

        // -----------------------------
        // Convert Passenger JSON
        // -----------------------------

        List<PassengerWrapper> passengers =
            (List<PassengerWrapper>)JSON.deserialize(
                passengersJson,
                List<PassengerWrapper>.class
            );

        System.debug('Passengers Received:');
        System.debug(JSON.serializePretty(passengers));

        if (passengers == null || passengers.isEmpty()) {
            throw new AuraHandledException('Passenger list is empty.');
        }

        PassengerWrapper p = passengers[0];

        System.debug('First Name = ' + p.firstName);
        System.debug('Last Name = ' + p.lastName);

        // -----------------------------
        // Create Contact
        // -----------------------------

        Contact contact = new Contact();

        contact.FirstName = p.firstName;
        contact.LastName = p.lastName;
        contact.Email = p.email;
        contact.Phone = p.phone;

        insert contact;

        System.debug('Contact Created : ' + contact.Id);

        // -----------------------------
        // Debug Flight Values
        // -----------------------------

        System.debug('Flight Number: ' + selectedFlight.flightNumber);
        System.debug('Airline: ' + selectedFlight.airline);
        System.debug('Origin: ' + selectedFlight.origin);
        System.debug('Destination: ' + selectedFlight.destination);
        System.debug('Departure: ' + selectedFlight.departureTime);
        System.debug('Arrival: ' + selectedFlight.arrivalTime);

        // -----------------------------
        // Create Flight
        // -----------------------------

        Flight__c flight = new Flight__c();

        flight.Name =
            selectedFlight.airline + ' ' + selectedFlight.flightNumber;

        flight.Flight_Number__c =
            selectedFlight.flightNumber;

        flight.Airline_Name__c =
            selectedFlight.airline;

        flight.Origin_Airport__c =
            selectedFlight.origin;

        flight.Destination_Airport__c =
            selectedFlight.destination;

        flight.Amadeus_Offer_ID__c =
            selectedFlight.offerId;

        flight.Status__c = 'Active';

        if (!String.isBlank(selectedFlight.departureTime)) {

            flight.Depature_DateTime__c =
                Datetime.valueOfGmt(
                    selectedFlight.departureTime
                        .replace('T', ' ')
                        .replace('Z', '')
                );

        }

        if (!String.isBlank(selectedFlight.arrivalTime)) {

            flight.Arrival_DateTime__c =
                Datetime.valueOfGmt(
                    selectedFlight.arrivalTime
                        .replace('T', ' ')
                        .replace('Z', '')
                );

        }

        insert flight;

        System.debug('Flight Created : ' + flight.Id);

// ----------------------------------
// Create Booking
// ----------------------------------

        Booking__c booking =
            BookingService.createBooking(

                contact.Id,

                flight.Id,

                selectedFlight.offerId,

                selectedFlight.offerJson,

                passengers.size(),

                selectedFlight.cabinClass,

                p

            );

        System.debug('Booking Created : ' + booking.Id);

        return booking.Id;

    }

    @AuraEnabled(cacheable=true)
    public static List<Booking__c> getMyBookings() {

        return [

            SELECT
                Id,
                Name,
                Booking_Status__c,
                Seat_Class__c,
                Total_Amount__c,
                Booking_Date__c,

                Flight__r.Name,
                Flight__r.Flight_Number__c,
                Flight__r.Depature_DateTime__c,

                Passenger__r.FirstName,
                Passenger__r.LastName

            FROM Booking__c

            WHERE Agent__c = :UserInfo.getUserId()

            ORDER BY CreatedDate DESC

        ];

    }

    @AuraEnabled
    public static void cancelBooking(
        Id bookingId,
        String cancellationReason
    ) {

        if (bookingId == null) {
            throw new AuraHandledException('Booking Id is required.');
        }

        if (String.isBlank(cancellationReason)) {
            throw new AuraHandledException('Cancellation reason is required.');
        }

        List<Booking__c> bookings = [

            SELECT
                Id,
                Booking_Status__c,
                Cancellation_Reason__c

            FROM Booking__c

            WHERE Id = :bookingId

            LIMIT 1

        ];

        if (bookings.isEmpty()) {
            throw new AuraHandledException('Booking not found.');
        }

        Booking__c booking = bookings[0];

        if (booking.Booking_Status__c == 'Cancelled') {
            throw new AuraHandledException(
                'This booking is already cancelled.'
            );
        }

        booking.Booking_Status__c = 'Cancelled';

        booking.Cancellation_Reason__c = cancellationReason;

        update booking;

    }

}