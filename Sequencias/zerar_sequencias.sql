BEGIN
    DECLARE plast_number number;
            pcycle_flag char(1);
            pmax_value NUMBER;
            psequence_name VARCHAR2(30);
            powner_name VARCHAR2(30);
            pstrSQL VARCHAR2(1000);
            pseq_number number;
    BEGIN
        BEGIN
            powner_name:=UPPER('&SCHEMA_NAME');
            psequence_name:=UPPER('&SEQUENCE_NAME');
            
            BEGIN
            --1) Testa sequência para ver se ela já foi inicializada, para evitar erro ORA-08002
            pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.CURRVAL FROM DUAL';
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL INTO pseq_number; 
            EXCEPTION
              WHEN OTHERS THEN
                -- Entra nesse erro quando sequence já estiver no valor limite
                IF INSTR(UPPER(SQLERRM(SQLCODE)),'ORA-08004') <> 0 THEN
                  -- nao faz nada, só trata erro para continuar processamento
                  NULL;
                ELSE
                    -- chama próximo valor da sequence:
                    pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.NEXTVAL FROM DUAL';
                    dbms_output.put_line(pstrSQL);
                    EXECUTE IMMEDIATE pstrSQL INTO pseq_number; 
                END IF;             
            END;
            
            --2 ) Verifica qual o último valor registrado na seqüência com a seguinte instrução.
            select  max_value, cycle_flag, last_number
            into    pmax_value, pcycle_flag, plast_number
            from    dba_sequences d
            where   d.sequence_owner = UPPER(powner_name)
            AND     d.sequence_name = UPPER(psequence_name);
            dbms_output.put_line('Valor atual da sequência: ' || (plast_number));
            
            --3) se número atual da sequence é maior que maxvalue entao iguala valores
            IF plast_number > pmax_value THEN
              pmax_value:= plast_number;
            END IF;
            
            --4) Altera o maxvalue para o mesmo valor encontrado no last_value no resultado da instrução acima.
            pstrSQL:='alter sequence ' || powner_name || '.' || psequence_name || ' minvalue 0 maxvalue ' || plast_number || ' cycle';
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL;
            
            --5) Executar o Nextval para zerar a seqüência.
            WHILE (pseq_number <> 0) LOOP
                pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.NEXTVAL FROM DUAL';
                dbms_output.put_line(pstrSQL);
                EXECUTE IMMEDIATE pstrSQL INTO pseq_number;        
            END LOOP;
            
            --6) Alterar novamente o maxvalue para o valor máximo anterior.
            IF pcycle_flag = 'N' THEN
                pstrSQL:='alter sequence  ' || powner_name || '.' || psequence_name || ' maxvalue ' || pmax_value || ' nocycle';
            ELSE
                pstrSQL:='alter sequence  ' || powner_name || '.' || psequence_name || ' maxvalue ' || pmax_value;
            END IF;
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL;    
            
            -- 7) Exibe valor atual da sequence após procedimento
            pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.CURRVAL FROM DUAL';
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL INTO pseq_number;      
            dbms_output.put_line('Procedimento executado com sucesso: O valor atual da sequence ' 
                || powner_name || '.' || psequence_name || ' é: ' || pseq_number);
            COMMIT;
        END;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Procedimento cancelado: O nome da sequência ' || powner_name || '.' || psequence_name || ' não existe.');
        WHEN OTHERS THEN
            IF INSTR(UPPER(SQLERRM(SQLCODE)),'ORA-08002') <> 0 OR 
                INSTR(UPPER(SQLERRM(SQLCODE)),'ORA-04004') <> 0 THEN
                dbms_output.put_line('Procedimento cancelado: Não é possível zerar a sequência ' || powner_name || '.' || psequence_name || ' não inicializada.');
            ELSE
                dbms_output.put_line('Erro ao zerar a sequência ' || powner_name || '.' || psequence_name || ': ' || SQLERRM);
            END IF;
    END;
END;
/