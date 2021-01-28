@IsTest
private class SendBalanceMailTest {
  @IsTest
  static void sendBalanceMailTest() {
    Account a = new Account();
    a.Name = 'Test acc';

    insert a;

    Account b = new Account();
    b.Name = 'Candidate Pool';

    insert b;

    Contact c1 = new Contact();
    c1.LastName = 'Test1';
    c1.AccountId = a.Id;
    c1.Email = 'mracctbook2020@gmail.com';

    Contact c2 = new Contact();
    c2.LastName = 'Test';
    c2.AccountId = a.Id;
    c2.Email = 'mracctbook@gmail.com';

    Contact c3 = new Contact();
    c3.LastName = 'Test3';
    c3.AccountId = a.Id;
    c3.Email = '';

    Contact b1 = new Contact();
    b1.LastName = 'Test2';
    b1.AccountId = b.Id;
    b1.Email = 'mracctbook2020@gmail.com';

    List<Contact> contList = new List<Contact>();
    contList.add(c1);
    contList.add(c2);
    contList.add(c3);
    contList.add(b1);

    Decimal balance = 100;
    Decimal bal = 0;
    String contName = 'Test Contact';

    insert contList;

    Test.startTest();
    SendBalanceMail.balanceMail('Test acc', 'Test', balance);
    SendBalanceMail.balanceMail('Candidate Pool', 'Test1', balance);
    SendBalanceMail.balanceMail('Test acc', 'Test1', bal);
    Test.stopTest();
  }
}
