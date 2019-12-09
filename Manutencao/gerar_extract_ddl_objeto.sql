--select dbms_metadata.get_ddl(object_type,name,schema=>null) from dual;
select dbms_metadata.get_ddl('OBJECT_TYPE','OBJECT_NAME') from dual;
