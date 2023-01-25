({
    fetchLocationInformation: function (component, event, helper) {
        const recordId = component.get("v.recordId");
        const action = component.get("c.getLocationDetails");
        action.setParams({
            recordId
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const resp = response.getReturnValue();
                //Checar se a localização foi encontrada
                if (!resp || !resp.name) {
                    //localização não encontrada
                    component.set("v.locationFound", false);
                    this.showToast("ERROR", "Please enter valid location id", "error");
                } else {
                    //localização foi encontrada
                    component.set("v.locationFound", true);
                    component.set("v.locationInfo", resp);
                }
            } else {
                component.set("v.locationFound", false);
                this.showToast("ERROR", "Please enter valid location id", "error");
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (title, message, type) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title,
            message,
            type
        });
        toastEvent.fire();
    }
});
