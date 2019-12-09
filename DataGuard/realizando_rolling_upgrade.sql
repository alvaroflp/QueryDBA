-- 1: desabilitar a configuração do broker:
DGMGRL> DISABLE CONFIGURATION;

-- 2: Desabilitar processo do broker:
SQL> ALTER SYSTEM SET DG_BROKER_START=FALSE;

-- 3: Habilitar processo do broker:
SQL> ALTER SYSTEM SET DG_BROKER_START=TRUE;

-- 4: Habilitar a configuração do broker:
DGMGRL> ENABLE CONFIGURATION;


