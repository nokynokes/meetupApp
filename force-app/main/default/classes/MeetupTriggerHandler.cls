public with sharing class MeetupTriggerHandler extends TriggerHandler {
    private List<Meetup__c> triggerNew;
    private List<Meetup__c> triggerOld;
    private Map<Id, Meetup__c> triggerMapNew;
    private Map<Id, Meetup__c> triggerMapOld;

    public MeetupTriggerHandler() {
        this.triggerNew = (List<Meetup__c>) Trigger.new;
        this.triggerOld = (List<Meetup__c>) Trigger.old;
        this.triggerMapNew = (Map<Id, Meetup__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Meetup__c>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        for(Meetup__c meetup : this.triggerNew) {
            meetup.RegistrationCode__c = MeetupUtils.generateRegistrationCode();
        }
    }
}