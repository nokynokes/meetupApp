public with sharing class MeetupTriggerHandler extends TriggerHandler {
    private List<Meetup__c> triggerNew;

    public MeetupTriggerHandler() {
        this.triggerNew = (List<Meetup__c>) Trigger.new;
    }

    public override void beforeInsert() {
        for(Meetup__c meetup : this.triggerNew) {
            meetup.RegistrationCode__c = MeetupUtils.generateRegistrationCode();
        }
    }
}