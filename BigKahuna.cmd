@setlocal enableextensions enabledelayedexpansion
@echo off

set path=%path%;C:\Program Files (x86)\Microsoft^ Visual Studio\2017\Professional\Common7\IDE
set bitbucket=C:\src\BitBucket


pushd .

:MyLoop
cls
taskkill /im msbuild.exe /f /t 2>NUL
del /q "%bitbucket%\NuGetFlat\*"
for /d %%x in ("%bitbucket%\NuGetFlat\*") do @rd /s /q "%%x"
DEL /F /Q /S "\\127.0.0.1\NuGetPackages\*"
del /q "\\127.0.0.1\NuGetPackages\*"
for /d %%x in ("\\127.0.0.1\NuGetPackages\*") do @rd /s /q "%%x"


IF %1.==. GOTO SkippDACPAC

cd  "%bitbucket%\deployments\Database"
set solution=Primordial.Database.sln
call:pull
call:compile
call "C:\src\github\pravinsable\batchfiles\DACPAC.cmd" 

:SkippDACPAC



cd "%bitbucket%\core"
set solution=Primordial.Core.projects.sln
call:pull
call:compile
cd "%bitbucket%\core\Primordial.Core\"
call:nuget



set solution=Primordial.Audit.sln
call:pull
call:compile


cd "%bitbucket%\common\Nuance.Primordial.Common"
set solution=Nuance.Primordial.Common.sln
call:pull
call:compile

cd "%bitbucket%\common\Nuance.Primordial.Common\Nuance.Primordial.Common\"
call:nuget

cd "%bitbucket%\core\Primordial.Components"
set solution=Primordial.Components.sln
call:pull
call:compile


cd "%bitbucket%\search\Primordial.Search"
set solution=Primordial.Search.sln
call:pull
call:compile


cd "%bitbucket%\core\Primordial.Components\Primordial.Documents.RtfConverter"
set solution=Primordial.Documents.Util.sln
call:pull
call:compile


cd "%bitbucket%\queryengine\QueryEngine"
set solution=Primordial.Worklists.QueryEngine.sln
call:pull
call:compile


cd "%bitbucket%\lcswebapp"
set solution=LungScreening.sln
git checkout -- LungScreening\Web.config
call:pull
sed -i "s/ServiceNode\" value=\"1/ServiceNode\" value=\"0/" LungScreening\Web.config
sed -i "s/Data Source=10.1.10.14;/Data Source=.;/i" LungScreening\Web.config


call:compile

cd "%bitbucket%\configmanager"
set solution=ConfigManager.sln
call:pull
call:compile

cd "%bitbucket%\empericus"
set solution=Primordial.HL7.Projects.sln
call:pull
call:compile


popd

taskkill /im msbuild.exe /f /t 2>NUL

pause
GOTO :MyLoop
:EndLoop


goto:eof

:compile
echo "%cd%\%solution%"
rem for /F  %%v in ('dir /S  /b *.csproj') do sed -i -e "s#HintPath>\(.*\)\\#HintPath>$(PRIMORDIAL_ALL_DLLS)\\Current\\$(Configuration)\\#g" %%v
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

:nuget
REM sed -i "s#http://vdiagnugetsrv/Nuance.Diag.NuGetServer/nuget#\\127.0.0.1\NuGetPackages#" %appdata%\NuGet\NuGet.Config 
sed -i "s/Configuration=Release/Configuration=Debug/i" "CreateNugetPackage.bat"
call "CreateNugetPackage.bat"
move "*.nupkg" "%bitbucket%\NuGetFlat"
nuget init "%bitbucket%\NuGetFlat" \\127.0.0.1\NuGetPackages
REM sed -i "s#\\127.0.0.1\NuGetPackages#http://vdiagnugetsrv/Nuance.Diag.NuGetServer/nuget#" %appdata%\NuGet\NuGet.Config 
goto:eof

