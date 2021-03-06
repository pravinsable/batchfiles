@setlocal enableextensions enabledelayedexpansion
@echo off

set path=%path%;C:\Program Files (x86)\Microsoft^ Visual Studio\2017\Professional\Common7\IDE
set bitbucket=C:\src\BitBucket

taskkill /im msbuild.exe /f /t 2>NUL

pushd .

:MyLoop
cls


cd "%bitbucket%\lcswebapp"
set solution=LungScreening.sln
git checkout -- LungScreening\Web.config
call:pull
sed -i "s/ServiceNode\" value=\"1/ServiceNode\" value=\"0/" LungScreening\Web.config
sed -i "s/Data Source=10.1.10.14;/Data Source=.;/i" LungScreening\Web.config
call:compile


popd

taskkill /im msbuild.exe /f /t 2>NUL

pause
GOTO :MyLoop
:EndLoop


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
FOR /F "tokens=* USEBACKQ" %%F IN (`git rev-parse --abbrev-ref HEAD`) DO ( SET branch=%%F)
git remote update origin  --prune
if not %branch%==master (
  git checkout master -q
  echo pulling from master branch
  git pull 
  git checkout %branch% -q
  echo pulling from %branch% branch
  git pull
) else (
  echo pulling from %branch% branch
  git pull
)
goto:eof
