@echo off
setlocal enabledelayedexpansion

if "%~1" NEQ "" (
	if "%~1" NEQ "-help" (
		call :proc %*
		exit /b %ERRORLEVEL%
	)
)

call :echoHelp
exit /b

:proc
	set exec=%~1
	if "%exec%" NEQ "" (
		rmdir C:\xperf\ /s /q
		mkdir C:\xperf\
		xperf -on PROC_THREAD+LOADER
		xperf -start heapsession -heap -PidNewProcess "%exec%" -stackwalk HeapAlloc+HeapRealloc -MinBuffers 128 -MaxBuffers 512 -BufferSize 1024
		pause
		xperf -stop heapsession -d C:\xperf\heap.etl
		xperf -d C:\xperf\kernel.etl
		xperf -merge C:\xperf\heap.etl C:\xperf\kernel.etl C:\xperf\combined.etl
		echo "Output is in C:\xperf\"
		exit /b
	) else (
		call :err %RETCOD%
	)
exit /b %ERRORLEVEL%


:concat

	call set output=%output% ^& echo !_tmp:^>=^^^>!
exit /b

:echoHelp

	echo %~n0 executubale
	echo\
	echo Examples:
	echo %~n0 "firefox.exe -P test -no-remote" 
exit /b

:err
	if %1 EQU 2          (set errmsg=Access Denied)
	if %1 EQU 3          (set errmsg=Insufficient Privilege)
	if %1 EQU 8          (set errmsg=Unknown failure ^& echo Hint: Check if the executable exists)
	if %1 EQU 21         (set errmsg=Invalid Parameter ^& echo Hint: Check executable path)
	if %1 EQU 1000       (set errmsg=Executable not defined.)
	if "%errmsg:~0,1%" EQU "" (set errmsg=%output% ^& echo Hint: brackets, quotes or commas in the password may could breack the script.)

	echo %errmsg%
exit /b %1