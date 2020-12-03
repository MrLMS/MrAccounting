trigger SendThankYouEmailOnPayment on AVAB__SO_Document__c(after update) {
  
  String custAcc = '';
  String contName = '';
  String accName = '';
  Decimal bal = 0;
  Decimal oldBalance = 0;
  String contId;
  
  
  map<id, AVAB__SO_Document__c> recMap = Trigger.newMap;
  map<id, AVAB__SO_Document__c> oldMap =  Trigger.oldMap;

  list<AVAB__SO_Document__c> recList = [select Id, Name, AVAB__Account__c, AVAB__Contact__c, AVAB__Balance__c from AVAB__SO_Document__c where Id IN :recMap.keyset()];
  list<AVAB__SO_Document__c> oldBal = [select Id, AVAB__Balance__c from AVAB__SO_Document__c where id IN :oldMap.keyset()];

  
  for(AVAB__SO_Document__c r: oldBal)
  {
    oldBalance = oldMap.get(r.Id).AVAB__Balance__c;
    System.debug('Old Balance ' + oldBalance );
  }

  for(AVAB__SO_Document__c a: recList)
  {
    bal  = recMap.get(a.Id).AVAB__Balance__c;
    contId = recMap.get(a.Id).AVAB__Contact__c;
    System.debug('Bal ' + bal);
    custAcc = recMap.get(a.Id).AVAB__Account__c;
  
  }
  
          
 
  if(bal < oldBalance){
      Contact c = [select name from Contact where Id = :contId];
      contName = c.Name;
      System.debug('Contact Name ' + contName);

      Account a =  [Select Id, Name from Account where id =: custAcc];
      accName = a.Name;
      System.debug(' Account Name: '+ accName);
        
      
     
      if(accName != null && accName != 'Candidate Pool'){
        System.debug('Account Present');
        SendBalanceMail.balanceMail(accName,bal);
      }
      else {
        System.debug('Account Absent');
        SendBalanceMail.balanceMail(contName,bal);
      }
    }
}
