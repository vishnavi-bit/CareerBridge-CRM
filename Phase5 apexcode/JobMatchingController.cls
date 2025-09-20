public class JobMatchingController {

    @AuraEnabled(cacheable=true)
    public static List<Job__c> getMatchedJobs(Id youthId) {
        if (youthId == null) return new List<Job__c>();
        
        // Collect Youth's Skills
        Set<Id> skillIds = new Set<Id>();
        for (YouthSkill__c ys : [SELECT Skill__c FROM YouthSkill__c WHERE Youth__c = :youthId]) {
            if (ys.Skill__c != null) skillIds.add(ys.Skill__c);
        }
        if (skillIds.isEmpty()) return new List<Job__c>();
        
        // Find Jobs that match Youth Skills
        Set<Id> jobIds = new Set<Id>();
        for (JobSkill__c js : [SELECT Job__c FROM JobSkill__c WHERE Skill__c IN :skillIds]) {
            if (js.Job__c != null) jobIds.add(js.Job__c);
        }
        if (jobIds.isEmpty()) return new List<Job__c>();
        
        // Return matched Jobs
        return [SELECT Id, Name, Location__c, Description__c, Required_Experience__c
                FROM Job__c
                WHERE Id IN :jobIds
                ORDER BY CreatedDate DESC
                LIMIT 100];
    }

    @AuraEnabled
    public static Id createInterview(Id youthId, Id jobId, String interviewDateIso, Id interviewerId) {
        Datetime dt = String.isBlank(interviewDateIso)
            ? Datetime.now().addDays(1)
            : Datetime.valueOf(interviewDateIso.replace('T',' ').replace('Z',''));
        
        Interview__c iv = new Interview__c(
            Candidate__c = youthId,
            Job__c = jobId,
            Interview_Date__c = dt,
            Interviewer__c = interviewerId,
            Status__c = 'Scheduled'
        );
        
        insert iv;
        return iv.Id;
    }
}
