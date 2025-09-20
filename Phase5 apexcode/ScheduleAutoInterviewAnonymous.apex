AutoInterviewScheduler scheduler = new AutoInterviewScheduler();
String jobName = 'AutoInterviewSchedulerJob';
String cronExp = '0 0 10 * * ?';
System.schedule(jobName, cronExp, scheduler);
System.debug('AutoInterviewScheduler scheduled successfully.');
