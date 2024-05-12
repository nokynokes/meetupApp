import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getMeetupByRegistrationCode from '@salesforce/apex/MeetupRegistrationController.getMeetupByRegistrationCode';

export default class MeetupRegistration extends LightningElement {
    @track registrationCode;
    @track meetup;
    @track meetup;
    @track error;

    @wire(CurrentPageReference)
    setPageReference(currentPageReference) {
        if(currentPageReference){
            this.registrationCode = currentPageReference.state?.c__registrationCode;
        }
    }

    @wire(getMeetupByRegistrationCode, { registrationCode: '$registrationCode' })
    wiredMeetup({ data, error }){
        console.log(data);
        console.log(error);
        if (data) {
            this.meetup = data;
            this.error = undefined;
        } else if (error) {
            this.meetup = undefined;
            this.error = error;
        }
    }
}