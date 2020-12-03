trigger EmailOnPayment on AVAB__Payments__c(after update) {
  System.debug('payment made');
  if (Trigger.isAfter) {
    System.debug('update done');

    
  }

}
