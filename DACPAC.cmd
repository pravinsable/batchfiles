@setlocal enableextensions enabledelayedexpansion
@echo off

set path=%path%;C:\Program Files (x86)\Microsoft^ Visual Studio\2017\Professional\Common7\IDE
set bitbucket=C:\src\BitBucket

taskkill /im msbuild.exe /f /t 2>NUL

pushd .

cd  "%bitbucket%\deployments\Database"
set solution=Primordial.Database.sln
call:pull
call:compile

del C:\src\BitBucket\installers\Nuance.Primordial.DBSetup\Nuance.Primordial.DBSetup\bin\Debug\DB\PrimordialAudit\DACPAC\*.dacpac
del C:\src\BitBucket\installers\Nuance.Primordial.DBSetup\Nuance.Primordial.DBSetup\bin\Debug\DB\Primordial\DACPAC\*.dacpac
del C:\src\BitBucket\installers\Nuance.Primordial.DBSetup\Nuance.Primordial.DBSetup\bin\Debug\DB\hl7ProcessingStats\DACPAC\*.dacpac

cd %~dp0
sqlcmd -S . -E -d master -i .\SQL\RecreateDB.sql 
sqlcmd -S . -E -d primordial -i .\SQL\SetupDB.sql 

cd  C:\src\BitBucket\installers\Nuance.Primordial.DBSetup\Nuance.Primordial.DBSetup\bin\Debug\DB\PrimordialAudit\DACPAC
copy C:\src\BitBucket\deployments\Database\Audit\HL7\bin\Debug\*.dacpac  .
"C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" /Action:Publish  /SourceFile:Audit.dacpac  /TargetDatabaseName:PrimordialAudit /TargetServerName:.  /Quiet:True

cd C:\src\BitBucket\installers\Nuance.Primordial.DBSetup\Nuance.Primordial.DBSetup\bin\Debug\DB\Primordial\DACPAC 
copy C:\src\BitBucket\deployments\Database\Primordial.Hl7\bin\Debug\*.dacpac  .
"C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" /Action:Publish  /SourceFile:Primordial.dacpac  /TargetDatabaseName:Primordial /TargetServerName:. /Quiet:True

cd C:\src\BitBucket\installers\Nuance.Primordial.DBSetup\Nuance.Primordial.DBSetup\bin\Debug\DB\hl7ProcessingStats\DACPAC
copy C:\src\BitBucket\deployments\Database\HL7ProcessingStats\HL7ProcessingStats\bin\Debug\*.dacpac .
"C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" /Action:Publish  /SourceFile:ProcessingStats.dacpac  /TargetDatabaseName:hl7ProcessingStats /TargetServerName:. /Quiet:True

cd %~dp0
sqlcmd -S . -E -d Primordial -i .\SQL\CustomMasterConfig.sql 
bcp "WITH XMLNAMESPACES ('http://www.w3.org/2001/XMLSchema' as xsd,'http://www.w3.org/2001/XMLSchema-instance' as xsi ) select * from [Primordial].[dbo].[CMSetting] FOR XML PATH('Setting'),  ROOT('ArrayOfSetting')"  queryout MASTERCONFIG_636540452687764232.xml  -S . -T -w -r
xmllint --format MASTERCONFIG_636540452687764232.xml > C:\PrimordialServer\ConfigManager\MASTERCONFIG_636540452687764232.xml
del MASTERCONFIG_636540452687764232.xml
sed -i "s/D:/C:/g" C:\PrimordialServer\ConfigManager\MASTERCONFIG_636540452687764232.xml

if not defined callFlag pause


goto:eof

:compile
echo "%cd%\%solution%"
echo Compiling %solution%
FOR /F "tokens=* USEBACKQ" %%F IN (` devenv.com  %solution% /rebuild ^| findstr failed`) DO ( SET result=%%F)
set result=%result:Please see the Output Window for details.=%
set success= succeeded, 0 failed,
if "x!result:%success%=!"=="x%result%" (
  echo [95m%result%[0m
) else (
  echo [92m%result%[0m
)
goto:eof

:pull
git checkout release/WO-Version1
git pull
REM FOR /F "tokens=* USEBACKQ" %%F IN (`git rev-parse --abbrev-ref HEAD`) DO ( SET branch=%%F)
REM git remote update origin  --prune
REM if not %branch%==master (
  REM git checkout master -q
  REM echo pulling from master branch
  REM git pull 
  REM git checkout %branch% -q
  REM echo pulling from %branch% branch
  REM git pull
REM ) else (
  REM echo pulling from %branch% branch
  REM git pull
REM )
goto:eof
