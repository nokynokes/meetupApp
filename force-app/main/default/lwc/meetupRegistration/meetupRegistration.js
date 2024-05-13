import { LightningElement, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMeetupByRegistrationCode from '@salesforce/apex/MeetupRegistrationController.getMeetupByRegistrationCode';
import MEETUP_REGISTRATION_OBJECT from '@salesforce/schema/MeetupRegistration__c';
import EMAIL_FIELD from '@salesforce/schema/MeetupRegistration__c.Email__c'; 
import FIRST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.FirstName__c';
import LAST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.LastName__c';   

export default class MeetupRegistration extends NavigationMixin(LightningElement) {
    meetupRegistrationObj = MEETUP_REGISTRATION_OBJECT;
    meetupRegistrationFields = [EMAIL_FIELD, FIRST_NAME_FIELD, LAST_NAME_FIELD];
    
    registrationCode;

    @wire(CurrentPageReference)
    setRegistrationCodeFromURL(currentPageReference) {
        if(currentPageReference){
            this.registrationCode = currentPageReference.state?.c__registrationCode;
        }
    }

    @wire(getMeetupByRegistrationCode, { registrationCode: '$registrationCode' })
    meetup;

    handleSubmit(event) {
        event.preventDefault();
        this.template.querySelector('lightning-record-form').submit({
            Meetup__c: this.meetup.data.Id,
            ...event.detail.fields,
        });
    }

    handleSuccess(event) {
        console.log('success!');
        console.log(event);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Registration Complete!',
            message: `You have now registered for: ${this.meetup.data.Name}`,
            variant: 'success'
        }));
    }

    get meetupName() {
        return this.meetup.data.Name;
    }

    get meetupRegistrationCode() {
        return this.meetup.data.RegistrationCode__c;
    }

    get meetupRegistrationCount() {
        return this.meetup.data.RegistrationCount__c;
    }

    get meetupRegistrationLimit() {
        return this.meetup.data.RegistrationLimit__c;
    }

    get meetupRegistrationStatus() {
        return this.meetup.data.Status__c;
    }

    get limitNotReached() {
        return this.meetup.data.RegistrationCode__c !== this.meetup.data.RegistrationLimit__c;
    }

    get error() {
        return this.meetup.error;
    }
}