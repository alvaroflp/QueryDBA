-- verificar sessoes bloqueadas, evento que causou o bloqueio e qto tempo ja durou o bloqueio
select  sid, 
        serial#,
        status,
        username,
        osuser,
        program,
        blocking_session blocking,
        event,
        seconds_in_wait
from    v$session
where   blocking_session is not null;


-- ver na consulta acima retornar algum resultado, execute a consulta abaixo para verificar quais objetos estao bloqueados (ver linha 'Sessions begin blocked')
SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.enable (1000000);
  
  FOR linha IN (  SELECT      a.session_id,
                              s.username,
                              a.object_id,
                              xidsqn,
                              oracle_username,
                              b.owner owner,
                              b.object_name object_name,
                              b.object_type object_type
                    FROM      v$locked_object a
                    JOIN      dba_objects b
                      ON      b.object_id = a.object_id
                    JOIN      v$session s
                      on      s.sid = a.session_id
                    WHERE     xidsqn != 0
                  )
    LOOP
        DBMS_OUTPUT.put_line ('.');
        DBMS_OUTPUT.put_line ('Blocking Session   : ' || linha.session_id);
        DBMS_OUTPUT.put_line ('Blocking Username  : ' || linha.username);
        DBMS_OUTPUT.put_line ('Object (Owner/Name): ' || linha.owner || '.' || linha.object_name); 
        DBMS_OUTPUT.put_line ('Object Type        : ' || linha.object_type);
      
        FOR next_loop  IN (SELECT   sid
                           FROM     v$lock
                           WHERE    id2 = linha.xidsqn
                           AND      sid != linha.session_id
                            )
        LOOP
            DBMS_OUTPUT.put_line('Sessions being blocked   :  ' || next_loop.sid);
        END LOOP;
    END LOOP;
END;
/

-- Leia mais: http://eduardolegatti.blogspot.com/2015/05/detectando-sessoes-bloqueadoras-e.html