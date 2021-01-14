@IsTest
private class SendThankYouEmailOnPaymentTest {

@IsTest
 static void sendEmailOnFullPaymentTest() {

    AVAB__GL_Account__c glAcc = new AVAB__GL_Account__c(Name = 'Test GL Account');
    insert glAcc;

    AVAB__SO_Document__c [] invoices = TestDataFactory.createInvoicesBasedOnNumOfContacts(5);

    List<AVAB__SO_Document__c> invoiceDetails = [SELECT Id, AVAB__Account__c, AVAB__Balance__c FROM AVAB__SO_Document__c WHERE Id IN :invoices];

    List<AVAB__Payments__c> paymentsList = new List<AVAB__Payments__c>();

    List<AVAB__Payments_to_Invoice__c> payToInvoiceList = new List<AVAB__Payments_to_Invoice__c>();

   
    System.debug('Returned Invoices ' + invoiceDetails);

    for(AVAB__SO_Document__c invoice : invoiceDetails){

        AVAB__Payments__c payment = new AVAB__Payments__c();
        payment.AVAB__Account_Name__c = invoice.AVAB__Account__c;
        payment.AVAB__Transaction_Date_Time__c = Datetime.now();
        payment.AVAB__Amount__c = 20;
        payment.AVAB__GL_Account__c = glAcc.Id;

        paymentsList.add(payment);

        AVAB__Payments_to_Invoice__c applyPayment = new AVAB__Payments_to_Invoice__c();
        applyPayment.AVAB__Receivable__c = invoice.Id;
        applyPayment.AVAB__Payment__c = payment.Id;
        applyPayment.AVAB__Amount__c = 20;

        payToInvoiceList.add(applyPayment);

    }

    insert paymentsList;
    insert payToInvoiceList;

            

    }
}
