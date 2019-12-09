-- este recurso chama-se FLASHBACK DROP e permite recuperar da recyclebin uma tabela que foi apagada:

-- a) recuperar tabela renomeando-a:
FLASHBACK TABLE SCHEMA.TABELA TO BEFORE DROP rename to SCHEMA.NOVO_NOME_TABELA;

-- b) recuperar tabela 
FLASHBACK TABLE SCHEMA.TABELA TO BEFORE DROP;
