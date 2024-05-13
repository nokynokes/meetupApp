@isTest
public class TestUtils {
    
    private static String meetupRegistrationKeyPrefix {
        get {
            if(meetupRegistrationKeyPrefix == null) {
                meetupRegistrationKeyPrefix = getKeyPrefix('MeetupRegistration__c');
            }
            return meetupRegistrationKeyPrefix;
        }
        set;
    }

    private static String getKeyPrefix(String sObjectType) {
        Schema.SObjectType objectTypeSchema = Schema.getGlobalDescribe().get(sObjectType);
        Schema.DescribeSObjectResult resultDescription = objectTypeSchema.getDescribe();
        String keyPrefix = resultDescription.getKeyPrefix();

        return keyPrefix;
    }

    private static String getRandomTrailingDigits() {
        return String.valueOf(Math.round(Math.rint(Math.random() * 899999)) + 100000);
    }

    public static String getFakeMeetupRegistrationId() {
        return meetupRegistrationKeyPrefix + '000000000' + getRandomTrailingDigits();
    }

}