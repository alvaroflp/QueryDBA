select ROUND(free_space / 1024 /1024,2) FREE_SPACE, ROUND(used_space / 1024 /1024,2) USED_SPACE, request_misses, request_failures 
from v$shared_pool_reserved;