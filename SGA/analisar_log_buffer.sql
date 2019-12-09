 -- ver se log buffer está com tamanho adequado para boa performance
 -- "REDO BUFFER ALLOCATION RETRIES" mostra qtas X processos de usuário esperaram por espaço no redo log buffer
 -- "REDO LOG SPACE WAIT TIME" mostra tempo cumulativo (em 10s de milisegundos) esperado por todos os processos esperando por espaço no log buffer. Se este valor é baixo, o tamanho do log buffer size está adequado.
 SELECT     name, 
            value
 FROM       SYS.v_$sysstat
 WHERE      NAME in ('redo buffer allocation retries','redo log space wait time');