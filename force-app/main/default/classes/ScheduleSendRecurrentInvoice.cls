global class ScheduleSendRecurrentInvoice implements Schedulable {
  global void execute(SchedulableContext sc) {
    List<String> recList = AutoCreateInvoices.generateInvoices();
    List<String> accList = new List<String>();
    System.debug('Received list' + recList);

    List<AVAB__SO_Document__c> invoiceIDs = [
      SELECT Id
      FROM AVAB__SO_Document__c
      WHERE Name IN :recList
    ];
    System.debug('IDs ' + invoiceIDs);

    for (AVAB__SO_Document__c rec : invoiceIDs) {
      String accId = rec.Id;
      accList.add(accId);
    }
    System.debug(accList);
    try {
      //SendVFEmail.sendBatchInvoices(accList);
      SendMonthlyInvoiceEmails.sendBatchInvoices(accList);
      System.debug('Sent');
    } catch (Exception e) {
      System.debug('The following exception has occurred: ' + e.getMessage());
    }
  }
}
