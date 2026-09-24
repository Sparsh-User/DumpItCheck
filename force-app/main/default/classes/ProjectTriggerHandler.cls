/**
 * Trigger handler for Project__c. Routing only; logic lives in the helper.
 */
public with sharing class ProjectTriggerHandler extends TriggerHandler {

    public override void beforeInsert() {
        ProjectTriggerHelper.applyDefaults((List<Project__c>) Trigger.new);
    }

    public override void beforeUpdate() {
        ProjectTriggerHelper.applyDefaults((List<Project__c>) Trigger.new);
        ProjectTriggerHelper.validateStatusTransitions(
            (List<Project__c>) Trigger.new,
            (Map<Id, Project__c>) Trigger.oldMap
        );
    }

    public override void afterUpdate() {
        ProjectTriggerHelper.closeOpenTasksForCompletedProjects(
            (List<Project__c>) Trigger.new,
            (Map<Id, Project__c>) Trigger.oldMap
        );
    }
}
