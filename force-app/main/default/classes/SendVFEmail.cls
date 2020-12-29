public class SendVFEmail {
    @future(callout=true)
    public  static void sendBatchInvoices(List<String> accList){
        //public  void sendBatchInvoices(){   
        System.debug('Got accounts the list' + accList);
        String sMessage = '';
        //List<String> accList = new List<String> {'a2D0m000002PjBlEAK', 'a2D0m000002PjBmEAK', 'a2D0m000002PjBnEAK', 'a2D0m000002PjBoEAK', 'a2D0m000002PjBpEAK'};
        for(String acc :  accList){
             try{   
                AVAB__SO_Document__c  rec =  [SELECT AVAB__Contact__c FROM AVAB__SO_Document__c WHERE id = : acc];
                Contact c = [SELECT Email FROM Contact WHERE id = : rec.AVAB__Contact__c];
                String contEmail = c.Email;
                System.debug('Current Invoice '+ acc);
                
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                // Replace Visualforce(AccountDetails) page with your visualforce page
                
                PageReference pageref = new PageReference('/apex/ManualTemplateGeneratorXX?id=' + acc);
                //pref.getParameters().put('id',AccountId);
            // pref.setRedirect(true);
                Blob b = pageref.getContentAsPDF();
                attach.setFileName('Invoice.pdf');
                attach.setBody(b);
                semail.setSubject('Account Details');
                semail.setToAddresses(new List<String>{contEmail});
                semail.setPlainTextBody('Please find the attached Invoice');
                semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
                sMessage='SUCCESS';
             }
            catch(Exception ex){
                sMessage=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
                System.debug('Error ' + sMessage);
            }
         }

	}
}