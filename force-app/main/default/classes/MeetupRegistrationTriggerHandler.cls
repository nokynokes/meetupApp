public with sharing class MeetupRegistrationTriggerHandler extends TriggerHandler {
    List<MeetupRegistration__c> triggerNew;
    Map<Id, MeetupRegistration__c> triggerNewMap;
    MeetupRegistrationDTO dto;
    
    public MeetupRegistrationTriggerHandler() {
        this.triggerNew = (List<MeetupRegistration__c>) Trigger.new;
        this.dto = new MeetupRegistrationDAC(this.triggerNew).getDTO();
    }

    public override void beforeInsert(){
        for(MeetupRegistration__c registration : this.triggerNew) {
            Meetup__c meetup = this.dto.getMeetup(registration.Meetup__c);
            Integer regsSize = this.dto.getRegistrations(meetup.Id).size();
            if(meetup.RegistrationCount__c + regsSize > meetup.RegistrationLimit__c){
                registration.addError('You cannot exceed the meetup limit!');
            }
            
            registration.Name = String.valueOf(meetup.RegistrationCount__c + 1);
        }
    }
}