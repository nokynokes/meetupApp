public with sharing class MeetupRegistrationDAC {
    private List<MeetupRegistration__c> meetupRegs;

    public MeetupRegistrationDAC(List<MeetupRegistration__c> meetupRegs) {
        this.meetupRegs = meetupRegs;
    }

    public MeetupRegistrationDTO getDTO() {
        Set<Id> meetupIds = new Set<Id>();
       
        for(MeetupRegistration__c registration : this.meetupRegs) {
            meetupIds.add(registration.Meetup__c);
        }

        Map<Id, Meetup__c> meetups = new Map<Id, Meetup__c>([SELECT Id, Name, Status__c, RegistrationCode__c, RegistrationLimit__c, RegistrationCount__c, (SELECT Id, FirstName__c, LastName__c, Email__c, Name FROM MeetupRegistrations__r) FROM Meetup__c WHERE Id in :meetupIds]);
        Map<Id, List<MeetupRegistration__c>> meetupsToRegistrations = new Map<Id, List<MeetupRegistration__c>>();
        Map<Id, Meetup__c> registrationToMeetup = new Map<Id, Meetup__c>();

        for(MeetupRegistration__c registration : this.meetupRegs) {
            Meetup__c meetup = meetups.get(registration.Meetup__c);
            if(meetupsToRegistrations.keySet().contains(meetup.Id)){
                meetupsToRegistrations.get(meetup.Id).add(registration);
            } else {
                List<MeetupRegistration__c> regs = new List<MeetupRegistration__c>();
                regs.add(registration);
                meetupsToRegistrations.put(meetup.Id, regs);
            }

            registrationToMeetup.put(registration.Id, meetup);
        }

        return new MeetupRegistrationDTO(meetupsToRegistrations, registrationToMeetup);
    }
}