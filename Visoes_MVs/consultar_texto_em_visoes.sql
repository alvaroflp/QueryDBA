-- cria tabela temporaria p/ armazenar lista de views e possibilitar pesquisa posterior em campo CLOB, pois no original LONG não é possível usar like
CREATE TABLE TMP_VIEWS_MIGRACAO (OWNER VARCHAR2(30), VIEW_NAME VARCHAR2(30), TEXT CLOB);

-- popula tabela temp c/ registros das views existentes
INSERT INTO TMP_VIEWS_MIGRACAO
SELECT OWNER, VIEW_NAME , TO_LOB(TEXT) FROM DBA_VIEWS;
COMMIT;

-- pesquisar views que contem uma determinada STRING
SELECT * FROM TMP_VIEWS_MIGRACAO WHERE UPPER(TEXT) LIKE '%&STRING_PESQUISA%' AND OWNER  NOT IN ('SYS');

-- Apos efetuar as pesquisas necessarias, apague a tabela temp
DROP TABLE TMP_VIEWS_MIGRACAO;