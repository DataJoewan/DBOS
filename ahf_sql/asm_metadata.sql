Rem
Rem $Header: tfa/src/v2/tfa_home/resources/sql/asm_metadata.sql /st_tfa_ahf23.10.0/1 2023/10/23 16:03:11 latrujil Exp $
Rem
Rem asm_metadata.sql
Rem
Rem Copyright (c) 2022, 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      asm_metadata.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: tfa/src/v2/tfa_home/resources/sql/asm_metadata.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    latrujil    10/20/23 - XbranchMerge latrujil_bug-35902008_main from main
Rem    latrujil    10/13/23 - BUG 35902008 - REPLACE V$ASM_DISKGROUP VIEW WITH
Rem                           _STAT VIEW
Rem    bvongray    09/21/22 - Created
Rem

@@?/rdbms/admin/sqlsessstart.sql

-----------------------------
--GENERIC ASM METADATA
-----------------------------

COLUMN ASMINST_NAME NOPRINT NEW_VALUE ASMINST_NAME
SELECT INSTANCE_NAME ASMINST_NAME FROM V$INSTANCE;
SPOOL &&ASMINST_NAME._ASM_METADATA_GENERIC.html
-- ASM VERSIONS 10.1, 10.2, 11.1, 11.2, 12.1 & 12.2
SET MARKUP HTML ON
SET ECHO ON
SET PAGESIZE 200

ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS';

SELECT 'THIS ASM REPORT WAS GENERATED AT: ==)> ' , SYSDATE " " FROM DUAL;
SELECT 'INSTANCE NAME: ==)> ' , INSTANCE_NAME " " FROM V$INSTANCE;

SELECT 'HOSTNAME ASSOCIATED WITH THIS ASM INSTANCE: ==)> ' , MACHINE " " FROM V$SESSION WHERE PROGRAM LIKE '%SMON%';

SELECT * FROM V$INSTANCE;

SELECT * FROM GV$INSTANCE;

SELECT * FROM V$ASM_DISKGROUP_STAT;

SELECT GROUP_NUMBER, DISK_NUMBER, MOUNT_STATUS, HEADER_STATUS, MODE_STATUS, STATE, OS_MB, TOTAL_MB, FREE_MB, NAME, FAILGROUP, PATH
FROM V$ASM_DISK ORDER BY GROUP_NUMBER, FAILGROUP, DISK_NUMBER;

SELECT * FROM V$ASM_DISK ORDER BY GROUP_NUMBER,DISK_NUMBER;

SELECT SUBSTR(D.NAME,1,16) AS ASMDISK, D.MOUNT_STATUS, D.STATE,
DG.NAME AS DISKGROUP FROM V$ASM_DISKGROUP_STAT DG, V$ASM_DISK D
WHERE DG.GROUP_NUMBER = D.GROUP_NUMBER;

SELECT * FROM V$ASM_CLIENT;

SELECT DG.NAME AS DISKGROUP, SUBSTR(C.INSTANCE_NAME,1,12) AS INSTANCE,
SUBSTR(C.DB_NAME,1,12) AS DBNAME, SUBSTR(C.SOFTWARE_VERSION,1,12) AS SOFTWARE,
SUBSTR(C.COMPATIBLE_VERSION,1,12) AS COMPATIBLE
FROM V$ASM_DISKGROUP_STAT DG, V$ASM_CLIENT C
WHERE DG.GROUP_NUMBER = C.GROUP_NUMBER;

--  Below only valid for 12.1 and above
SELECT * FROM X$KFDSD; 

SELECT "The following 3 queries are Applicable if DISKGROUP TYPE is EXTENDED or FLEX."  from dual;
SELECT * FROM V$ASM_QUOTAGROUP;
SELECT * FROM V$ASM_FILEGROUP;
SELECT * FROM V_ASM_FILEGROUP_PROPERTY;


SELECT * FROM V$ASM_ATTRIBUTE;

SELECT * FROM V$ASM_OPERATION;
SELECT * FROM GV$ASM_OPERATION;

SELECT * FROM V$VERSION;

SELECT * FROM V$ASM_ACFSSNAPSHOTS;
SELECT * FROM V$ASM_ACFSVOLUMES;
SELECT * FROM V$ASM_FILESYSTEM;
SELECT * FROM V$ASM_VOLUME;
SELECT * FROM V$ASM_VOLUME_STAT;

SELECT * FROM V$ASM_USER;
SELECT * FROM V$ASM_USERGROUP;
SELECT * FROM V$ASM_USERGROUP_MEMBER;

SELECT * FROM V$ASM_DISK_IOSTAT;
SELECT * FROM V$ASM_DISK_STAT;
SELECT * FROM V$ASM_DISKGROUP_STAT;

SELECT * FROM V$ASM_TEMPLATE;

SHOW PARAMETER

SHOW SGA

!echo "SELECT '" > /tmp/GPNPTOOL.SQL 2> /dev/null
! $ORACLE_HOME/bin/gpnptool get >> /tmp/GPNPTOOL.SQL 2>> /dev/null
!echo "' FROM DUAL;" >> /tmp/GPNPTOOL.SQL 2>> /dev/null
! cat /tmp/GPNPTOOL.SQL
SET ECHO OFF

--DISPLAYS INFORMATION ABOUT THE CONTENTS OF THE SPFILE.
SELECT * FROM V$SPPARAMETER ORDER BY 2;
SELECT * FROM GV$SPPARAMETER ORDER BY 3;

--DISPLAYS INFORMATION ABOUT THE INITIALIZATION PARAMETERS THAT ARE CURRENTLY IN EFFECT IN THE INSTANCE.
SELECT * FROM V$SYSTEM_PARAMETER ORDER BY 2;
SELECT * FROM GV$SYSTEM_PARAMETER ORDER BY 3;

-- 12C ACFS VIEWS

SELECT * FROM V$ASM_ACFS_ENCRYPTION_INFO;
SELECT * FROM V$ASM_ACFSREPL;
SELECT * FROM V$ASM_ACFSREPLTAG;
SELECT * FROM V$ASM_ACFS_SEC_ADMIN;
SELECT * FROM V$ASM_ACFS_SEC_CMDRULE;
SELECT * FROM V$ASM_ACFS_SEC_REALM;
SELECT * FROM V$ASM_ACFS_SEC_REALM_FILTER;
SELECT * FROM V$ASM_ACFS_SEC_REALM_GROUP;
SELECT * FROM V$ASM_ACFS_SEC_REALM_USER;
SELECT * FROM V$ASM_ACFS_SEC_RULE;
SELECT * FROM V$ASM_ACFS_SEC_RULESET;
SELECT * FROM V$ASM_ACFS_SEC_RULESET_RULE;
SELECT * FROM V$ASM_ACFS_SECURITY_INFO;
SELECT * FROM V$ASM_ACFSTAG;

-- 12C ASM AUDIT VIEWS

SELECT * FROM V$ASM_AUDIT_CLEAN_EVENTS;
SELECT * FROM V$ASM_AUDIT_CLEANUP_JOBS;
SELECT * FROM V$ASM_AUDIT_CONFIG_PARAMS;
SELECT * FROM V$ASM_AUDIT_LAST_ARCH_TS;

-- 12C ASM ESTIMATE VIEW

SELECT * FROM V$ASM_ESTIMATE;
SELECT * FROM GV$ASM_ESTIMATE;

-- SPARSE Diskgroups VIEW

SELECT * FROM V$ASM_DISK_SPARSE;
SELECT * FROM V$ASM_DISKGROUP_SPARSE;

SPOOL OFF

-----------------------------
--ASM Files & ASM Alias
-----------------------------
SPOOL &&ASMINST_NAME._ASM_METADATA_ALIAS_FILES..html
-- ASM VERSIONS 10.1, 10.2, 11.1, 11.2, 12.1 & 12.2
SET MARKUP HTML ON
set echo on

set pagesize 200

COLUMN BYTES FORMAT  9999999999999999

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';

select 'THIS ASM REPORT WAS GENERATED AT: ==)> ' , sysdate " "  from dual;


select 'HOSTNAME ASSOCIATED WITH THIS ASM INSTANCE: ==)> ' , MACHINE " " from v$session where program like '%SMON%';

select * from v$asm_alias;

select * from v$asm_file;

show parameter asm
show parameter cluster
show parameter instance_type
show parameter instance_name
show parameter spfile

show sga

spool off

-----------------------------
--ASM Full Path Alias Directory
-----------------------------
SPOOL &&ASMINST_NAME._ASM_METADATA_FULL_PATH_ALIAS_DIR.html
-- ASM VERSIONS 10.1, 10.2, 11.1, 11.2, 12.1 & 12.2
SET MARKUP HTML ON
set echo on

set pagesize 200

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';

select 'THIS ASM REPORT WAS GENERATED AT: ==)> ' , sysdate " "  from dual;


select 'HOSTNAME ASSOCIATED WITH THIS ASM INSTANCE: ==)> ' , MACHINE " " from v$session where program like '%SMON%';

SELECT CONCAT('+'||GNAME, SYS_CONNECT_BY_PATH(ANAME, '/'))
 FULL_PATH, SYSTEM_CREATED, ALIAS_DIRECTORY, FILE_TYPE
 FROM ( SELECT B.NAME GNAME, A.PARENT_INDEX PINDEX,
 A.NAME ANAME, A.REFERENCE_INDEX RINDEX,
 A.SYSTEM_CREATED, A.ALIAS_DIRECTORY,
 C.TYPE FILE_TYPE
 FROM V$ASM_ALIAS A, V$ASM_DISKGROUP_STAT B, V$ASM_FILE C
 WHERE A.GROUP_NUMBER = B.GROUP_NUMBER
 AND A.GROUP_NUMBER = C.GROUP_NUMBER(+)
 AND A.FILE_NUMBER = C.FILE_NUMBER(+)
 AND A.FILE_INCARNATION = C.INCARNATION(+)
 )
 START WITH (MOD(PINDEX, POWER(2, 24))) = 0
 CONNECT BY PRIOR RINDEX = PINDEX;


spool off


@?/rdbms/admin/sqlsessend.sql
exit
 
