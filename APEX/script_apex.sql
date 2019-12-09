-- verificar o status da instalacaoo do APEX
SELECT  STATUS 
FROM    DBA_REGISTRY
WHERE   COMP_ID = 'APEX';

-- verificar a versao do APEX
SELECT * FROM apex_release;

-- verificar todas as versoes do APEX instaladas
SELECT  VERSION 
FROM    DBA_REGISTRY 
WHERE   COMP_NAME = 'Oracle Application Express';