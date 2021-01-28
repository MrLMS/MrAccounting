public class SendThankYouEmailOnPayment {
  public static void sendThankYouEmail(String invID, Decimal amount) {
    String accName;
    String contName;
    Decimal balance;

    System.debug('Received ' + invID + amount);
    AVAB__SO_Document__c invDetails = [
      SELECT Id, AVAB__Account__r.Name, AVAB__Contact__c, AVAB__Balance__c
      FROM AVAB__SO_Document__c
      WHERE Id = :invID
    ];
    accName = invDetails.AVAB__Account__r.Name;
    balance = invDetails.AVAB__Balance__c - amount;

    Contact cont = [
      SELECT Name
      FROM Contact
      WHERE Id = :invDetails.AVAB__Contact__c
    ];
    contName = cont.Name;

    System.debug('Dets ' + accName + contName + balance);

    SendBalanceMail.balanceMail(accName, contName, balance);
  }
}
