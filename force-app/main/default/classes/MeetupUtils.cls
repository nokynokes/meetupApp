public class MeetupUtils {
    private static final String meetupKeyPrefix {
        get {
            if(meetupKeyPrefix == null) {
                Schema.SObjectType meetupSchema = Schema.getGlobalDescribe().get('Meetup__c');
                Schema.DescribeSObjectResult resultDescription = meetupSchema.getDescribe();
                meetupKeyPrefix = resultDescription.getKeyPrefix();
            }

            return meetupKeyPrefix;
        }
        set;
    }

    public static String generateRegistrationCode() {
        return meetupKeyPrefix + getRandomTrailingDigits();
    }

    private static String getRandomTrailingDigits() {
        return String.valueOf(Math.round(Math.rint(Math.random() * 89999)) + 10000);
    }
}