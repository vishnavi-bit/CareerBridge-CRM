
@isTest
private class JobMatchingControllerTest1 {

    @isTest static void testMatchingAndInterviewCreation() {
        // Create Skills
        Skill__c skHtml = new Skill__c(Name='html');
        Skill__c skPython = new Skill__c(Name='python');
        insert new List<Skill__c>{skHtml, skPython};

        // Create Youth
        Youth__c y = new Youth__c(
            Location__c='Hyderabad', 
            Email__c='vishnavi709@gmail.com', 
            Qualification__c='B.tech', 
            Preferred_Role__c='Sales'
        );
        insert y;

        // Link Youth and Skills
        YouthSkill__c ysHtml = new YouthSkill__c(Youth__c=y.Id, Skill__c=skHtml.Id);
        YouthSkill__c ysPython = new YouthSkill__c(Youth__c=y.Id, Skill__c=skPython.Id);
        insert new List<YouthSkill__c>{ysHtml, ysPython};

        // Create Jobs
        Job__c jobDev = new Job__c(Name='Developer', Location__c='Hyderabad', Description__c='Developer role', Status__c='Open');
        Job__c jobDesigner = new Job__c(Name='Designer', Location__c='Bangalore', Description__c='Designer role', Status__c='Open');
        insert new List<Job__c>{jobDev, jobDesigner};

        // Link Jobs and Skills
        JobSkill__c jsDevHtml = new JobSkill__c(Job__c=jobDev.Id, Skill__c=skHtml.Id);
        JobSkill__c jsDesignerPython = new JobSkill__c(Job__c=jobDesigner.Id, Skill__c=skPython.Id);
        insert new List<JobSkill__c>{jsDevHtml, jsDesignerPython};

        // Test Controller
        Test.startTest();
        List<Job__c> matched = JobMatchingController.getMatchedJobs(y.Id);
        System.assertEquals(2, matched.size(), 'Youth should match 2 jobs');

        String isoDate = Datetime.now().addDays(2).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        Id interviewId = JobMatchingController.createInterview(y.Id, jobDev.Id, isoDate, UserInfo.getUserId());
        System.assertNotEquals(null, interviewId, 'Interview Id should not be null');
        Test.stopTest();
    }
}
