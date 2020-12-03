public class SendBalanceMail {
  public static void balanceMail(String contName, Decimal bal) {
      
    System.debug('called' + contName);
    
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //mail.setToAddresses(new String[] {'paulawambui@gmail.com'});
    mail.setToAddresses(new String[] {'mraccounting@momrelaunch.com','paulawambui@gmail.com'});
    mail.setSubject('Thank you for your payment!');
    String messageBody = '<html><body> Dear ' + contName + ',<br/><br/> We have successfully processed your payment.<br/> <br/>Your remaining balance is ' + bal +  '.<br/>Thank you for your business! <br/><br/> Mom Relaunch</body>  </html>';
    String messageBody2 = '<html><body> Dear ' + contName + ',<br/><br/> We have successfully processed your payment<br/>.  <br/> Thank you for your business! <br/><br/> Mom Relaunch</body>  </html>';
    
    if(bal > 0){
      mail.setHtmlBody(messageBody);
    }
    else {
      mail.setHtmlBody(messageBody2);
    }
    
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}
