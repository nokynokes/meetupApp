trigger MeetupRegistrationTrigger on MeetupRegistration__c (before insert) {
    new MeetupRegistrationTriggerHandler().run();
}