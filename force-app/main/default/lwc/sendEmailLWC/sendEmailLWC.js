import { LightningElement, api, wire, track } from 'lwc';
import sendSingleEmailLWC from '@salesforce/apex/SendSingleVFEmail.sendSingleEmailLWC';
import getInvoiceDetails from '@salesforce/apex/GetInvoiceDetails.getInvoiceDetails';
export default class SendEmailLWC extends LightningElement {
    @api flexipageRegionWidth = 'LARGE';
    @api recordId;
    @track error;
    @track hasRendered = true;
    
    
    invoiceNum = '';
    contactEmail = '';
    contactName = '';
    subject = '';
    body = '';
    
    
    
    renderedCallback(){

        if(this.hasRendered){
        console.log('The Id is ' + this.recordId);
        this.hasRendered = false;

        getInvoiceDetails({accID: this.recordId})
                .then(result => {
                    console.log('Results are ' + JSON.stringify(result));
                    
                    this.contactEmail = result.Email;
                    this.invoiceNum = result.Invoice;
                    this.contactName = result.Contact;
                    console.log('Email ' + this.contactEmail);
                    console.log('Contact ' + this.contactName);
                    console.log('Invoice Number ' + this.invoiceNum);
                    this.subject = 'Attn: '+ this.contactName + ' for Invoice ' + this.invoiceNum;
                    this.body = 'Find the attached invoice. \n';
                    this.error = undefined;
                })
                .catch(err => {
                    console.log('Error found '+ err);
                    this.error = err;
                    
                })
   
        }
    }
    handleClick(){
        
        const editor = this.template.querySelector('lightning-input-rich-text');
        editor.setRangeText('');
    }
    
    
   handleSend(){
        sendSingleEmailLWC({acc: this.recordId})
        .then(result => {
               console.log('Result is '+ JSON.stringify(result));
        })
        .catch(err => {
            this.error = err;  
            console.log('Error occured '+ err.body.message);
        })
   }
       
   
    
    
}