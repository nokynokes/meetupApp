@isTest
private class TestMeetupRegistrationTriggerHandler {
    
    @isTest
    private static void testValidateRegisteringWhenExceedingMeetupLimit(){
        Meetup__c meetup = new Meetup__c(
            Name = 'Cool kids only',
            RegistrationLimit__c = 2,
            Status__c = 'Open'
        );

        insert meetup;
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
            List<MeetupRegistration__c> regs = new List<MeetupRegistration__c>();
            MeetupRegistration__c reg2 = new MeetupRegistration__c(
                Meetup__c = meetup.Id,
                FirstName__c = 'Nolan but not as cool',
                LastName__c = 'Cretney',
                Email__c = 'nolan.cretney@lesscoolsville.com'
            );
            regs.add(reg2);
            MeetupRegistration__c reg3 = new MeetupRegistration__c(
                Meetup__c = meetup.Id,
                FirstName__c = 'Nolan',
                LastName__c = 'Cretney',
                Email__c = 'nolan.cretney@gmail.com'
            );
            regs.add(reg3);
            insert regs;
        } catch(DmlException e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException, 'You should not be able to add mroe registrations for the meetup');
        System.assertEquals(1, [SELECT COUNT() FROM MeetupRegistration__c], 'Database should be unchanged');
    }

    @isTest
    private static void testValidateUniqueEmailPerMeetup(){
        Meetup__c meetup = new Meetup__c(
            Name = 'Cool kids only',
            RegistrationLimit__c = 2,
            Status__c = 'Open'
        );

        insert meetup;
        MeetupRegistration__c reg1 = new MeetupRegistration__c(
            Meetup__c = meetup.Id,
            FirstName__c = 'Nolan but cooler',
            LastName__c = 'Cretney',
            Email__c = 'nolan.cretney@coolsville.com'
        );

        insert reg1;

        Test.startTest();

        MeetupRegistration__c reg2 = new MeetupRegistration__c(
            Meetup__c = meetup.Id,
            FirstName__c = 'Nolan but not as cool',
            LastName__c = 'Cretney',
            Email__c = 'nolan.cretney@coolsville.com'
        );
        
        DmlException expectedException;
        try {
            insert reg2;
        } catch(DmlException e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException, 'You should not be able register for a meetup with the same email twice');
        System.assertEquals(1, [SELECT COUNT() FROM MeetupRegistration__c], 'Database should be unchanged');
    }

    @isTest
    private static void testValidateRegisteringWhenMeetupisClosed() {
        Meetup__c meetup = new Meetup__c(
            Name = 'Cool kids only',
            RegistrationLimit__c = 2,
            Status__c = 'Closed'
        );

        insert meetup;

        Test.startTest();

        MeetupRegistration__c reg1 = new MeetupRegistration__c(
            Meetup__c = meetup.Id,
            FirstName__c = 'Nolan but cooler',
            LastName__c = 'Cretney',
            Email__c = 'nolan.cretney@coolsville.com'
        );

        DmlException expectedException;
        try {
            insert reg1;
        } catch (DmlException e) {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException, 'You should not be able to register for a closed meetup');
        System.assertEquals(0, [SELECT COUNT() FROM MeetupRegistration__c], 'Database should be unchanged');
    }

    @isTest
    private static void testAutoGenerateName() {
        Meetup__c meetup = new Meetup__c(
            Name = 'Cool kids only',
            RegistrationLimit__c = 2,
            Status__c = 'Open'
        );

        insert meetup;
        MeetupRegistration__c reg1 = new MeetupRegistration__c(
            Meetup__c = meetup.Id,
            FirstName__c = 'Nolan but cooler',
            LastName__c = 'Cretney',
            Email__c = 'nolan.cretney@coolsville.com'
        );

        insert reg1;

        reg1 = [SELECT Id, Name FROM MeetupRegistration__c WHERE Id = :reg1.Id];
        System.assertEquals('1', reg1.Name, 'Name field should have been auto generated');
    }
}