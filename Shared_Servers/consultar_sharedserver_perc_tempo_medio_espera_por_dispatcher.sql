select  network "Protocol",
        status "Status",
        sum(owned) "Clients",
        sum(busy)*100/(sum(busy)+sum(idle)) "Busy Rate"
FROM    v$dispatcher
GROUP BY network, status;