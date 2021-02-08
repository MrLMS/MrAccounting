@IsTest
private class PaymentsToInvoicesControllerTest {
  @IsTest
  static void getPaymentsToInvoiceTest() {
    PaymentsToInvoicesController.InvoiceDetailsWrapper wrapper = new PaymentsToInvoicesController.InvoiceDetailsWrapper();
    wrapper.invoice = '007684';
    wrapper.invoiceDate = Date.today();
    wrapper.contactName = 'Test contact';
    wrapper.balance = 100;

    List<PaymentsToInvoicesController.InvoiceDetailsWrapper> wrapperList = new List<PaymentsToInvoicesController.InvoiceDetailsWrapper>();

    wrapperList.add(wrapper);

    List<Contact> contList = new List<Contact>();
    List<AVAB__SO_Document__c> invList = new List<AVAB__SO_Document__c>();
    Decimal val = 500;

    Account acc = new Account();
    acc.Name = 'Test acc';

    insert acc;

    for (Integer j = 0; j < 3; j++) {
      Contact c = new Contact();
      c.LastName = 'contTest1' + j;
      c.AccountId = acc.Id;
      contList.add(c);
    }
    insert contList;

    for (Contact c : contList) {
      AVAB__SO_Document__c invoice = new AVAB__SO_Document__c();
      invoice.AVAB__Account__c = acc.Id;
      invoice.AVAB__Contact__c = c.Id;
      invoice.AVAB__Date__c = Date.Today();
      Id recTypeId = Schema.SObjectType.AVAB__SO_Document__c.getRecordTypeInfosByName()
        .get('Invoice')
        .getRecordTypeId();
      invoice.RecordTypeId = recTypeId;

      invList.add(invoice);
    }

    List<AVAB__SO_Document__c> insertedInvoices = [
      SELECT Id
      FROM AVAB__SO_Document__c
      WHERE Id IN :invList
    ];

    for (AVAB__SO_Document__c invoice : insertedInvoices) {
      invoice.AVAB__Amount__c = val;
      invoice.AVAB__Status__c = 'Post';
      val = val + 10;
    }

    try {
      update insertedInvoices;
    } catch (Exception e) {
      System.debug('Error found ' + e.getMessage());
    }

    //====================================================================================================

    PaymentsToInvoicesController.PaymentDetailsWrapper paymentWrapper = new PaymentsToInvoicesController.PaymentDetailsWrapper();
    paymentWrapper.paymentID = 'a280m000001GdQU';
    paymentWrapper.invoiceNumber = '736952';
    paymentWrapper.applyAmount = 30;

    String paymentID = paymentWrapper.paymentID;
    String invoiceNumber = paymentWrapper.invoiceNumber;
    Decimal amountToApply = paymentWrapper.applyAmount;

    AVAB__GL_Account__c glAcc = new AVAB__GL_Account__c();
    glAcc.Name = 'Test GLAccount';

    insert glAcc;

    AVAB__Payments__c pay = new AVAB__Payments__c();
    pay.AVAB__Account_Name__c = acc.Id;
    pay.AVAB__Transaction_Date_Time__c = Datetime.now();
    pay.AVAB__GL_Account__c = glAcc.Id;
    pay.AVAB__Date__c = Date.today();
    pay.AVAB__Amount__c = 100;
    pay.AVAB__Payments_Applied__c = null;

    insert pay;

    AVAB__Payments__c pay2 = new AVAB__Payments__c();
    pay2.AVAB__Account_Name__c = acc.Id;
    pay2.AVAB__Transaction_Date_Time__c = Datetime.now();
    pay2.AVAB__GL_Account__c = glAcc.Id;
    pay2.AVAB__Date__c = Date.today();
    pay2.AVAB__Amount__c = 50;
    pay2.AVAB__Payments_Applied__c = 10;

    insert pay2;

    AVAB__Payments__c pay3 = new AVAB__Payments__c();
    pay3.AVAB__Account_Name__c = acc.Id;
    pay3.AVAB__Transaction_Date_Time__c = Datetime.now();
    pay3.AVAB__GL_Account__c = glAcc.Id;
    pay3.AVAB__Date__c = Date.today();
    pay3.AVAB__Amount__c = 30;
    pay3.AVAB__Payments_Applied__c = 30;

    insert pay3;

    Test.startTest();
    List<PaymentsToInvoicesController.invoiceDetailsWrapper> paymentTest = PaymentsToInvoicesController.getPaymentsToInvoice(
      acc.Id
    );
    PaymentsToInvoicesController.applyPaymentToInvoice(paymentWrapper);
    Test.stopTest();
  }
}
