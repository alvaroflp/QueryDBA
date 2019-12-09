Select name, value from v$sysstat
where name in ('sorts (memory)', 'sorts (disk)');