# Instructions.

To use this directory with SQLPlus on Windows, set the following environment variables:

set TNS_ADMIN=C:\Users\<username>\.oracle
set SQLPATH=C:\Users\<username>\.oracle

Note that if you're using sqlplus as it comes with either instantclient or oracle database 12r2, you *will* need oracle patch 25804573 (SQL PLUS 12.2 NOT OBSERVING SQLPATH IN REGISTRY OR ENV VARIABLE FOR LOGIN.SQL).

To use this directory with SQLPlus on Unix or Linux or MacOS, set the following environment variables:

export TNS_ADMIN=/Users/rubin/.oracle
export ORACLE_PATH=/Users/rubin/.oracle
export SQLPATH=/Users/rubin/.oracle

Additionally, it is recommended to install rlwrap and alias rlsqlplus='rlwrap sqlplus' which will give you command history.
