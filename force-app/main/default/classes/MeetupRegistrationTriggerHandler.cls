public with sharing class MeetupRegistrationTriggerHandler extends TriggerHandler {
    List<MeetupRegistration__c> triggerNew;
    Map<Id, MeetupRegistration__c> triggerNewMap;
    MeetupRegistrationDTO dto;
    
    public MeetupRegistrationTriggerHandler() {
        this.triggerNew = (List<MeetupRegistration__c>) Trigger.new;
        this.dto = new MeetupRegistrationDAC(this.triggerNew).getDTO();
    }

    public override void beforeInsert(){
        validateMeetupLimit();
        validateMeetupStatus();
        validateUniqueEmailPerMeetup();

        for(MeetupRegistration__c registration : this.triggerNew) {
            Meetup__c meetup = this.dto.getMeetup(registration.Meetup__c);
            registration.Name = String.valueOf(meetup.RegistrationCount__c + 1);
        }
    }

    private void validateMeetupLimit(){
        for(MeetupRegistration__c registration : this.triggerNew) {
            Meetup__c meetup = this.dto.getMeetup(registration.Meetup__c);
            Integer regsSize = this.dto.getRegistrations(meetup.Id).size();
            if(meetup.RegistrationCount__c + regsSize > meetup.RegistrationLimit__c){
                registration.addError('You cannot exceed the meetup limit!');
            }
        }
    }

    private void validateMeetupStatus(){
        for(MeetupRegistration__c registration : this.triggerNew) {
            Meetup__c meetup = this.dto.getMeetup(registration.Meetup__c);
            if(meetup.Status__c == 'Closed'){
                registration.addError('You cannot register for meetups that are closed!');
            }
        }
    }

    private void validateUniqueEmailPerMeetup() {
        Map<Id, Set<String>> registeredEmails = new Map<Id,Set<String>>();
        for(Meetup__c meetup: this.dto.getAllMeetups()){
            Set<String> emails = new Set<String>();
            for(MeetupRegistration__c reg: meetup.MeetupRegistrations__r) {
                emails.add(reg.Email__c);
            }

            registeredEmails.put(meetup.Id, emails);
        }

        for(MeetupRegistration__c registration : this.triggerNew) {
            Meetup__c meetup = this.dto.getMeetup(registration.Meetup__c);
            if(registeredEmails.get(meetup.Id).contains(registration.Email__c)) {
                registration.addError('You already registered with that email!');
            }
        }
    }
}