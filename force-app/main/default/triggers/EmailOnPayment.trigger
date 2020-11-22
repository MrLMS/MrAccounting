trigger EmailOnPayment on AVAB__Payments__c (after update) {
    System.debug('payment made');
    if(Trigger.isAfter){

        System.debug('update done');

    // for(AVAB__Payments__c payment: Trigger.new)
    // {
    //     System.debug(payment.AVAB__Account_Name__c);
    //     Id accId = payment.AVAB__Account_Name__c;
    //    List<AVAB__SO_Document__c> receivables = [SELECT AVAB__Balance__c FROM AVAB__SO_Document__c WHERE AVAB__Account__c =: accId];
    //    //AVAB__SO_Document__c rec = receivables.get(0);
    //    for(Integer i = 0; i<receivables.size();i++)
    //    {
    //    System.debug('Balance ' + receivables.get(i) );
    //    }
    //  }
    }

}