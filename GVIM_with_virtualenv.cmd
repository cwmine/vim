@echo off
REM using with pythom mode plugin of gvim
REM apply virutal enviroment to python mode run in windows
if "%1" == "h" goto begin
mshta vbscript:createobject("wscript.shell").run("%~0 h %1",0)(window.close)&&exit
:begin
set VIRTUAL_ENV=C:\Green\openmdao\openmdao-0.9.6
"C:\Program Files (x86)\Vim\vim74\gvim.exe" %2
