-- conectado como DBA conceda acesso ao usuario USER_A para se conectar via proxy (personificação) como usuário USER_B. Substitua USER_A e USER_B pelos nomes dos usuarios desejados:
alter user USER_A GRANT CONNECT THROUGH USER_B;

-- conecte-se como USER_A personificando o USER_B. Substitua senha_usuario pela senha do USER_A:
conn USER_A[USER_B]/senha_usuario
