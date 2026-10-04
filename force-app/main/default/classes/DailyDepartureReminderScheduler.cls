public with sharing class DailyDepartureReminderScheduler
implements Schedulable {

    public void execute(SchedulableContext sc){

        DepartureReminderService.sendTomorrowDepartureReminders();

    }

}