BEGIN

  -- Only uncomment the following line if ACL "network_services.xml" has already been created
  --DBMS_NETWORK_ACL_ADMIN.DROP_ACL('network_services.xml');

  /*DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl => 'network_services.xml',
    description => 'FTP ACL',
    principal => 'ADMACESSO',
    is_grant => true,
    privilege => 'connect');
*/

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    ACL => 'network_services.xml',
    principal => '&&USER',
    is_grant => true,
    privilege => 'resolve');
    
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl => 'network_services.xml',
    principal => '&&USER',
    IS_GRANT => TRUE,
    privilege => 'connect');

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
    acl => 'network_services.xml',
    host => '*');

  COMMIT;

END;

UNDEFINE USER;
