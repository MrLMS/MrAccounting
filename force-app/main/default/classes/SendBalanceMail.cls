public with sharing class SendBalanceMail {
    public static void SendBalanceMail(Contact c, Decimal bal) {
        String cName = c.Name;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'paulawambui@gmail.com'});
        mail.setSubject('Thank you for your payment!');
        String messageBody = '<html><body> Dear ' + cName + ',<br/> We have successfully processed your payment. <br/>Your remaining balance is ' + bal +  '. <br/> Thank you for your business! <br/><br/> Mom Relaunch</body>  </html>';
        mail.setHtmlBody(messageBody); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
