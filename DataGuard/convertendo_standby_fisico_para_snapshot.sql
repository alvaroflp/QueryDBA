--1: Verifique se o bd standby esta c/ flashback database habilitado (a consulta abaixo dever� retornar YES). Prossiga nos passos seguintes somente se Flashback Database estiver habilitado:
select flashback_on from v$database;

--2: Converta o Bd standby fisico p/ snapshot standby:
DGMGRL> convert database standby_name to snapshot standby;

--3: consulte o papel do BD em seguida e veja se retorna o valor "SNAPSHOT STANDBY":
SQL>  SELECT database_role FROM v$database;
-- ou 
DGMGRL> SHOW CONFIGURATION;

--4: Fa�a seus testes e/ou altera��es

--5: Volte o Bd p/ physical standby:
DGMGRL> convert database standby_name to physical standby;



