public class SendSingleVFEmail {
    @AuraEnabled(cacheable = true)

    public static void sendSingleEmailLWC(String acc) {
        
        String sMessage = '';
        
             try{    
                System.debug(acc);
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                // Replace Visualforce(AccountDetails) page with your visualforce page
                
                PageReference pageref = new PageReference('/apex/ManualTemplateGeneratorXX?id=' + acc);
                //pref.getParameters().put('id',AccountId);
            // pref.setRedirect(true);
                Blob b = pageref.getContent();
                attach.setFileName('Invoice.pdf');
                attach.setBody(b);
                semail.setSubject('Account Details');
                semail.setToAddresses(new List<String>{'paulawambui@gmail.com'});
                semail.setPlainTextBody('Please find the attached Invoice');
                semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
                sMessage='SUCCESS';
             }
            catch(Exception ex){
                sMessage=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
                System.debug('Error' + sMessage);
            }
    }
}
