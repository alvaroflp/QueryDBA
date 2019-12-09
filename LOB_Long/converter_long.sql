create table old_long_table(c1 number, c2 long);
insert into  old_long_table values (1, 'LONG data to convert to CLOB');

create table new_lob_table(c1 number, c2 clob);

-- Use TO_LOB function to convert LONG to LOB...
insert into  new_lob_table
       select c1, to_lob(c2) from old_long_table;
