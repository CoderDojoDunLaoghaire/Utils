@echo off
set /a n=0
set "prefix=192.168.3"
set "mac=63-FB"
set /P prefix=Enter the network prefix example: %prefix%:
set /P mac=Enter the last four digits of your Pi MAC example 63-FB:
arp -d
:repeat
for /f "tokens=1 delims= " %%i in ('arp -a ^| find /i "%mac%"') do set ip=%%i
if "%ip%" neq "" echo found it! %ip% && goto end
set /a n+=1
echo checking %prefix%.%n%
ping -n 1 -w 500 %prefix%.%n% >>null
for /f "tokens=1 delims= " %%i in ('arp -a ^| find /i "%mac%"') do set ip=%%i
if "%ip%" neq "" echo found your Pi at %ip% && goto end
if %n% lss 254 goto repeat
:end