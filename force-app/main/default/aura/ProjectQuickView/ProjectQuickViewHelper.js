({
    load: function (component) {
        var action = component.get("c.getProjectsForAccount");
        action.setParams({ accountId: component.get("v.recordId") });
        $A.enqueueAction(action);
    }
})
