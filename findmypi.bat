@echo off
set /a n=1
set "prefix=192.168.137"
set "mac=*"
set "ip="
echo This script will look for your Pi on the Network your Pi is connected to. This could be your Ethernet Lan or Wifi Lan depending on how the Pi is connected. The script tries to Ping every computer on the specified network and then checks the Arp table for the MAC address of your Pi. If you don't know the Mac then leave that blank, you will have to try to connect to each computer found by this script. If you have only the Pi connected then you should only find 1 result. Lets give it a try it!
pause
set /P prefix=Enter the network prefix (default) %prefix%:
set /P mac=Enter the last four digits of your Pi MAC example 63-FB:
:repeat
rem echo checking for %mac%
rem echo matching %ip%
REM - check current arp table if we have specified a mac
if not %mac% == * ( 
rem echo in match 
	for /f "tokens=1 delims= " %%i in ('arp -a ^| find /i "%mac%"') do set ip=%%i 
	if "%ip%" neq "" echo found your Pi at address %ip% && goto end
)
set /a n+=1
rem set /a n=57
echo checking %prefix%.%n%
ping -n 1 -w 500 %prefix%.%n% >test.txt
if not %mac% == * ( 
	rem test to see if mac is now in ARP table
	for /f "tokens=1 delims= " %%i in ('arp -a ^| find /i "%mac%"') do set ip=%%i
	if "%ip%" neq "" echo found your Pi at address %ip% && goto end
	) ELSE (
	rem just look for a potential IP address on the same network
 	findstr /m "Received = 1" test.txt >nul
rem	echo error level is %errorlevel% 
	if %errorlevel%==0 echo found a potential match at address %prefix%.%n%
)
@if %n% lss 254 goto repeat
:end
arp -a
