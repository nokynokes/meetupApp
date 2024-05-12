@isTest(SeeAllData=false)
private class TestMeetupTriggerHandler {

    @isTest
    private static void testAutogenerateRegistrationCode() {
        List<Meetup__c> meetups = new List<Meetup__c>();
        
        for(Integer i = 0; i < 10; i++){
            meetups.add(new Meetup__c(
                Name = 'Meetup #' + i,
                RegistrationLimit__c = i,
                Status__c = 'Open'
            ));
        }

        insert meetups;


        for(Meetup__c meetup : [SELECT Id, RegistrationCode__c FROM Meetup__c]){
            System.assert(!String.isBlank(meetup.RegistrationCode__c), 'Registration Code should be auto generated for new records');
        }
    }
}