set linesize 200
set head off
set feedback off
spool /tmp/scripts/drop_objects.sql;
SELECT 'DROP ' || OBJECT_TYPE || ' ' || OBJECT_NAME ||';'   FROM USER_OBJECTS
WHERE OBJECT_TYPE <> 'TABLE' AND OBJECT_TYPE <> 'INDEX' AND OBJECT_TYPE<>'LOB'  
UNION ALL 
SELECT 'DROP ' || OBJECT_TYPE || ' ' || OBJECT_NAME ||' CASCADE CONSTRAINTS;'   FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'TABLE';
spool off;
exit;