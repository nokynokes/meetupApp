public with sharing class MeetupRegistrationDTO {
    private Map<Id, List<MeetupRegistration__c>> meetupsToRegistrations;
    private Map<Id, Meetup__c> meetups;

    public MeetupRegistrationDTO(Map<Id, List<MeetupRegistration__c>> meetupsToRegistrations, Map<Id, Meetup__c> meetups) {
        this.meetupsToRegistrations = meetupsToRegistrations;
        this.meetups = meetups;
    }

    public Meetup__c getMeetup(Id meetupId){
        return this.meetups.get(meetupId);
    }

    public List<MeetupRegistration__c> getRegistrations(Id meetupId){
        return this.meetupsToRegistrations.get(meetupId);
    }

    public List<Meetup__c> getAllMeetups() {
        return this.meetups.values();
    }
}