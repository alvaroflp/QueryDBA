-- rebuild de 1 indice oracle text:
begin
    CTX_DDL.OPTIMIZE_INDEX(idx_name => '&schema.&index_name', optlevel => 'FULL');
end;


-- para fazer rebuild todos os indices oracle text de um usuario (nao precisa coletar estatisticas apos atualizacao)
begin
    FOR LINHA IN (SELECT  OWNER, INDEX_NAME 
                  FROM    DBA_INDEXES 
                  WHERE   OWNER = '&owner'
                  AND     INDEX_TYPE = 'DOMAIN')
    LOOP
        ctx_ddl.OPTIMIZE_INDEX(LINHA.OWNER || '.' || LINHA.INDEX_NAME);
    END LOOP;    
end;
