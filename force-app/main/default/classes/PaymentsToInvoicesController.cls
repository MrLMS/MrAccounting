public with sharing class PaymentsToInvoicesController {
  @AuraEnabled(cacheable=true)
  public static List<PaymentsToInvoicesController.invoiceDetailsWrapper> getPaymentsToInvoice(
    String accID
  ) {
    System.debug('Received account ' + accID);

    //Id accID = '0010m00000a4I2j';

    List<PaymentsToInvoicesController.invoiceDetailsWrapper> invoiceDetailsWrapperList = new List<PaymentsToInvoicesController.invoiceDetailsWrapper>();

    List<AVAB__SO_Document__c> invoiceList = [
      SELECT Name, AVAB__Date__c, AVAB__Balance__c, AVAB__Contact__r.Name
      FROM AVAB__SO_Document__c
      WHERE AVAB__Account__c = :accID AND AVAB__Balance__c > 0
    ];

    for (AVAB__SO_Document__c invoice : invoiceList) {
      PaymentsToInvoicesController.invoiceDetailsWrapper invWrapper = new PaymentsToInvoicesController.invoiceDetailsWrapper();
      invWrapper.invoice = invoice.Name;
      invWrapper.invoiceDate = invoice.AVAB__Date__c;
      invWrapper.contactName = invoice.AVAB__Contact__r.Name;
      invWrapper.balance = invoice.AVAB__Balance__c;

      invoiceDetailsWrapperList.add(invWrapper);
    }

    return invoiceDetailsWrapperList;
  }

  public class invoiceDetailsWrapper {
    @AuraEnabled
    public String invoice { get; set; }
    @AuraEnabled
    public Date invoiceDate { get; set; }
    @AuraEnabled
    public String contactName { get; set; }
    @AuraEnabled
    public Decimal balance { get; set; }
  }

  public class paymentDetailsWrapper {
    @AuraEnabled
    public String paymentID { get; set; }
    @AuraEnabled
    public String invoiceNumber { get; set; }
  }

  @AuraEnabled
  public static void applyPaymentToInvoice(
    PaymentsToInvoicesController.paymentDetailsWrapper paymentWrapper
  ) {
    String invoice = paymentWrapper.invoiceNumber;
    String paymentId = paymentWrapper.paymentID;

    String invID;

    List<AVAB__Payments_to_Invoice__c> paymentsList = new List<AVAB__Payments_to_Invoice__c>();

    System.debug('Invoice received ' + invoice);
    System.debug('Payment Id received ' + paymentId);

    List<AVAB__Payments__c> payments = [
      SELECT AVAB__Amount__c
      FROM AVAB__Payments__c
      WHERE Id = :paymentId
    ];
    List<AVAB__SO_Document__c> selectedInvoices = [
      SELECT Id, AVAB__Credit_Memo_Amount__c
      FROM AVAB__SO_Document__c
      WHERE Name = :invoice
    ];

    System.debug('List inv ' + selectedInvoices);

    for (AVAB__Payments__c payment : payments) {
      for (AVAB__SO_Document__c inv : selectedInvoices) {
        AVAB__Payments_to_Invoice__c newPayment = new AVAB__Payments_to_Invoice__c();
        newPayment.AVAB__Receivable__c = inv.Id;
        newPayment.AVAB__Amount__c = payment.AVAB__Amount__c;

        invID = inv.Id;

        paymentsList.add(newPayment);
        payment.AVAB__Payments_Applied__c = payment.AVAB__Amount__c;

        System.debug('amount ' + inv.AVAB__Credit_Memo_Amount__c);
      }
    }

    try {
      insert paymentsList;
      update payments;
      AVAB__SO_Document__c insertedInvoice = [
        SELECT AVAB__Balance__c
        FROM AVAB__SO_Document__c
        WHERE Id = :invID
      ];
      System.debug('Updated Invoice Balance ' + insertedInvoice);
    } catch (Exception e) {
      System.debug('Error occured ' + e.getMessage());
    }
  }
}
