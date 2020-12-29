
@IsTest
private class AutoCreateInvoicesTest {
    @IsTest static void generateInvoicesTest() {

        Account a =  new Account();
        a.Name = 'Candidate Pool';

        

        AVAB__Item__c item = new AVAB__Item__c();
        item.Name = 'Launch Pad Fees';
        item.AVAB__Sales_Price__c = 79;

        AVAB__Item__c item2 = new AVAB__Item__c();
        item2.Name = 'Training Fees';
        item2.AVAB__Sales_Price__c = 39;

        List<AVAB__Item__c>  products = new List<AVAB__Item__c>();
        products.add(item);
        products.add(item2);
        
        Contact c1 = new Contact();
        c1.AccountId = a.Id;
        c1.LastName = 'Priya';
        c1.Membership_Type__c = 'LaunchPad Membership';
        c1.Launchpad_Membership_Fees_Waived__c = false;
        c1.AVTRRT__Candidate_Status__c = 'Active';

        Contact c2 = new Contact();
        c2.AccountId = a.Id;
        c2.LastName = 'Brie';
        c2.Membership_Type__c = 'Training Membership';
        c2.Launchpad_Membership_Fees_Waived__c = false;
        c2.AVTRRT__Candidate_Status__c = 'Active';

        Contact c3 = new Contact();
        c3.AccountId = a.Id;
        c3.LastName = 'Shashank';
        c3.Membership_Type__c = 'Alumni Membership';
        c3.Launchpad_Membership_Fees_Waived__c = true;
        
        Contact c4 = new Contact();
        c4.AccountId = a.Id;
        c4.LastName = 'Priyanka';
        c4.Membership_Type__c = 'LaunchPad Membership';
        c4.Launchpad_Membership_Fees_Waived__c = true;
        c4.AVTRRT__Candidate_Status__c = 'Active';
        

        List<Contact> memList = new List<Contact>();
        memList.add(c1);
        memList.add(c2);
        memList.add(c3);
        memList.add(c4);

       

        Test.startTest();
        insert a;
        insert memList;
        insert products;
        

        List<Contact> contList = [SELECT Id, AccountId, Membership_Type__c FROM Contact WHERE 
                                                                                        Id IN : memList
                                                                                        AND Membership_Type__c IN ('Training Membership','LaunchPad Membership') 
                                                                                        AND Launchpad_Membership_Fees_Waived__c = false
                                                                                        AND AVTRRT__Candidate_Status__c = 'Active'];
                                                                                
        

        List<AVAB__SO_Document__c> invList = new List<AVAB__SO_Document__c>() ;
        for(Contact c: contList){
            AVAB__SO_Document__c invoice = new AVAB__SO_Document__c();
            invoice.AVAB__Account__c = c.AccountId;
            invoice.AVAB__Contact__c = c.Id;
            Id recTypeId = Schema.SObjectType.AVAB__SO_Document__c.getRecordTypeInfosByName().get('Invoice').getRecordTypeId();
            invoice.RecordTypeId = recTypeId;

            invList.add(invoice);

        }
        insert invList;
        

        List<AVAB__SO_Document__c> insertedInvoices = [SELECT Name,AVAB__Contact__c,AVAB__Amount__c FROM AVAB__SO_Document__c WHERE Id IN :invList];

        System.debug('Contact '+ contList.size());
        System.debug('invoices '+ invList.size());
        System.debug('invoices inserted '+ insertedInvoices.size());
        

        List<AVAB__Transaction_Line_Items__c> tranLItemList = new List<AVAB__Transaction_Line_Items__c>();

        for(AVAB__SO_Document__c inv : insertedInvoices){

            
            for(Contact c: contList){
           
                if(inv.AVAB__Contact__c == c.Id){

                    AVAB__Transaction_Line_Items__c tLItem = new AVAB__Transaction_Line_Items__c();
                    if(c.Membership_Type__c.contains('Launch') ){
                        
                        System.debug('found launch');
                        System.debug('Product id= '+ item.Id);
                            tLItem.AVAB__Product__c = item.Id;
                            tLItem.AVAB__Quantity__c = 1;
                            tLItem.AVAB__AR_Transaction__c = inv.Id;
                            tLItem.AVAB__Sales_Price__c = item.AVAB__Sales_Price__c;
                            tranLItemList.add(tLItem);

                            inv.AVAB__Amount__c = item.AVAB__Sales_Price__c;
                            inv.AVAB__Status__c = 'Post';
                            
                        }
                        else if(c.Membership_Type__c.contains('Train')) {
                            System.debug('found training');                   
                            tLItem.AVAB__Product__c = item2.Id;
                            tLItem.AVAB__Quantity__c = 1;
                            tLItem.AVAB__AR_Transaction__c = inv.Id;
                            tLItem.AVAB__Sales_Price__c = item2.AVAB__Sales_Price__c;
                            
                            inv.AVAB__Amount__c = item2.AVAB__Sales_Price__c;
                            inv.AVAB__Status__c = 'Post';
                           

                            tranLItemList.add(tLItem);
                        }
                    }
                    else {
                        continue;
                 }
             }
        }
        System.debug('TLItems ' + tranLItemList.size());
      

        Test.stopTest();

        System.assertEquals(2, invList.size(), 'Incorrect number of invoices');
        System.assertEquals(2, contList.size(), 'Incorrect number of active Candidates');
        System.assertEquals(2, insertedInvoices.size(), 'Incorrect number of inserted invoices');
        System.assertEquals(2, tranLItemList.size(), 'Incorrect number of transaction line items');
        System.assertEquals(2, insertedInvoices.size(), 'Incorect number of updated invoices');      
    }
}
