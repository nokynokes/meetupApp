@isTest
private class TestMeetupRegistrationTriggerHandler {
    
    @isTest
    private static void testPreventRegisteringWhenExceedingMeetupLimit(){
        Meetup__c meetup = new Meetup__c(
            Name = 'Cool kids only',
            RegistrationLimit__c = 1,
            Status__c = 'Open'
        );

        insert meetup;
        System.debug('hi');
        MeetupRegistration__c reg1 = new MeetupRegistration__c(
            Meetup__c = meetup.Id,
            FirstName__c = 'Nolan but cooler',
            LastName__c = 'Cretney',
            Email__c = 'nolan.cretney@coolsville.com'
        );

        insert reg1;

        Test.startTest();

        DmlException expectedException;
        try {
            MeetupRegistration__c reg2 = new MeetupRegistration__c(
                Meetup__c = meetup.Id,
                FirstName__c = 'Nolan but not as cool',
                LastName__c = 'Cretney',
                Email__c = 'nolan.cretney@lesscoolsville.com'
            );

            insert reg2;
        } catch(DmlException e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException, 'You should not be able to add mroe registrations for the meetup');
        System.assertEquals(1, [SELECT COUNT() FROM MeetupRegistration__c], 'Database should be unchanged');
    }
}