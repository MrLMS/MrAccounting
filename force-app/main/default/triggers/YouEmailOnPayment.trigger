trigger SendThankYouEmailOnPayment on AVAB__SO_Document__c(after update) {
  String custAcc = '';
  String contName = '';
  String accName = '';
  Decimal bal = 0;
  Decimal oldBalance = 0;
  String contId;

  if (Trigger.isAfter && Trigger.isUpdate) {
    map<id, AVAB__SO_Document__c> recMap = Trigger.newMap;
    map<id, AVAB__SO_Document__c> oldMap = Trigger.oldMap;

    list<AVAB__SO_Document__c> recList = [
      SELECT Id, Name, AVAB__Account__c, AVAB__Contact__c, AVAB__Balance__c
      FROM AVAB__SO_Document__c
      WHERE Id IN :recMap.keyset()
    ];
    list<AVAB__SO_Document__c> oldBal = [
      SELECT Id, AVAB__Balance__c
      FROM AVAB__SO_Document__c
      WHERE id IN :oldMap.keyset()
    ];

    for (AVAB__SO_Document__c r : oldBal) {
      oldBalance = oldMap.get(r.Id).AVAB__Balance__c;
      //System.debug('Old Balance ' + oldBalance );

      for (AVAB__SO_Document__c a : recList) {
        bal = recMap.get(a.Id).AVAB__Balance__c;
        contId = recMap.get(a.Id).AVAB__Contact__c;
        //System.debug('New Balance ' + bal);
        custAcc = recMap.get(a.Id).AVAB__Account__c;

        if (bal < oldBalance) {
          System.debug('Old Balance ' + oldBalance);
          System.debug('New balance ' + bal);

          Contact c = [SELECT name FROM Contact WHERE Id = :contId];
          contName = c.Name;
          System.debug('Contact Name ' + contName);

          Account acc = [SELECT Id, Name FROM Account WHERE id = :custAcc];
          accName = acc.Name;
          System.debug(' Account Name: ' + accName);

          SendBalanceMail.balanceMail(accName, contName, bal);
        }
      }
    }
  }

}
