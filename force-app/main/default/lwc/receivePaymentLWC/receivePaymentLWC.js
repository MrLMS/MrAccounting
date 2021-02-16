import { LightningElement, api, track } from "lwc";

export default class ReceivePaymentLWC extends LightningElement {
  @api selectedValue;
  @track recordId;
  paymentId;
  visible = false;

  handleSave() {
    this.template
      .querySelector("lightning-record-edit-form")
      .submit(this.fields);
    console.log("Saved record successfully!");
    console.log("selected record type " + this.selectedValue);
    this.visible = true;
  }
  handleReset() {
    const inputFields = this.template.querySelectorAll("lightning-input-field");
    if (inputFields) {
      inputFields.forEach((field) => {
        field.reset();
      });
    }
  }
  handleNavigate() {
    console.log("called " + this.paymentId);
    window.location.assign("/" + this.paymentId);
  }

  handleSuccess(event) {
    console.log("handle success ");
    this.handleNavigate();
    this.paymentId = event.detail.id;
    //this.handleNavigate();
  }

  handleCancel() {
    window.location.assign("/");
    //window.location.assign("/" + this.paymentId);
  }
}
