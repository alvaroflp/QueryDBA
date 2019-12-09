set serveroutput on
declare
   i number;
   j number;
   k number;
begin
   for i in 2..15 loop
       for j in 1..16 loop
           k:=i*16+j;
           dbms_output.put((to_char(k,'000'))||':'||chr(k)||'  ');
           if k mod 8 = 0 then
              dbms_output.put_line('');
           end if;
       end loop;
   end loop;
end;