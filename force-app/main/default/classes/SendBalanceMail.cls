public class SendBalanceMail {
  public static void balanceMail(String contName, Decimal bal) {
      
    System.debug('Billable Contact  ' + contName);
    //fetch email
    Contact c =  [SELECT Email FROM Contact WHERE Name = :contName];
    String contEmail = c.Email;

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //mail.setToAddresses(new String[] {'paulawambui@gmail.com'});
    //mail.setToAddresses(new String[] {'mracctbook2020@gmail.com','paulawambui@gmail.com'});
    mail.setToAddresses(new String[] {contEmail});
    mail.setSubject('Thank you for your payment!');
    String messageBody = '<html><body> Dear ' + contName + ',<br/><br/> We have successfully processed your payment.<br/> <br/>Your remaining balance is ' + bal +  '.<br/><br/> Thank you for your business! <br/><br/> Mom Relaunch</body>  </html>';
    String messageBody2 = '<html><body> Dear ' + contName + ',<br/><br/> We have successfully processed your payment.<br/>  <br/> Thank you for your business! <br/><br/> Mom Relaunch</body>  </html>';
    
    if(bal > 0){
      mail.setHtmlBody(messageBody);
    }
    else {
      mail.setHtmlBody(messageBody2);
    }
    
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}