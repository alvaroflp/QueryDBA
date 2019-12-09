select    name, 
          round(bytes/1024/1024,2) as mbytes, 
          resizeable 
from      v$sgainfo;