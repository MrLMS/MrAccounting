public class AutoCreateInvoices {
    public static List<String> generateInvoices() {
        
       List<Contact> contList = [SELECT Id, AccountId, Membership_Type__c FROM Contact WHERE 
                                                                                        Membership_Type__c IN ('Training Membership','LaunchPad Membership') 
                                                                                        AND Launchpad_Membership_Fees_Waived__c = false
                                                                                        AND AVTRRT__Candidate_Status__c = 'Active'];
       List<AVAB__SO_Document__c> recList =  new List<AVAB__SO_Document__c>();
       List<AVAB__Transaction_Line_Items__c> tranLItemList = new List<AVAB__Transaction_Line_Items__c>();
       List<AVAB__Item__c> products =  [SELECT Id,Name, AVAB__Sales_Price__c FROM AVAB__Item__c];
       List<String> invoiceNumbers = new List<String>();

       String regLaunch = 'Launch';
       String regTrain = 'Training';
       String launchProdId;
       String trainProdId;
       Decimal lpFees;
       Decimal trFees;
       String invo;

   
       
       for(AVAB__Item__c prod : products)
       {
           if((prod.Name).contains(regLaunch) )
           {
               
               launchProdId = prod.Id;
               lpFees = prod.AVAB__Sales_Price__c;
           }
           if((prod.Name).contains(regTrain) )
           {
               
               trainProdId = prod.Id;
               trFees = prod.AVAB__Sales_Price__c;
           }
       }
       
       for(Contact c: contList){
            
           
            AVAB__SO_Document__c rec = new AVAB__SO_Document__c();
            rec.AVAB__Account__c = c.AccountId;
            rec.AVAB__Contact__c = c.Id;            
            
            Id recType = Schema.SObjectType.AVAB__SO_Document__c.getRecordTypeInfosByName().get('Invoice').getRecordTypeId();
            rec.RecordTypeId = recType;
            recList.add(rec);
        }
              
        
        try{
            insert recList;
            List<AVAB__SO_Document__c> invoiceDet = [SELECT Name,AVAB__Contact__c,AVAB__Amount__c FROM AVAB__SO_Document__c WHERE Id IN :recList];

           
           
            for(AVAB__SO_Document__c inv : invoiceDet)
            {   
                invo = inv.Name;
                invoiceNumbers.add(invo);
                
                

                for(Contact c: contList){
                    
                    if(inv.AVAB__Contact__c == c.Id)
                    {
                        AVAB__Transaction_Line_Items__c tLItem = new AVAB__Transaction_Line_Items__c();
                        if(c.Membership_Type__c.contains(regLaunch) )
                        {
                        
                            tLItem.AVAB__Product__c = launchProdId;
                            tLItem.AVAB__Quantity__c = 1;
                            tLItem.AVAB__AR_Transaction__c = inv.Id;
                            tLItem.AVAB__Sales_Price__c = lpFees;
                            tranLItemList.add(tLItem);

                            inv.AVAB__Amount__c = lpFees;
                            inv.AVAB__Status__c = 'Post';
                            
                        }
                        else if(c.Membership_Type__c.contains(regTrain)) {
                                                
                            tLItem.AVAB__Product__c = trainProdId;
                            tLItem.AVAB__Quantity__c = 1;
                            tLItem.AVAB__AR_Transaction__c = inv.Id;
                            tLItem.AVAB__Sales_Price__c = trFees;
                            
                            inv.AVAB__Amount__c = trFees;
                            inv.AVAB__Status__c = 'Post';
                           

                            tranLItemList.add(tLItem);
                        }

                     }

                    
                }
            }
            upsert tranLItemList;
            update invoiceDet;
            System.debug('Inserted ' + tranLItemList);
            
           
        }
        catch(Exception e)
        {
            System.debug('Error ' + e.getMessage());
        }
        
        System.debug('Invoice List '+ invoiceNumbers);
        return invoiceNumbers;

    }
}
