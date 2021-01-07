public class AutoCreateInvoices {
    public static List<String> generateInvoices() {

       String invoiceNumber;
        
       List<AVAB__SO_Document__c> recList =  new List<AVAB__SO_Document__c>();     
       
       List<String> invoiceNumbers = new List<String>();       

       List<Contact> contList = [SELECT Id, AccountId, Fee_Charged__c FROM Contact WHERE 
                                                                                        Fee_Charged__c > 0
                                                                                        AND Launchpad_Membership_Fees_Waived__c = false
                                                                                        AND AVTRRT__Candidate_Status__c = 'Active'];
       

      
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

            List<AVAB__SO_Document__c> insertedInvoices = [SELECT Name,AVAB__Contact__c,AVAB__Amount__c FROM AVAB__SO_Document__c WHERE Id IN :recList];

            for(AVAB__SO_Document__c inv : insertedInvoices)
            {   
                invoiceNumber = inv.Name;
                invoiceNumbers.add(invoiceNumber);

                for(Contact c: contList){
                    
                    if(inv.AVAB__Contact__c == c.Id)
                    {
                        inv.AVAB__Amount__c = c.Fee_Charged__c;
                        inv.AVAB__Status__c = 'Post';

                     }
                }
            }
      
            update insertedInvoices;
   
        }
        catch(Exception e)
        {
            System.debug('Error ' + e.getMessage());
        }
        
            System.debug('Invoice List '+ invoiceNumbers);
        return invoiceNumbers;

    }
}
