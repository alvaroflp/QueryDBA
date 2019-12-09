select name latch, gets, misses, 100 - round( misses*100/decode(gets,0,1,gets), 2 ) eficiencia, sleeps
from v$latch
where gets > 0 and 100 - round( misses*100/decode(gets,0,1,gets), 2 ) < 100
order by eficiencia;