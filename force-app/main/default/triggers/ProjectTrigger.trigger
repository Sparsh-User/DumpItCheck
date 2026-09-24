trigger ProjectTrigger on Project__c (
    before insert, before update,
    after insert, after update, after delete, after undelete
) {
    if (!Bypass_Automations__c.getInstance().Bypass_Triggers__c) {
        new ProjectTriggerHandler().run();
    }
}
