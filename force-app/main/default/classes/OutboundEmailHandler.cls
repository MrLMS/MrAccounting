public with sharing class OutboundEmailHandler {
  public void trackOutboundEmail() {
    String acc = 'a2D0m000002Xsr2EAC';
    String mail = 'paulawambui@gmail.com';
    String addTo = '';
    String ccEmail = 'paulawambui@yahoo.com';
    String bccEmail = 'emailtosalesforce@r-293i2f270udi74o377e72fx4oekf8b5myp66ia5k8o8566qiwy.0m-a4x7eak.cs65.le.sandbox.salesforce.com';
    String subject = 'Attachment email test';
    String body = 'email to salesforce testing';
    String stripHtmlBody = body.stripHtmlTags();

    Datetime todaysDate = Datetime.now();
    System.debug('Month ' + todaysDate.format('MMMM'));

    // List<String> mailList = new List<String>();
    // if (mail != null) {
    //   mailList.add(mail);
    // }
    // if (!(String.isBlank(addTo))) {
    //   mailList.add(addTo);
    // }

    // String sMessage = '';
    // String msg = 'Sent sucessfully';

    // try {
    //   Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
    //   //Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();

    //   PageReference pageref = new PageReference(
    //     '/apex/ManualTemplateGeneratorXX?id=' + acc
    //   );

    //   Blob b;
    //   ContentVersion cv = new ContentVersion();
    //   if (Test.isRunningTest()) {
    //     b = blob.valueOf('Unit.Test');
    //   } else {
    //     b = pageref.getContent();
    //   }
    //   cv.VersionData = b;
    //   cv.Title = 'Client Invoice';
    //   cv.PathOnClient = 'Invoice.pdf';
    //   cv.ContentLocation = 'S';
    //   cv.Description = 'Customer invoice';
    //   cv.IsMajorVersion = true;
    //   insert cv;

    //   Id conDocument = [
    //     SELECT ContentDocumentId
    //     FROM ContentVersion
    //     WHERE Id = :cv.Id
    //   ]
    //   .ContentDocumentId;
    //   System.debug('CD id ' + conDocument);

    //   // attach.setFileName('Invoice.pdf');
    //   //attach.setBody(b);
    //   semail.setEntityAttachments(new List<Id>{ cv.Id });
    //   semail.setSubject('Account Details');
    //   if (mailList.size() > 0) {
    //     semail.setToAddresses(mailList);
    //   }

    //   if (!(String.isBlank(ccEmail))) {
    //     semail.setCcAddresses(new List<String>{ ccEmail });
    //   }
    //   semail.setBccAddresses(new List<String>{ bccEmail });

    //   semail.setPlainTextBody(stripHtmlBody);
    //   // semail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ attach });

    //   Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ semail });
    //   System.debug('Email Sent Successfully!');

    //   //============================================================================

    //   EmailMessage emailMessage = new EmailMessage();
    //   //emailMessage.status = '3';
    //   emailMessage.relatedToId = '0010m00000a4I2j';

    //   emailMessage.fromName = 'MR Accounting';
    //   emailMessage.subject = subject;
    //   emailMessage.CcAddress = 'paulawambui@yahoo.com';
    //   emailMessage.BccAddress = 'emailtosalesforce@r-293i2f270udi74o377e72fx4oekf8b5myp66ia5k8o8566qiwy.0m-a4x7eak.cs65.le.sandbox.salesforce.com';
    //   emailMessage.htmlBody = '<html><body><b>Testing tracking outbound email.</b></body></html>';

    //   String[] toIds = new List<String>{ '0030m00000aenXS' };
    //   emailMessage.toIds = toIds;

    //   emailMessage.toAddress = mail;
    //   insert emailMessage;
    //   String emId = emailMessage.Id;

    //   ContentDocumentLink cdLink = new ContentDocumentLink();
    //   cdLink.ContentDocumentId = conDocument;
    //   cdLink.LinkedEntityId = '0030m00000aenXS';
    //   // cdLink.Visibility = 'InternalUsers';
    //   cdLink.ShareType = 'V';
    //   insert cdLink;

    //   EmailMessageRelation emr = new EmailMessageRelation();
    //   emr.emailMessageId = emailMessage.id;
    //   emr.relationId = '0030m00000aenXS';
    //   emr.relationType = 'FromAddress';
    //   insert emr;

    //   EmailMessage insertedEmail = [
    //     SELECT status
    //     FROM EmailMessage
    //     WHERE Id = :emId
    //   ];
    //   insertedEmail.status = '3';

    //   update insertedEmail;
    // } catch (Exception ex) {
    //   sMessage =
    //     ex.getMessage() +
    //     '\n' +
    //     ex.getLineNumber() +
    //     '\n' +
    //     ex.getCause();
    //   System.debug('Error ' + sMessage);
    // }
    //return msg;
  }
}
