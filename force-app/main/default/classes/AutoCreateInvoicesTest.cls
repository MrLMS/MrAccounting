
@IsTest
private class AutoCreateInvoicesTest {
    @IsTest static void generateInvoicesTest() {

        String invoiceNumber;
        List<String> invoiceNumbers = new List<String>(); 

        Account a =  new Account();
        a.Name = 'Candidate Pool';       
        
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
        

        List<Contact> contList = new List<Contact>();
        contList.add(c1);
        contList.add(c2);
        contList.add(c3);
        contList.add(c4);

        insert contList;
        

        
        Test.startTest();
        AutoCreateInvoices testInvoices = new AutoCreateInvoices();
        List<String> invList = testInvoices.generateInvoices();
        Test.stopTest();
        
        System.assert(invList != null);

        

          
    }
}
