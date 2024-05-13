import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMeetupByRegistrationCode from '@salesforce/apex/MeetupRegistrationController.getMeetupByRegistrationCode';
import MEETUP_REGISTRATION_OBJECT from '@salesforce/schema/MeetupRegistration__c';
import EMAIL_FIELD from '@salesforce/schema/MeetupRegistration__c.Email__c'; 
import FIRST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.FirstName__c';
import LAST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.LastName__c';
import MEETUP_FIELD from '@salesforce/schema/MeetupRegistration__c.Meetup__c';   

export default class MeetupRegistration extends LightningElement {
    meetupRegistrationObj = MEETUP_REGISTRATION_OBJECT;
    meetupRegistrationFields = [EMAIL_FIELD, FIRST_NAME_FIELD, LAST_NAME_FIELD];
    
    @track registrationCode;

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
        this.dispatchEvent(new ShowToastEvent({
            title: 'Registration Created!',
            message: `Record ID: ${event.detail.id}`,
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