public with sharing class AgentDashboardController {

   @AuraEnabled(cacheable=true)
    public static AgentDashboardWrapper getDashboardData() {

        AgentDashboardWrapper dashboard =
            new AgentDashboardWrapper();

        dashboard.todaysBookings = [

            SELECT COUNT()

            FROM Booking__c

            WHERE Booking_Date__c = :Date.today()

        ];

        AggregateResult revenue = [

            SELECT SUM(Total_Amount__c) total

            FROM Booking__c

            WHERE Booking_Date__c = :Date.today()

        ];

        dashboard.todaysRevenue =
            revenue.get('total') == null
            ? 0
            : (Decimal) revenue.get('total');

        dashboard.pendingGroupApprovals = [

            SELECT COUNT()

            FROM Booking__c

            WHERE Is_Group_Booking__c = true
            AND Booking_Status__c = 'Pending'

        ];

        dashboard.activeCancellationCases = [

            SELECT COUNT()

            FROM Case

            WHERE Status != 'Closed'

        ];

        dashboard.recentBookings = [

            SELECT

                Id,
                Name,
                Booking_Status__c,
                Booking_Date__c,
                Total_Amount__c,
                Passenger__r.FirstName,
                Passenger__r.LastName

            FROM Booking__c

            ORDER BY CreatedDate DESC

            LIMIT 10

        ];

        return dashboard;

    } 

}