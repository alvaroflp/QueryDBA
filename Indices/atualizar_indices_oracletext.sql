-- atualizar indice oracle text:
begin
    CTX_DDL.sync_index(idx_name => '&schema.&index_name', optlevel => 'FULL');
end;


-- atualizar todos os indices oracle text de um usuario especifico (nao precisa coletar estatisticas apos atualizacao)
begin
    FOR LINHA IN (SELECT  OWNER, INDEX_NAME 
                  FROM    DBA_INDEXES 
                  WHERE   OWNER = '&owner'
                  AND     INDEX_TYPE = 'DOMAIN')
    LOOP
        ctx_ddl.sync_index(LINHA.OWNER || '.' || LINHA.INDEX_NAME);
    END LOOP;    
end;
