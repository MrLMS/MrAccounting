global class ScheduleSendRecurrentInvoice implements Schedulable {
    global void execute(SchedulableContext sc){
        List<AVAB__SO_Document__c> recList = [select Id from AVAB__SO_Document__c where AVAB__Recurring_Period__c = 'Monthly'];
        List<String> accList = new List<String>();
        for(AVAB__SO_Document__c rec : recList){
            String accId = rec.Id;
            accList.Add(accId);
        
        }
        System.debug(accList);
        try{
        SendVFEmail.sendBatchInvoices(accList);
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}
