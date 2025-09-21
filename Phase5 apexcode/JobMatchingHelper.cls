public class JobMatchingHelper {

    public static void processYouthSkills(Id youthId, List<Messaging.SingleEmailMessage> emailsToSend, List<Interview__c> interviewsToCreate){
        // Get Youth Skills
        Set<Id> youthSkillIds = new Set<Id>();
        for(YouthSkill__c ys : [SELECT Skill__c FROM YouthSkill__c WHERE Youth__c = :youthId]){
            if(ys.Skill__c != null) youthSkillIds.add(ys.Skill__c);
        }
        if(youthSkillIds.isEmpty()) return;

        // Find matching jobs
        Map<Id, Job__c> matchedJobs = new Map<Id, Job__c>();
        for(JobSkill__c js : [SELECT Job__c, Job__r.Name FROM JobSkill__c WHERE Skill__c IN :youthSkillIds]){
            matchedJobs.put(js.Job__c, js.Job__r);
        }
        if(matchedJobs.isEmpty()) return;

        // Create Interview & send email
        for(Job__c job : matchedJobs.values()){
            Interview__c iv = new Interview__c(
                Candidate__c = youthId,
                Job__c = job.Id,
                Interview_Date__c = System.now().addDays(1),
                Status__c = 'Scheduled'
            );
            interviewsToCreate.add(iv);

            Messaging.SingleEmailMessage matchMail = new Messaging.SingleEmailMessage();
            matchMail.setToAddresses(new String[] { [SELECT Email__c FROM Youth__c WHERE Id = :youthId].Email__c });
            matchMail.setSubject('Interview Scheduled for ' + job.Name);
            matchMail.setPlainTextBody(
                'Hello ' + [SELECT Name FROM Youth__c WHERE Id = :youthId].Name + ',\n\n' +
                'Congratulations! You have been shortlisted for the ' + job.Name + ' position.\n' +
                'Your interview is scheduled on ' + iv.Interview_Date__c.format('dd/MM/yyyy hh:mm a') + '.\n\n' +
                'Best regards,\nCareerBridge Team'
            );
            emailsToSend.add(matchMail);
        }
    }
}
