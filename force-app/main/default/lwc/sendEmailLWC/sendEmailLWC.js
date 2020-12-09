import { LightningElement, api, wire, track } from 'lwc';
import sendSingleEmailLWC from '@salesforce/apex/SendSingleVFEmail.sendSingleEmailLWC';
export default class SendEmailLWC extends LightningElement {
    @api flexipageRegionWidth = 'LARGE';
    @api recordId;
    @track error;
    @track accounts;

   handleSend(){
    console.log('I got it!' + this.recordId);
    sendSingleEmailLWC(this.recordId)
        .then(result => {
            this.accounts = result;
        })
        .catch(err => {
            this.error = err;
            console.log('Error '+ err);
        })
   }
       
   
    
    
}