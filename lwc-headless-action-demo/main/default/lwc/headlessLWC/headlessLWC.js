import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { createRecord } from "lightning/uiRecordApi";

import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import PARENT_ID from "@salesforce/schema/Account.ParentId";

export default class HeadlessLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @api async invoke() {
        const fields = {};
        fields[PARENT_ID.fieldApiName] = this.recordId;
        fields[NAME_FIELD.fieldApiName] = "Child Account";
        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then((account) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "New Record",
                        message: "A new child account created",
                        variant: "success"
                    })
                );

                this.sleep(500).then(() => {
                    this.navigateToRecord(account.id);
                });
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error creating record",
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });
    }

    navigateToRecord(accountId) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: accountId,
                actionName: "view"
            }
        });
    }

    sleep(ms) {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        return new Promise((resolve) => setTimeout(resolve, ms));
    }
}
