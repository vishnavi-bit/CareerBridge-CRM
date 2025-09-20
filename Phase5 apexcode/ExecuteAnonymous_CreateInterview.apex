Youth__c y = [SELECT Id FROM Youth__c WHERE Name = 'YID-0010' LIMIT 1];
Id youthId = y.Id;
System.debug('Youth Id: ' + youthId);

List<Job__c> matchedJobs = JobMatchingController.getMatchedJobs(youthId);
System.debug('Matched Jobs: ' + matchedJobs);

if (!matchedJobs.isEmpty()) {
    Id interviewId = JobMatchingController.createInterview(
        youthId, 
        matchedJobs[0].Id, 
        null, 
        UserInfo.getUserId()
    );
    System.debug('Interview Id: ' + interviewId);
} else {
    System.debug('No matched jobs found for this youth.');
}
