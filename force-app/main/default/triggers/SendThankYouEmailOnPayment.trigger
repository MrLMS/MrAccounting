trigger SendThankYouEmailOnPayment on AVAB__SO_Document__c (after update) {

Contact client = new Contact()    ;
if(Trigger.isAfter){
    for(AVAB__SO_Document__c receivable: Trigger.old){

        client = receivable.AVAB__Contact__c;
        Decimal prevBal = receivable.AVAB__Balance__c;
        
         for(AVAB__SO_Document__c rec: Trigger.new){
             if(rec.AVAB__Balance__c < prevBal )
             {
                newBal = prevBal - rec.AVAB__Balance__c;
                if(newBal > 0){
                    SendBalanceMail(client,newbal);
                }
                else {
                    SendMail(client);
                }

                
             }
         }
    }
 }

}