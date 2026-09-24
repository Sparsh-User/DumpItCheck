public with sharing class ProjectStatusInvocable {

    public class Request {
        @InvocableVariable(label='Project Id' required=true)
        public Id projectId;
        @InvocableVariable(label='New Status' required=true)
        public String status;
    }

    public class Result {
        @InvocableVariable public Boolean isSuccess;
        @InvocableVariable public String message;
    }

    @InvocableMethod(label='Update Project Status' category='Projects')
    public static List<Result> updateStatus(List<Request> requests) {
        List<Project__c> updates = new List<Project__c>();
        for (Request req : requests) {
            updates.add(new Project__c(Id = req.projectId, Status__c = req.status));
        }
        List<Result> results = new List<Result>();
        for (Database.SaveResult sr : Database.update(updates, false)) {
            Result res = new Result();
            res.isSuccess = sr.isSuccess();
            res.message = sr.isSuccess() ? 'OK' : sr.getErrors()[0].getMessage();
            results.add(res);
        }
        return results;
    }
}
