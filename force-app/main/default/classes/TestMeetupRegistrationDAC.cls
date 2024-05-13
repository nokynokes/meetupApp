@isTest
private class TestMeetupRegistrationDAC {
    
    @isTest
    private static void testDataAccessController() {
        Meetup__c meetup1 = new Meetup__c(
            Name = 'Introvert Meetup',
            RegistrationLimit__c = 10,
            Status__c = 'Open'
        );
        Meetup__c meetup2 = new Meetup__c(
            Name = 'Extrovert Meetup',
            RegistrationLimit__c = 10,
            Status__c = 'Open'
        );
        List<Meetup__c> meetups = new List<Meetup__c>();
        meetups.add(meetup1);
        meetups.add(meetup2);
        insert meetups;

        String fakeId1 = TestUtils.getFakeMeetupRegistrationId();
        MeetupRegistration__c registration1 = new MeetupRegistration__c(
            Id = fakeId1,
            Email__c = 'nolan@introvert.com',
            FirstName__c = 'Introverted Nolan',
            LastName__c = 'Cretney',
            Meetup__c = meetup1.Id
        );
        String fakeId2 = TestUtils.getFakeMeetupRegistrationId();
        MeetupRegistration__c registration2 = new MeetupRegistration__c(
            Id = fakeId2,
            Email__c = 'nolan@extroverted.com',
            FirstName__c = 'Extroverteded Nolan',
            LastName__c = 'Cretney',
            Meetup__c = meetup2.Id
        );
        
        Test.startTest();

        List<MeetupRegistration__c> registrations = new List<MeetupRegistration__c>();
        registrations.add(registration1);
        registrations.add(registration2);

        Test.stopTest();

        MeetupRegistrationDTO dto = new MeetupRegistrationDAC(registrations).getDTO();
        System.assertEquals(meetup1.Id, dto.getMeetup(registration1.Id).Id, 'DTO should map meetup registration with correct meetup');
        System.assertEquals(meetup2.Id, dto.getMeetup(registration2.Id).Id, 'DTO should map meetup registration with correct meetup');
    }
}