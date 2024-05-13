import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi'
import REGISTRATION_CODE_FIELD from '@salesforce/schema/Meetup__c.RegistrationCode__c'

export default class RedirectToRegistration extends NavigationMixin(LightningElement) {
    @api recordId

    @wire(getRecord,  { recordId: '$recordId', fields: REGISTRATION_CODE_FIELD })
    meetup;

    handleClick(event){ 
       const c__registrationCode = this.meetup.data.fields.RegistrationCode__c.value;

       this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Meetup_Registration',
            },
            state: {
                c__registrationCode
            }
       });
    }
}