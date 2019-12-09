-- apagar job somente do usuario logado 
begin    
    DBMS_JOB.REMOVE(&NUMERO_JOB);
end;

-- apagar job de outro usuario
begin
  dbms_ijob.remove(&NUMERO_JOB);
end;