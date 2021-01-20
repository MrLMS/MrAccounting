@IsTest
private class SendBalanceMailTest {
  @IsTest
  static void sendBalanceMailTest() {
    Account a = new Account();
    a.Name = 'Test acc';

    insert a;

    Contact c1 = new Contact();
    c1.LastName = 'Test1';
    c1.AccountId = a.Id;
    c1.Email = 'mracctbook2020@gmail.com';

    Contact c2 = new Contact();
    c2.LastName = 'Test';
    c2.AccountId = a.Id;
    c2.Email = 'mracctbook@gmail.com';

    Contact c3 = new Contact();
    c3.LastName = '3';
    c3.AccountId = a.Id;
    c3.Email = '';

    List<Contact> contList = new List<Contact>();
    contList.add(c1);
    contList.add(c2);
    contList.add(c3);

    Decimal balance = 100;
    String contName = 'Test Contact';

    insert contList;

    Test.startTest();
    SendBalanceMail.balanceMail('Test1', balance);
    SendBalanceMail.balanceMail('Test1', 0);
    Test.stopTest();
  }
}
