public with sharing class MeetupRegistrationTriggerHandler extends TriggerHandler {
    List<MeetupRegistration__c> triggerNew;
    MeetupRegistrationDTO dto;
    
    public MeetupRegistrationTriggerHandler() {
        this.triggerNew = (List<MeetupRegistration__c>) Trigger.new;
        this.dto = new MeetupRegistrationDAC(this.triggerNew).getDTO();

    }

    public override void beforeInsert(){
        for(MeetupRegistration__c registration : this.triggerNew) {
            Meetup__c meetup = this.dto.getMeetup(registration.Id);
            if(meetup.RegistrationCount__c + 1 > meetup.RegistrationLimit__c){
                registration.addError('You cannot exceed the meetup limit!');
            }
        }
    }

    public class MeetupLimitExceededException extends Exception {}
}