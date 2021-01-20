@IsTest
private class SendSingleVFEmailTest {
  @IsTest
  static void sendEmailWithAllParametersTest() {
    Map<String, String> params = new Map<String, String>();
    params.put('contEmail', 'toMail@testing.com');
    params.put('addTo', 'testing@test.com');
    params.put('acc', 'a2D0m000002PjcY');
    params.put('ccEmail', 'testcc@test.com');
    params.put('subject', 'Attn: Ramya for Invoice 000784');
    params.put('body', 'Find attached invoice');

    Test.startTest();
    SendSingleVFEmail.sendSingleEmailLWC(params);
    Test.stopTest();
  }
  @IsTest
  static void sendEmailWithoutAllParameters() {
    Map<String, String> params = new Map<String, String>();
    params.put('contEmail', '');
    params.put('addTo', '');
    params.put('acc', 'a2D0m000002PjcY');
    params.put('ccEmail', '');
    params.put('subject', 'Attn: Ramya for Invoice 000784');
    params.put('body', 'Find attached invoice');

    Test.startTest();
    SendSingleVFEmail.sendSingleEmailLWC(params);
    Test.stopTest();
  }
}
