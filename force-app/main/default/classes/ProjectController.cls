public with sharing class ProjectController {

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectsForAccount(Id accountId) {
        return [
            SELECT Id, Name, Status__c, Budget__c, Progress__c, Start_Date__c, End_Date__c
            FROM Project__c
            WHERE Account__c = :accountId
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }

    @AuraEnabled
    public static void updateProgress(Id projectId, Decimal progress) {
        if (progress < 0 || progress > 100) {
            throw new AuraHandledException('Progress must be between 0 and 100.');
        }
        update new Project__c(Id = projectId, Progress__c = progress);
    }
}
