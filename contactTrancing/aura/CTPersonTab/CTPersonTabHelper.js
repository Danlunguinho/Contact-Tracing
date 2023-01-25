({
    fetchUserInformation: function (component) {
        const recordId = component.get("v.recordId");
        const action = component.get("c.getPersonDetails");
        action.setParams({
            recordId
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const resp = response.getReturnValue();
                //Checar se o usuario foi encontrado
                if (!resp || !resp.name) {
                    //Usuario não encontrado
                    component.set("v.userFound", false);
                    this.showToast("ERROR", "Please enter valid user id", "error");
                } else {
                    //Usuario encontrado
                    component.set("v.userFound", true);
                    component.set("v.userInfo", resp);
                }
            } else {
                component.set("v.userFound", false);
                this.showToast("ERROR", "Please enter valid user id", "error");
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
