import { LightningElement, api, track, wire } from "lwc";
import getPaymentsToInvoice from "@salesforce/apex/PaymentsToInvoicesController.getPaymentsToInvoice";
import applyPaymentToInvoice from "@salesforce/apex/PaymentsToInvoicesController.applyPaymentToInvoice";

const actions = [{ label: "Apply Payment", name: "apply_Payment" }];

export default class ApplyPaymentLWC extends LightningElement {
  @api recordId;
  @api accountId;
  @track sortedBy;
  @track sortedDirection;
  @track invoices;
  @track error;

  @track columns = [
    { label: "Contact", fieldName: "contactName", sortable: true },
    { label: "Invoice Number", fieldName: "invoice", sortable: true },
    {
      label: "Invoice Date",
      fieldName: "invoiceDate",
      type: "date",
      sortable: true
    },
    {
      label: "Outstanding Balance",
      fieldName: "balance",
      type: "currency",
      sortable: true,
      cellAttributes: { alignment: "left" }
    },
    {
      type: "action",
      typeAttributes: { rowActions: actions, menuAlignment: "auto" }
    }
  ];

  @wire(getPaymentsToInvoice, { accID: "$accountId" })
  wiredInvoices({ error, data }) {
    if (data) {
      this.invoices = data;

      // console.log('Invoices returned '+ JSON.stringify(this.invoices));
      this.error = undefined;
    } else if (error) {
      this.invoices = undefined;
      this.error = error;
      console.log("Error " + error.body.message);
    }
  }

  updateColumnSorting(event) {
    this.sortedBy = event.detail.fieldName;
    this.sortedDirection = event.detail.sortDirection;
    this.sortData(this.sortedBy, this.sortedDirection);
  }

  sortData(fieldname, direction) {
    // serialize the data before calling sort function
    let parseData = JSON.parse(JSON.stringify(this.invoices));

    // Return the value stored in the field
    let keyValue = (a) => {
      return a[fieldname];
    };

    // checking reverse direction
    let isReverse = direction === "asc" ? 1 : -1;

    // sorting data
    parseData.sort((x, y) => {
      x = keyValue(x) ? keyValue(x) : ""; // handling null values
      y = keyValue(y) ? keyValue(y) : "";

      // sorting values based on direction
      return isReverse * ((x > y) - (y > x));
    });

    // set the sorted data to data table data
    this.invoices = parseData;
  }

  handleRowAction(event) {
    const row = event.detail.row;
    let selectedInvoice = row.invoice;
    console.log("Selected invoice " + selectedInvoice);

    this.requestApplyPayments(selectedInvoice);
  }

  requestApplyPayments(selInvoice) {
    let req = { paymentID: this.recordId, invoiceNumber: selInvoice };

    console.log(req);

    applyPaymentToInvoice({ paymentWrapper: req })
      .then(() => {
        console.log("Sent Successfully");
        window.location.assign("/" + this.recordId);
      })
      .catch((error) => {
        console.log("Error occured:- " + error.body.message);
      });
  }
}
