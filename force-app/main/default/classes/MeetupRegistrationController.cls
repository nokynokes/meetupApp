public with sharing class MeetupRegistrationController {
    
    @AuraEnabled(cacheable=true)
    public static List<Meetup__c> getMeetupsByName(String searchName){
        try {
            return [SELECT Id, Name, RegistrationCode__c FROM Meetup__c WHERE Name LIKE :searchName];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Meetup__c getMeetupByRegistrationCode(String registrationCode) {
        try {
            return [SELECT Id, Name, RegistrationLimit__c, RegistrationCode__c, Status__c FROM Meetup__c WHERE RegistrationCode__c = :registrationCode AND Status__c = 'Open'];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}