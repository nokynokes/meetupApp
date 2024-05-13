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

        Map<Id, Meetup__c> meetups = new Map<Id, Meetup__c>([SELECT Id, Name, Status__c, RegistrationCode__c, RegistrationLimit__c, RegistrationCount__c, OwnerId FROM Meetup__c WHERE Id in :meetupIds]);
        Map<Id, Meetup__c> dtoMap = new Map<Id, Meetup__c>();

        for(MeetupRegistration__c registration : this.meetupRegs) {
            dtoMap.put(registration.Id, meetups.get(registration.Meetup__c));
        }

        return new MeetupRegistrationDTO(dtoMap);
    }
}