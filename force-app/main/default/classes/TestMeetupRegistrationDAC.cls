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

        Test.startTest();
        
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

        List<MeetupRegistration__c> registrations = new List<MeetupRegistration__c>();
        registrations.add(registration1);
        registrations.add(registration2);

        MeetupRegistrationDTO dto = new MeetupRegistrationDAC(registrations).getDTO();

        Test.stopTest();

        
        System.assertEquals('Introvert Meetup', dto.getMeetup(meetup1.Id).Name, 'DTO should map meetup correctly');
        System.assertEquals('Extrovert Meetup', dto.getMeetup(meetup2.Id).Name, 'DTO should map meetup correctly');

        System.assertEquals(1, dto.getRegistrations(meetup1.Id).size(), 'DTO should map meetup registrations correctly');
        System.assertEquals(1, dto.getRegistrations(meetup2.Id).size(), 'DTO should map meetup registartions correctly');
    }
}