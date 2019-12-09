BEGIN
	DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (    
             job_name => '"HR"."JOB_LIMPA_ARQUIVOS"', 
             recipients => 'fbifabio@gmail.com',
             sender => 'fbifabio@gmail.com',
             subject => '[arquivos de log limpados com sucesso] Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
             body => 'Job: %job_owner%.%job_name%.%job_subname%
                        Event: %event_type%
                        Date: %event_timestamp%
                        Log id: %log_id%
                        Job class: %job_class_name%
                        Run count: %run_count%
                        Failure count: %failure_count%
                        Retry count: %retry_count%
                        Error code: %error_code
                        %Error message: %error_message%',
             events => 'JOB_SUCCEEDED'
             );

END; 
