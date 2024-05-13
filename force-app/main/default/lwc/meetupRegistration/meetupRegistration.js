import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMeetupByRegistrationCode from '@salesforce/apex/MeetupRegistrationController.getMeetupByRegistrationCode';
import getCode from '@salesforce/apex/MeetupRegistrationController.getCode';

import MEETUP_REGISTRATION_OBJECT from '@salesforce/schema/MeetupRegistration__c';
import EMAIL_FIELD from '@salesforce/schema/MeetupRegistration__c.Email__c'; 
import FIRST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.FirstName__c';
import LAST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.LastName__c'; 
import MEETUP_FIELD from '@salesforce/schema/MeetupRegistration__c.Meetup__c';   

export default class MeetupRegistration extends LightningElement {
    meetupRegistrationObj = MEETUP_REGISTRATION_OBJECT;
    meetupRegistrationFields = [EMAIL_FIELD, FIRST_NAME_FIELD, LAST_NAME_FIELD];
    emailField = EMAIL_FIELD;
    firstNameField = FIRST_NAME_FIELD;
    lastNameField = LAST_NAME_FIELD;
    meetupField = MEETUP_FIELD;
    
    registrationCode;
    meetupId;

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

    handleSearchSubmit(event) {
        event.preventDefault();
        const id = event.detail.fields.Meetup__c;
    
        getCode({ search: id })
            .then((results) => {
                this.registrationCode = results;    
            })
            .catch(console.log)
    }

    handleClick(event) {
        this.meetup = null;
    }

    handleSuccess(event) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Registration Complete!',
            message: `You have now registered for: ${this.meetup.data.Name}`,
            variant: 'success'
        }));
    }

    get meetupName() {
        return this.meetup.data.Name;
    }

    get meetupId() {
        return this.meetup.data.Id;
    }

    get data() {
        return this.meetup?.data;
    }

    get error() {
        return this.meetup?.error;
    }
}