public class AgentDashboardWrapper {

    @AuraEnabled
    public Integer todaysBookings;

    @AuraEnabled
    public Decimal todaysRevenue;

    @AuraEnabled
    public Integer pendingGroupApprovals;

    @AuraEnabled
    public Integer activeCancellationCases;

    @AuraEnabled
    public List<Booking__c> recentBookings;

}