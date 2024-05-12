trigger MeetupTrigger on Meetup__c (before insert) {
    new MeetupTriggerHandler().run();
}