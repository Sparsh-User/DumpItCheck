/**
 * Business logic for the Project__c trigger.
 * All methods are bulk-safe: one query and one DML per call.
 */
public with sharing class ProjectTriggerHelper {

    private static final String STATUS_COMPLETED = 'Completed';
    private static final String STATUS_CANCELLED = 'Cancelled';
    private static final String STATUS_NOT_STARTED = 'Not Started';

    /**
     * Keeps Is_Active__c aligned with Status__c and defaults Progress__c.
     * @param projects Records from Trigger.new
     */
    public static void applyDefaults(List<Project__c> projects) {
        for (Project__c project : projects) {
            Boolean isClosed = project.Status__c == STATUS_COMPLETED
                || project.Status__c == STATUS_CANCELLED;
            project.Is_Active__c = !isClosed;
            if (project.Progress__c == null) {
                project.Progress__c = project.Status__c == STATUS_COMPLETED ? 100 : 0;
            }
        }
    }

    /**
     * A completed project cannot be moved back to Not Started.
     */
    public static void validateStatusTransitions(
        List<Project__c> projects,
        Map<Id, Project__c> oldProjects
    ) {
        for (Project__c project : projects) {
            Project__c oldProject = oldProjects.get(project.Id);
            if (oldProject.Status__c == STATUS_COMPLETED && project.Status__c == STATUS_NOT_STARTED) {
                project.Status__c.addError('A completed project cannot be reset to "Not Started".');
            }
        }
    }

    /**
     * When a project moves to Completed, close its remaining tasks.
     */
    public static void closeOpenTasksForCompletedProjects(
        List<Project__c> projects,
        Map<Id, Project__c> oldProjects
    ) {
        Set<Id> completedIds = new Set<Id>();
        for (Project__c project : projects) {
            if (project.Status__c == STATUS_COMPLETED
                && oldProjects.get(project.Id).Status__c != STATUS_COMPLETED) {
                completedIds.add(project.Id);
            }
        }
        if (completedIds.isEmpty()) {
            return;
        }
        List<Project_Task__c> tasks = [
            SELECT Id, Status__c
            FROM Project_Task__c
            WHERE Project__c IN :completedIds
            AND Status__c != :STATUS_COMPLETED
        ];
        for (Project_Task__c task : tasks) {
            task.Status__c = STATUS_COMPLETED;
        }
        update tasks;
    }
}
