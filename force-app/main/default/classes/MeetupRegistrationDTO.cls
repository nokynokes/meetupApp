public with sharing class MeetupRegistrationDTO {
    private Map<Id, Meetup__c> meetups;

    public MeetupRegistrationDTO(Map<Id, Meetup__c> meetups) {
        this.meetups = meetups;
    }

    public Meetup__c getMeetup(Id registrationId){
        return this.meetups.get(registrationId);
    }
}