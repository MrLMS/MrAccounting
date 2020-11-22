trigger SendThankYouEmailOnPayment on AVAB__SO_Document__c (after update ) {

    Set<Id> rec = trigger.newMap.keyset();
    map<id, AVAB__SO_Document__c> recMap = trigger.newMap;

    list<AVAB__SO_Document__c> recList = trigger.new;

}