/*  Copyright (c) 2012, Ruby Willow, Inc.
    All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice, this list of
  conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  Neither the name of Ruby Willow, Inc. nor the names of its contributors may be used to
  endorse or promote products derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
  OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

-- this script should probably be run as SYSDBA, or at least a DBA
-- with the appropriate privileges to grant/drop/create, etc.

-- preamble that sets SQL*Plus the way this script expects it
whenever oserror exit
whenever sqlerror exit sql.sqlcode
SET APPINFO pljson_install
SET ARRAYSIZE 250
SET DEFINE '^'
set linesize 32767
set long 2000000000
set longchunksize 8192
set pagesize 50000
set serveroutput on
set timing on
set trimout on
set trimspool on
set verify off
set numwidth 14

begin
  execute immediate q'[ALTER SESSION SET NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS']';
  execute immediate q'[ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYY/MM/DD HH24:MI:SS.FF4']';
  execute immediate q'[ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT='YYYY/MM/DD HH24:MI:SS.FF4 TZH:TZM']';
  execute immediate q'[ALTER SESSION SET TIMED_STATISTICS=TRUE]';
  execute immediate q'[ALTER SESSION SET STATISTICS_LEVEL=ALL]';
end;
/

-- end preamble
/*
declare
  cnt integer;
begin

  select count(*)
    into cnt
    from dba_users
    where username = 'PLJSON';

  if cnt > 0 then
    execute immediate 'drop user PLJSON cascade';
  end if;

end;
/

create user PLJSON identified by PLJSON
/

-- this is just so that loadjava can work
-- this user cannot connect or has no other privileges
grant unlimited tablespace to PLJSON
/

*/

alter session set current_schema=PLJSON
/

@PLJSON.types.sql
@PLJSON.package.sql
@PLJSON.pkgbody.sql
@PLJSON.typbodies.sql

grant execute on PLJSON.pljsonElement to public;
grant execute on PLJSON.pljsonNull to public;
grant execute on PLJSON.pljsonObjectEntry to public;
grant execute on PLJSON.pljsonObjectEntries to public;
grant execute on PLJSON.pljsonObject to public;
grant execute on PLJSON.pljsonElements to public;
grant execute on PLJSON.pljsonArray to public;
grant execute on PLJSON.pljsonPrimitive to public;
grant execute on PLJSON.pljsonString to public;
grant execute on PLJSON.pljsonNumber to public;
grant execute on PLJSON.pljsonBoolean to public;
grant execute on PLJSON.pljson to public;


create or replace public synonym pljsonElement       for PLJSON.pljsonElement;
create or replace public synonym pljsonNull          for PLJSON.pljsonNull;
create or replace public synonym pljsonObjectEntry   for PLJSON.pljsonObjectEntry;
create or replace public synonym pljsonObjectEntries for PLJSON.pljsonObjectEntries;
create or replace public synonym pljsonObject        for PLJSON.pljsonObject;
create or replace public synonym pljsonElements      for PLJSON.pljsonElements;
create or replace public synonym pljsonArray         for PLJSON.pljsonArray;
create or replace public synonym pljsonPrimitive     for PLJSON.pljsonPrimitive;
create or replace public synonym pljsonString        for PLJSON.pljsonString;
create or replace public synonym pljsonNumber        for PLJSON.pljsonNumber;
create or replace public synonym pljsonBoolean       for PLJSON.pljsonBoolean;
create or replace public synonym pljson              for PLJSON.pljson;

/*

now run loadjava on the server:

loadjava -schema PLJSON -resolve -user "sys/*** as sysdba" -verbose gson-2.2.2.jar pljson.jar

Note the two .jar files must be located on the server unless you
happen to have the loadjava program on your computer.

*/

exit
