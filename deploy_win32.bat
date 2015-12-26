@echo off

echo Compiling...
qmake presi-aoke.pro
IF ERRORLEVEL ==1 GOTO :ERROR
mingw32-make.exe release
IF ERRORLEVEL ==1 GOTO :ERROR

echo Copying files to staging
del /Q /S .\staging
mkdir .\staging
copy .\release\presi-aoke.exe .\staging

echo Copying qt libraries to staging
windeployqt.exe .\staging\presi-aoke.exe -no-translations -no-system-d3d-compiler -no-webkit -no-webkit2 -no-opengl -no-svg
rem Trim a bunch of plugins that we don't use
del /Q /S .\staging\iconengines
erase .\staging\imageformats\qdds*.dll .\staging\imageformats\qicns*.dll .\staging\imageformats\qico*.dll .\staging\imageformats\qjp2*.dll .\staging\imageformats\qmng*.dll .\staging\imageformats\qsvg*.dll .\staging\imageformats\qtga*.dll .\staging\imageformats\qtiff*.dll .\staging\imageformats\qweb*.dll
erase .\staging\imageformats\qgifd.dll .\staging\imageformats\qjpegd.dll .\staging\imageformats\qwbmpd.dll

echo Creating installer

if exist "C:\Program Files (x86)\NSIS\makensis.exe" (set nsis="C:\Program Files (x86)\NSIS\makensis.exe") else (set nsis="C:\Program Files\NSIS\makensis.exe")
%nsis% presi-aoke.nsi
IF ERRORLEVEL ==1 GOTO :ERROR

echo Build complete
EXIT /B 0

:ERROR
ECHO Build failed.
EXIT /B 1
