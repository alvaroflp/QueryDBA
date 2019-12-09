select      name, 
            version, 
            detected_usages, 
            currently_used, 
            first_usage_date, 
            last_usage_date, 
            description
from        DBA_FEATURE_USAGE_STATISTICS  
where       detected_usages = 0 
order by    name, version;