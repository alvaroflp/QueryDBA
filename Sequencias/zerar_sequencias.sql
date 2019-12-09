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
            --1) Testa sequ�ncia para ver se ela j� foi inicializada, para evitar erro ORA-08002
            pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.CURRVAL FROM DUAL';
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL INTO pseq_number; 
            EXCEPTION
              WHEN OTHERS THEN
                -- Entra nesse erro quando sequence j� estiver no valor limite
                IF INSTR(UPPER(SQLERRM(SQLCODE)),'ORA-08004') <> 0 THEN
                  -- nao faz nada, s� trata erro para continuar processamento
                  NULL;
                ELSE
                    -- chama pr�ximo valor da sequence:
                    pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.NEXTVAL FROM DUAL';
                    dbms_output.put_line(pstrSQL);
                    EXECUTE IMMEDIATE pstrSQL INTO pseq_number; 
                END IF;             
            END;
            
            --2 ) Verifica qual o �ltimo valor registrado na seq��ncia com a seguinte instru��o.
            select  max_value, cycle_flag, last_number
            into    pmax_value, pcycle_flag, plast_number
            from    dba_sequences d
            where   d.sequence_owner = UPPER(powner_name)
            AND     d.sequence_name = UPPER(psequence_name);
            dbms_output.put_line('Valor atual da sequ�ncia: ' || (plast_number));
            
            --3) se n�mero atual da sequence � maior que maxvalue entao iguala valores
            IF plast_number > pmax_value THEN
              pmax_value:= plast_number;
            END IF;
            
            --4) Altera o maxvalue para o mesmo valor encontrado no last_value no resultado da instru��o acima.
            pstrSQL:='alter sequence ' || powner_name || '.' || psequence_name || ' minvalue 0 maxvalue ' || plast_number || ' cycle';
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL;
            
            --5) Executar o Nextval para zerar a seq��ncia.
            WHILE (pseq_number <> 0) LOOP
                pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.NEXTVAL FROM DUAL';
                dbms_output.put_line(pstrSQL);
                EXECUTE IMMEDIATE pstrSQL INTO pseq_number;        
            END LOOP;
            
            --6) Alterar novamente o maxvalue para o valor m�ximo anterior.
            IF pcycle_flag = 'N' THEN
                pstrSQL:='alter sequence  ' || powner_name || '.' || psequence_name || ' maxvalue ' || pmax_value || ' nocycle';
            ELSE
                pstrSQL:='alter sequence  ' || powner_name || '.' || psequence_name || ' maxvalue ' || pmax_value;
            END IF;
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL;    
            
            -- 7) Exibe valor atual da sequence ap�s procedimento
            pstrSQL:='SELECT ' || powner_name || '.' || psequence_name || '.CURRVAL FROM DUAL';
            dbms_output.put_line(pstrSQL);
            EXECUTE IMMEDIATE pstrSQL INTO pseq_number;      
            dbms_output.put_line('Procedimento executado com sucesso: O valor atual da sequence ' 
                || powner_name || '.' || psequence_name || ' �: ' || pseq_number);
            COMMIT;
        END;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Procedimento cancelado: O nome da sequ�ncia ' || powner_name || '.' || psequence_name || ' n�o existe.');
        WHEN OTHERS THEN
            IF INSTR(UPPER(SQLERRM(SQLCODE)),'ORA-08002') <> 0 OR 
                INSTR(UPPER(SQLERRM(SQLCODE)),'ORA-04004') <> 0 THEN
                dbms_output.put_line('Procedimento cancelado: N�o � poss�vel zerar a sequ�ncia ' || powner_name || '.' || psequence_name || ' n�o inicializada.');
            ELSE
                dbms_output.put_line('Erro ao zerar a sequ�ncia ' || powner_name || '.' || psequence_name || ': ' || SQLERRM);
            END IF;
    END;
END;
/