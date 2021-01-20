import { createElement } from "lwc";
import SendEmailLWC from "c/sendEmailLWC";
//import getInvoiceDetails from '@salesforce/apex/GetInvoiceDetails.getInvoiceDetails';
import sendSingleEmailLWC from "@salesforce/apex/SendSingleVFEmail.sendSingleEmailLWC";

jest.mock(
  "@salesforce/apex/SendSingleVFEmail.sendSingleEmailLWC",
  () => {
    return {
      default: jest.fn()
    };
  },
  { virtual: true }
);

const DETAILS_DEFAULT = {
  Email: "test@test.com",
  InvoiceNumber: "090000",
  Contact: "test Contact"
};

const SUBJECT_DEFAULT =
  "Attn: " +
  DETAILS_DEFAULT.Contact +
  " for Invoice " +
  DETAILS_DEFAULT.InvoiceNumber;

//const REC_ID ='a2D0m000002PjcY';
//const APEX_PARAMETER = {accID : REC_ID};

const APEX_PARAMETERS = {
  contEmail: "toMail@testing.com",
  addTo: "testing@test.com",
  acc: "a2D0m000002PjcY",
  ccEmail: "testcc@test.com",
  subject: "Attn: Ramya for Invoice 000784",
  body: "Find attached invoice"
};

const SUCCESS_MSG = "Email Sent!";

describe("c-send-email-lwc", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
    jest.clearAllMocks();
  });

  function flushPromises() {
    /* eslint-disable-next-line no-undef */
    return new Promise((resolve) => setImmediate(resolve));
  }

  it("sends email with correct details", () => {
    //debugger;
    sendSingleEmailLWC.mockResolvedValue(SUCCESS_MSG);

    const element = createElement("c-send-email-lwc", {
      is: SendEmailLWC
    });
    document.body.appendChild(element);

    let emailEl = element.shadowRoot.querySelector(
      'lightning-textarea[class="toClass"]'
    );
    emailEl.value = DETAILS_DEFAULT.Email;

    let subjEl = element.shadowRoot.querySelector(
      'lightning-textarea[class="subjClass"]'
    );
    subjEl.value = SUBJECT_DEFAULT;

    emailEl.value = APEX_PARAMETERS.toEmail;
    emailEl.dispatchEvent(new CustomEvent("change"));

    const addToEl = element.shadowRoot.querySelector(
      'lightning-textarea[class="addToClass"]'
    );
    addToEl.value = APEX_PARAMETERS.addTo;
    addToEl.dispatchEvent(new CustomEvent("change"));

    const ccEl = element.shadowRoot.querySelector(
      'lightning-textarea[class="ccClass"]'
    );
    ccEl.value = APEX_PARAMETERS.ccEmail;
    ccEl.dispatchEvent(new CustomEvent("change"));

    subjEl = element.shadowRoot.querySelector(
      'lightning-textarea[class="subjClass"]'
    );
    subjEl.dispatchEvent(new CustomEvent("change"));

    const bodyEl = element.shadowRoot.querySelector(
      "lightning-input-rich-text"
    );
    bodyEl.value = APEX_PARAMETERS.body;
    bodyEl.dispatchEvent(new CustomEvent("change"));

    const sendBtnEl = element.shadowRoot.querySelector(
      'lightning-button[class="slds-m-left_x-sendBtn"]'
    );
    sendBtnEl.click();

    return flushPromises().then(() => {
      expect(sendSingleEmailLWC.mock.calls.length).toBe(1);

      // expect(sendSingleEmailLWC.mock.calls[0][0]).toEqual({
      //     params: APEX_PARAMETERS
      // });
    });
  });
});
