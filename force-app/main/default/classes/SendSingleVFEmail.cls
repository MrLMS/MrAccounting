public class SendSingleVFEmail {
    @AuraEnabled(cacheable = true)

    public static String sendSingleEmailLWC(Map<String,String> params) {

        System.debug('Received '+  params);

        String acc = params.get('acc');
        String mail = params.get('contEmail');
        String addTo = params.get('addTo');
        String ccEmail = params.get('ccEmail');
        String subject = params.get('subject');
        String body = params.get('body');
        String stripHtmlBody = body.stripHtmlTags();

        List<String> mailList = new List<String>();
        if(mail != null){
            mailList.add(mail);
        }
        if(!(String.isBlank(addTo))){
            mailList.add(addTo);
        }
        

        String sMessage = '';
        String msg = 'Sent sucessfully';
        
            try{    
                   

                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
               
                
                PageReference pageref = new PageReference('/apex/ManualTemplateGeneratorXX?id=' + acc);
                
                Blob b = pageref.getContent();
                attach.setFileName('Invoice.pdf');
                attach.setBody(b);
                semail.setSubject('Account Details');
                if(mailList.size()> 0){
                    semail.setToAddresses(mailList);
                }
                
                if(!(String.isBlank(ccEmail))){
                    semail.setCcAddresses(new String [] {ccEmail});
                }
                
                semail.setPlainTextBody(stripHtmlBody);
                semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
                
                System.debug('Email Sent Successfully!');
             }
            catch(Exception ex){
                sMessage=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
                System.debug('Error ' + sMessage);
            }
          return msg;  
    }
}
