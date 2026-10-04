public class DuffelSearchRequest {

    public Data data;

    public DuffelSearchRequest() {
        data = new Data();
    }

    public class Data {

        public List<Slice> slices;
        public List<Passenger> passengers;
        public String cabin_class;

        public Boolean return_offers;

        public Data() {

            slices = new List<Slice>();

            passengers = new List<Passenger>();

            return_offers = true;

        }

    }

    public class Slice {

        public String origin;

        public String destination;

        public Date departure_date;

    }

    public class Passenger {

        public String type;

    }

}