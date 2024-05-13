public with sharing class MeetupRegistrationController {
    
    @AuraEnabled(cacheable=true)
    public static String getCode(Id search){
        try {
            Meetup__c meetup =  [SELECT  Id, RegistrationCode__c FROM Meetup__c WHERE Id = :search];
            return meetup.RegistrationCode__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Meetup__c getMeetupByRegistrationCode(String registrationCode) {
        try {
            return [SELECT Id, Name, RegistrationLimit__c, RegistrationCode__c, RegistrationCount__c, Status__c FROM Meetup__c WHERE RegistrationCode__c = :registrationCode];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}