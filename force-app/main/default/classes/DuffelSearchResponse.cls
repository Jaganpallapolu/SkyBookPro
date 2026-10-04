public class DuffelSearchResponse {

    public ResponseData data;

    public class ResponseData {

        public List<Offer> offers;

    }

    public class Offer {

        public String id;
        public String total_amount;
        public String total_currency;

        public Owner owner;

        public List<Slice> slices;

    }

    public class Owner {

        public String name;
        public String iata_code;

    }

    public class Slice {

        public String duration;

        public Airport origin;

        public Airport destination;

        public List<Segment> segments;

    }

    public class Segment {

        public String departing_at;
        public String arriving_at;

        public Carrier operating_carrier;

        public String operating_carrier_flight_number;

        public Airport origin;

        public Airport destination;

    }

    public class Carrier {

        public String name;

        public String iata_code;

    }

    public class Airport {

        public String name;

        public String iata_code;

        public String city_name;

    }

}