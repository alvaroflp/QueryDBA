select      nam.ksppinm name, 
            val.KSPPSTVL, 
            nam.ksppdesc description
from        x$ksppi nam, x$ksppsv val
where       nam.indx = val.indx 
AND         nam.ksppinm = '_awr_restrict_mode'
order By    1