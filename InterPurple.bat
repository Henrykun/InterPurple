@echo off > nul
TITLE %username%
SET "Mo1=MODE con:cols=84 lines=36"
%Mo1%
color 0A

:: BatchGotAdmin 
:------------------------------------- 
REM --> Check for permissions 
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system" 
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" 
) 

REM --> If error flag set, we do not have admin. 
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges... 
    goto UACPrompt 
) else (goto gotAdmin) 

:UACPrompt 
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs" 
    set params=%* 
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs" 

    "%temp%\getadmin.vbs" 
    del "%temp%\getadmin.vbs" 
    exit /B 

:gotAdmin 
    pushd "%CD%" 
    CD /D "%~dp0" 
:--------------------------------------  

:Fuentes
rem http://arbo.com.ve/programacin-batch-avanzada/

:inicio0
TITLE InterPurple: Configura, Repara y Optimiza tu Internet [By Henry]
echo Cargando el programa por favor espere..
REM Obtener la interfaz de red evitando VirtualBox Host-Only Network
For /f "tokens=2 delims==" %%F in ('wmic nic where "NetConnectionStatus=2 and AdapterTypeId=0 and NOT Description like '%%VirtualBox%%'" get NetConnectionID /format:list') do set interface=%%F
cls
echo Cargando el programa por favor espere....
SET "PuertaY=192.168.1.1"
SET "PuertaX=192.168.1"
SET "Puerta=192.168.1.1"
Call :MyIP
SET "IPold=%IP%"
SET "MyWifi=%Network%"
Set Linea=-----------------------------------------------------------------------------------
Set Linea2=----------------------------------------------------------------------------
cls
echo Cargando el programa por favor espere......
goto inicio1

:Inicio
SET "var=0"
cls
echo Se esta refrescando informacion por pantalla...
Call :MyIP
:inicio1
Call :LaPuertaXY
%Mo1%
echo %linea%
echo  Fecha: %DATE% ^| IP Anterior: %IPold% ^| IP Actual: %IP%
echo %linea%
Call :CantvDNS
IF "%dnsip%"=="%Puerta%" echo  Pta Enlace: %Puerta% ^| Servidor DNS: %dnsip% (Modo Automatico)
IF NOT "%dnsip%"=="%Puerta%" echo  Pta Enlace: %Puerta% ^| Servidor DNS: %dnsip%
for /f "tokens=1-5 delims=." %%a in ("%IP%") do SET "sininternet=%%a"
for /f "tokens=1-5 delims=." %%a in ("%IP%") do SET "sininternet=%sininternet%.%%b"
if "%sininternet%"=="169.254" (echo %linea%
echo  Sin Internet!!! Presione A para actualizar informacion O R para reparar Conexion
)
echo %linea%
echo  Conectado al Wi-FI: %Network% ^| Tu MAC: %MACMUestra%
echo %linea%
echo  [B]	Detectar IPs Libres para usar con %PuertaX%.[  ].
echo  [R]	Reparar la conexion a Internet.
echo  [A]	Actualizar informacion por pantalla.
echo  [C]	Realizar prueba de ping mediante CloudFlare(1.1.1.1).
echo  [G]	Realizar prueba de ping mediante Google(8.8.8.8).
echo  [P]	Realizar prueba de ping a tu Router(%Puerta%).
echo  [M]	Cambiar la MAC de tu PC de forma aleatoria.
echo  [O]	Restablecer MAC Predeterminada(Original) de tu Equipo.
echo  [F]	Restablecer Configuracion de Fabrica de Internet. 
echo  [Nro]	Usar IP Manual %PuertaX%.[  ] (Solo coloque el Valor de [  ]).
echo  [S]	Usar IP Automatica	^|^|	 [N] Usar DNS de Fabrica.
echo  [J]	Habilitar Proxy (%Puerta%:3128) ^|^| [K] Deshabilitar Proxy.
echo  [D]	Usar DNS de Google + CloudFlare + Comodo Secure.
echo  [H]	Herramientas de Optimizacion de Internet TCP/IP.
echo  [U]	Auto-ajustar MTU. ^|^|  [W] Restaurar MTU a 1500(Por defecto).
ECHO  [T]	Configura tu Tarjeta de Red WI-FI(Acceso Directo).
echo.
echo %linea%
echo  - En opcion "Nro"(Ip Manual) use un numero comprendido entre 2 a 254.
echo  - Si cambia la MAC recuerde presionar A + Enter luego de hacerlo, para que este
echo    programa sea capaz de mostrar la MAC y la IP Real luego del cambio. 
echo %linea%
echo.

:Validar
SET /p var= ^> Seleccione una opcion[...]: 
IF /I "%var%"=="R" Call :Reparar
IF /I "%var%"=="A" CLS & echo Se esta refrescando informacion por pantalla...
IF /I "%var%"=="D" Call :MenuDNS
IF /I "%var%"=="N" SET "MYDNS=" >NUL & Call :CambiarDNS
IF /I "%var%"=="G" Call :MedirPing
IF /I "%var%"=="P" Call :RouterPing
IF /I "%var%"=="C" Call :CloudFlare
IF /I "%var%"=="F" Call :Fabrica
IF /I "%var%"=="B" Call :Detectador
IF /I "%var%"=="M" Call :MacAleatoria
IF /I "%var%"=="O" Call :MacFabrica
IF /I "%var%"=="T" GOTO WifiPropiedades
IF /I "%var%"=="U" Call :CalcularMTU
IF /I "%var%"=="W" SET MTU=1500 & Call :MTUPantalla
IF /I "%var%"=="H" Call :Menu2
IF /I "%var%"=="K" Call :DeshabilitarProxy
IF /I "%var%"=="J" Call :HabilitarProxy
IF /I "%var%"=="S" netsh interface ip set address "%interface%" dhcp >NUL 2>&1 & color 0A
Call :MyIP
if %var% LEQ 0 Goto Inicio
if %var% LSS 256 Call :CambiaIP
Goto Inicio

:Menu2
SET "choice1=0"
MODE con:cols=77 lines=35
cls
echo %linea2%
ECHO.
ECHO                 ==========================================
ECHO                   ///..==[Bienvenid@ %USERNAME%]==..///    
ECHO                 ==========================================
ECHO.
echo %linea2%
ECHO.
ECHO  *** OPTIMIZA TU CONEXION TCP/IP ***
ECHO  - Este parche optimiza tu conexion a internet, ademas deshabilita el 
ECHO    reservado de banda para QoS y te ayuda a desactivar el Windows Update.
ECHO.  
echo %linea2%
ECHO.
ECHO  [Y] Optimizar TCP/IP internet (Recomendado).
ECHO  [R] Revertir Optimizacion TCP/IP internet.
ECHO.
ECHO  [J] Deshabilitar el soporte para IPv6 (Recomendado -^> No se usa por ahora).
ECHO  [K] Habilitar el soporte para IPv6 (Solo activalo cuando lo implementen!!).
ECHO.
ECHO  [Q] Deshabilitar Auto-Updates de Adobe, Google, Java, Etc(Recomendado).
ECHO  [P] Habilitar Auto-Updates de Adobe, Google, Java, Etc(No Recomendado!!).
ECHO.
ECHO  [D] Desactivar Windows Update (Recomendado).
ECHO  [A] Habilitar Windows Update (No Recomendado!!).
ECHO.
ECHO  [M] Desactivar Mitigaciones de Windows (Mas rapidez menos seguridad).
ECHO  [N] Habilitar Mitigaciones de Windows (Mas seguridad menos rapidez).
ECHO.
ECHO  [V] Para Volver al Menu Principal.
ECHO.
echo %linea2%
ECHO.

SET /P choice1= ^> Elige la letra y,q,a,b,d,n y presiona ENTER: 
IF /I "%choice1%"=="Y" GOTO TWEAK
IF /I "%choice1%"=="Q" GOTO :AdobeGoogleUpdateOFF
IF /I "%choice1%"=="P" GOTO :AdobeGoogleUpdateON
IF /I "%choice1%"=="R" GOTO DEFAULT
IF /I "%choice1%"=="D" GOTO UPDATESWINOFF
IF /I "%choice1%"=="A" GOTO UPDATESWINON
IF /I "%choice1%"=="J" GOTO IPV6Disable
IF /I "%choice1%"=="K" GOTO IPV6Enable
IF /I "%choice1%"=="M" GOTO ModoDepDesactivado
IF /I "%choice1%"=="N" GOTO ModoDepActivado
IF /I "%choice1%"=="V" GOTO Inicio
:: ELSE
GOTO Menu2

:MENUDNS
%Mo1%
color 0A
Cls
Echo+ Elige una opcion: | More
Echo: (0) - Ninguno (Obtener la direccion del servidor DNS automaticamente)| More
Echo: (1) - Usar Google DNS(8.8.8.8 y 8.8.4.4) | More
Echo: (2) - Usar Cloudflare DNS(1.1.1.1 y 1.0.0.1)| More
Echo: (3) - Usar Comodo Secure DNS(8.26.56.26 y 8.20.247.20)| More
Echo: (4) - Usar Google + Cloudflare DNS(8.8.8.8 y 1.1.1.1)| More
Echo: (5) - Usar Cloudflare + Google DNS(1.1.1.1 y 8.8.8.8)| More 
Set /P Option=^>^>^> 
If not defined option (Goto :MENUDNS)
Echo "%Option%" | Findstr "[0-5]" >NUL
If %Errorlevel% EQU 1  (Goto :MENUDNS)
If %Option% EQU 0 (SET "MYDNS=" >NUL & Call :CambiarDNS)
If %Option% EQU 1 (SET "MYDNS=8.8.8.8,8.8.4.4" >NUL & Call :CambiarDNS)
If %Option% EQU 2 (SET "MYDNS=1.1.1.1,1.0.0.1" >NUL & Call :CambiarDNS)
If %Option% EQU 3 (SET "MYDNS=8.26.56.26,8.20.247.20" >NUL & Call :CambiarDNS)
If %Option% EQU 4 (SET "MYDNS=8.8.8.8,1.1.1.1" >NUL & Call :CambiarDNS)
If %Option% EQU 5 (SET "MYDNS=1.1.1.1,8.8.8.8" >NUL & Call :CambiarDNS)
Cls
Echo Se ha configurado su red para usar el servidor DNS Seleccionado...
TIMEOUT /T 2 >NUL
GOTO:EOF

:MyIP
Rem Fuente: Hay alguna manera de obtener solo la dirección MAC de Ethernet a través del símbolo del sistema en Windows
SET "Network="
for /f "delims=: tokens=2" %%n in ('netsh wlan show interface name="%interface%" ^| findstr "Perfil"') do set "Network=%%n"
for /f "delims=: tokens=2" %%n in ('netsh wlan show interface name="%interface%" ^| findstr "Profile"') do set "Network=%%n"
IF NOT "%Network%"=="" set "Network=%Network:~1%"
IF "%Network%"=="" SET "Network=No Disponible"
SET "MACMUestra="
for /f "usebackq tokens=3 delims=," %%a in (`getmac /fo csv /v ^| find /v "VirtualBox" ^| find "%interface%"`) do set MACMUestra=%%~a
IF "%MACMUestra%"=="" SET "MACMUestra=No Disponible"
SET "IP="
SET "Puerta="
SET "dnsip="
SET "IP="
REM Excluir direcciones IP 169.254 y tomar la primera IP válida
For /f "skip=1 tokens=1-4 delims={}, " %%A in ('wmic nicconfig get ipaddress') do (
  for /f %%B in ("%%~A") do (
    echo %%B | findstr /v "169.254" >nul
    if not errorlevel 1 (
      set "IP=%%~B"
      goto EndIP
    )
  )
)
:EndIP

For /f "skip=1 delims={}, " %%A in ('wmic nicconfig get defaultIPgateway') do for /f "tokens=1" %%B in ("%%~A") do set "Puerta=%%~B"
For /F "Tokens=*" %%a in ('wmic nicconfig get dnsserversearchorder ^|find ","') do set dnsip=%%a
for /f "tokens=1-5 delims=: " %%d in ("%IP%") do SET "IPV6var=%%d"
if "%puerta%"=="" SET "puerta=No Disponible"
if "%IPV6var%"=="fe80" Goto MyIP2
if "%IP%"=="" Goto MyIP2
GOTO:EOF

:MyIP2
for /f "skip=1 delims={}, " %%A in ('wmic nicconfig get ipaddress') do for /f "tokens=1" %%B in ("%%~A") do set "IP=%%~B"
if "%IP%"=="" SET "IP=No Disponible"
if "%dnsip%"=="" Goto MyIP3
GOTO:EOF

:MyIP3
For /f "skip=1 delims={}, " %%A in ('wmic nicconfig get dnsserversearchorder') do for /f "tokens=1" %%B in ("%%~A") do set "dnsip=%%~B"
if "%dnsip%"=="" SET "dnsip=No Disponible"
GOTO:EOF

:LaPuertaXY
IF "%Puerta%"=="No Disponible" Goto :FinDePuertaX
IF "%Puerta%"=="" Goto :FinDePuertaX
SET "PuertaY=%Puerta%"
if "%Puerta:~14,3%"=="." (SET "PuertaX=%Puerta:~0,14%"
Goto FinDePuertaX)
if "%Puerta:~12,3%"=="." (SET "PuertaX=%Puerta:~0,13%"
Goto FinDePuertaX)
if "%Puerta:~12,1%"=="." (SET "PuertaX=%Puerta:~0,12%"
Goto FinDePuertaX)
if "%Puerta:~11,1%"=="." (SET "PuertaX=%Puerta:~0,11%"
Goto FinDePuertaX)
if "%Puerta:~10,1%"=="." (SET "PuertaX=%Puerta:~0,10%"
Goto FinDePuertaX)
if "%Puerta:~9,1%"=="." (SET "PuertaX=%Puerta:~0,9%"
Goto FinDePuertaX)
if "%Puerta:~8,1%"=="." (SET "PuertaX=%Puerta:~0,8%"
Goto FinDePuertaX)
if "%Puerta:~7,1%"=="." (SET "PuertaX=%Puerta:~0,7%"
Goto FinDePuertaX)
if "%Puerta:~6,1%"=="." (SET "PuertaX=%Puerta:~0,6%"
Goto FinDePuertaX)
if "%Puerta:~5,1%"=="." (SET "PuertaX=%Puerta:~0,5%"
Goto FinDePuertaX)
if "%Puerta:~4,1%"=="." (SET "PuertaX=%Puerta:~0,4%"
Goto FinDePuertaX)
:FinDePuertaX
Goto:EOF

:ReconectarWiFI
IF "%MyWifi%"=="" Goto:EOF
IF "%Network%"=="No Disponible" SET "Network=%MyWifi%"
IF "%Network%"=="" SET "Network=%MyWifi%"
netsh wlan set profileorder name=%Network%interface=%interface% priority=1 >NUL 2>&1
netsh wlan connect ssid=%Network%name=%Network%>NUL 2>&1
Goto:EOF

:CambiaIP
cls
color 0D
echo Configurando Internet de forma manual...
ping -n 1 %PuertaX%.%var% | findstr TTL && (cls
Echo La IP Seleccionada esta en uso!!! Elija una diferente
Echo Presione una tecla para continuar...
Pause > NUL
GOTO:EOF)
netsh interface ip set address "%interface%" static %PuertaX%.%var% 255.255.255.0 %PuertaY% >NUL 2>&1
netsh interface ip set dns name="%interface%" static 8.8.8.8 >NUL 2>&1
netsh interface ip add dns name="%interface%" 1.1.1.1 index=2 >NUL 2>&1
netsh interface ip add dns name="%interface%" 8.26.56.26 index=3 >NUL 2>&1
set var1=0
Call :Tarea
GOTO:EOF

:Tarea
echo set objshell = createobject("wscript.shell") > "%WINDIR%\dchp.vbs"
echo objshell.run "%WINDIR%\dchp.bat",vbhide >> "%WINDIR%\dchp.vbs"
echo netsh interface ip set address "%interface%" dhcp > "%WINDIR%\dchp.bat"
echo netsh interface ip set dnsservers name="%interface%" source=dhcp >> "%WINDIR%\dchp.bat"
SCHTASKS /F /Create /SC ONLOGON /TN "Internet por DCHP" /TR "wscript.exe %WINDIR%\dchp.vbs" /ru SYSTEM %runlevel%
echo SCHTASKS /F /Delete /TN "Internet por DCHP" >> "%WINDIR%\dchp.bat"
echo Del /S /Q "%WINDIR%\dchp.vbs" >> "%WINDIR%\dchp.bat"
echo Del /S /Q "%WINDIR%\dchp.bat" >> "%WINDIR%\dchp.bat"
GOTO:EOF

:Reparar
cls
echo Estamos intentado reparar la conexion espere un poco...
Call :ReconectarWiFI
ipconfig /release >NUL 2>&1
ipconfig /renew >NUL 2>&1
ipconfig /flushdns
GOTO:EOF

:Fabrica
cls
echo Estamos reconfigurando el internet a los valores de fabrica...
Call :MacFabrica2
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0x0 /f
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v Proxy /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v DisallowRun /t REG_DWORD /d 0 /f
gpupdate /force
netsh int ip reset resetlog.txt >NUL 2>&1
netsh winsock reset >NUL 2>&1
netsh interface ip set address "%interface%" dhcp >NUL 2>&1
ipconfig /release >NUL 2>&1
ipconfig /renew >NUL 2>&1
SET "MYDNS=" >NUL & Call :CambiarDNS
SCHTASKS /F /Delete /TN "Internet por DCHP" >NUL 2>&1
SCHTASKS /F /Delete /TN "Internet por DCHP2" >NUL 2>&1
If Exist "%WINDIR%\dchp.vbs" Del /S /Q "%WINDIR%\dchp.vbs" >NUL 2>&1
If Exist "%WINDIR%\dchp.bat" Del /S /Q "%WINDIR%\dchp.bat" >NUL 2>&1
If Exist "%WINDIR%\dchp2.vbs" Del /S /Q "%WINDIR%\dchp2.vbs" >NUL 2>&1
If Exist "%WINDIR%\dchp2.bat" Del /S /Q "%WINDIR%\dchp2.bat" >NUL 2>&1
color 0A
GOTO:EOF

:CambiarDNS
%Mo1%
color 0A
CLS
For /F "Tokens=*" %%# in (
        'Reg query "HKLM\SYSTEM\ControlSet001\services\Tcpip\Parameters\Interfaces"'
    ) do (
        Reg ADD "%%#" /V "NameServer" /D "%MYDNS%" /F
    )
ipconfig /flushdns	
GOTO:EOF

:MedirPing
cls
color 0B
TITLE Prueba de ping con servidor de Google (By Henry)
echo %linea%
echo Realizando prueba de ping con servidor de Google:
echo %linea%
ping 8.8.8.8 -t
GOTO:EOF

:RouterPing
cls
color 0B
TITLE Prueba de conexion de ping con tu Router (By Henry)
echo %linea%
echo Realizando prueba de conexion de ping con tu Router:
echo %linea%
ping %Puerta% -t
GOTO:EOF

:CloudFlare
cls
color 0B
TITLE Prueba de conexion de ping con Cloudflare (By Henry)
echo %linea%
echo Realizando prueba de conexion de ping con Cloudflare:
echo %linea%
ping 1.1.1.1 -t
GOTO:EOF

:Detectador
cls
color 0B
TITLE %USERNAME% Detector de IPs (By Henry)
cls
set "var2="
set "var3="
set "var4="
set "Ejemplo1=Pc1"
set "Ejemplo2=%PuertaX%.17"
set IP=A
SET EquiposC=0
echo Estamos conectando a la red de equipos por favor espere...
rem Fuente: http://alquimistadecodigo.blogspot.com/2017/07/programacion-windows-batch-cmd-parte-3.html
FOR /F "skip=1 delims={}, " %%A in ('wmic nicconfig get ipaddress') do for /f "tokens=1" %%B in ("%%~A") do set "IP=%%~B"
FOR /L %%i IN (1,1,254) DO call :PROCESO2 %%i
echo.
echo Pulse una tecla para volver al menu inicial...
Pause >NUL
color 0A
TITLE InterPurple: Configura, Repara y Optimiza tu Internet [By Henry]
GOTO:EOF

:PROCESO2
SET var4=%1
Call :Grabar2
IF "%IP%" == "A" GOTO:EOF
ping %PuertaX%.%1 -n 1 -w 250 | find "TTL" > nul
IF ERRORLEVEL 1 GOTO grabar
IF ERRORLEVEL 0 (
call :Grabar3
GOTO:EOF)
 
:grabar
IF not defined var2 (
set var2=%var4%
GOTO:EOF
)
set var2=%var2%,%var4%
cls
echo %linea%
echo  Se iran mostrando Nros de IPs libres y sin uso para %PuertaX%.[  ]:
echo.
echo  [IPs usables]: %var2%...
echo.
echo %linea%
echo  Los siguientes valores ya estan en uso en su Red para %PuertaX%.[  ]:
echo.
echo  [IPs ^"NO^" usables]: %var3%
IF defined EquipoRED2 echo  %EquipoRED2%
echo.
echo  Nota: Si quieres conectarte a dichos equipos presiona Win+R y escribe:
echo  \\Nombre_Del_PC (Sin corchetes) 
echo  \\%PuertaX%.[X] (X es un numero de 1 a 3 cifras)
echo.
echo  Ejemplos:
echo  \\%Ejemplo1%
echo  \\%Ejemplo2%
echo.
echo %linea%
echo  Numero de Equipos encontrados y conectados a esta Red: %EquiposC%
echo %linea%
GOTO:EOF

:grabar2
SET Var4=%Var4%
GOTO:EOF

:grabar3
SET /A "EquiposC=%EquiposC%+1"
IF defined var3 SET var3=%var3%,%var4%
IF not defined var3 SET var3=%var4%
IF "%PuertaX%.%var4%"=="%IP%" (
SET "EquipoRED=%COMPUTERNAME%"
Call :Grabar4
GOTO:EOF)
IF "%PuertaX%.%var4%"=="%Puerta%" (
SET "EquipoRED=Tu-Router"
Call :Grabar4
GOTO:EOF)
for /f "delims=^< tokens=1" %%n in ('NBTSTAT -A "%PuertaX%.%var4%" ^| findstr "<00>"') do (
SET EquipoRED=%%n
Call :Grabar4
)
GOTO:EOF

:Grabar4
set EquipoRED=%EquipoRED: =%
set EquipoRED=%EquipoRED:	=%
IF "%EquipoRED%"=="WORKGROUP" GOTO:EOF
SET "Ejemplo1=%EquipoRED%"
SET "Ejemplo2=%PuertaX%.%var4%"
IF defined EquipoRED2 SET "EquipoRED2=%EquipoRED2%, %EquipoRED%[%var4%]"
IF NOT defined EquipoRED2 SET "EquipoRED2=%EquipoRED%[%var4%]"
GOTO:EOF

:MacAleatoria
Rem Fuente: [BAT] Randomly change the Mac Address on Windows · GitHub
color 0E
cls
echo Estamos cambiando la MAC por favor espere...
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS 
 ::Generate and implement a random MAC address
 FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
 CALL :MAC
 FOR %%b IN (0 00 000) DO (
 REG QUERY HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v NetworkAddress /t REG_SZ /d !MAC!  /f >NUL 2>NUL
 )
 )
Call :MACPaso2
Goto:EOF

:MacFabrica
Rem Fuente: View network connections and change (spoof) MAC address on Windows 7/8/10
color 0A
cls
echo Estamos restableciendo la MAC Original por favor espere...
:MacFabrica2
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS 
 ::Generate and implement a random MAC address
 FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
 CALL :MAC
 FOR %%b IN (0 00 000) DO (
 REG QUERY HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && Reg delete HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\%%b%%a /v "NetworkAddress" /f >NUL 2>NUL
 )
 )
Call :MACPaso2
Goto:EOF
 
:MACPaso2 
 ::Reset NIC adapters so the new MAC address is implemented and the power saving mode is disabled.
 FOR /F "tokens=2 delims=, skip=2" %%a IN ('"wmic nic where (netconnectionid like '%%') get netconnectionid,netconnectionstatus /format:csv"') DO (
 netsh interface set interface name="%%a" disable >NUL 2>NUL
 netsh interface set interface name="%%a" enable >NUL 2>NUL
 Call :ReconectarWiFI
 )
Goto:EOF

:MAC
::Generates semi-random value of a length according to the "if !COUNT!"  line, minus one, and from the characters in the GEN variable
SET COUNT=0
SET GEN=ABCDEF0123456789
SET GEN2=26AE
SET MAC=
:MACLOOP
SET /a COUNT+=1
SET RND=%random%
::%%n, where the value of n is the number of characters in the GEN variable minus one.  So if you have 15 characters in GEN, set the number as 14
SET /A RND=RND%%16
SET RNDGEN=!GEN:~%RND%,1!
SET /A RND2=RND%%4
SET RNDGEN2=!GEN2:~%RND2%,1!
IF "!COUNT!"  EQU "2" (SET MAC=!MAC!!RNDGEN2!) ELSE (SET MAC=!MAC!!RNDGEN!)
IF !COUNT!  LEQ 11 GOTO MACLOOP 
Goto:EOF

:AhorroEnergiaOFF
 ::Disable power saving mode for network adapters
 FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
 FOR %%b IN (0 00 000) DO (
 REG QUERY HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v PnPCapabilities /t REG_DWORD /d 24 /f >NUL 2>NUL
 )
 )
GOTO:EOF

:AhorroEnergiaON
 ::Disable power saving mode for network adapters
 FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
 FOR %%b IN (0 00 000) DO (
 REG QUERY HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v PnPCapabilities /t REG_DWORD /d 16 /f >NUL 2>NUL
 )
 )
GOTO:EOF

:CantvDNS
Rem quitando las comillas, espacios y llaves
set dnsip=%dnsip:"=%
set dnsip=%dnsip:{=%
set dnsip=%dnsip:}=%
set dnsip=%dnsip:  =%
Rem DNS de CANTV
SET "dnsip1=200.44.32.12"
Rem Evaluando variables
IF "%dnsip:~0,12%"=="%dnsip1%" SET "dnsip=%dnsip% (Cantv DNS)"
IF NOT "%dnsip:~0,12%"=="%dnsip1%" SET "dnsip=%dnsip% (Manual)"
Goto:EOF

:TWEAK
netsh int tcp set heuristics disabled
CALL :AhorroEnergiaOFF
SET "z1=netsh int tcp set global"
%z1% rss=enabled
%z1% chimney=disabled
%z1% autotuninglevel=disabled
%z1% congestionprovider=ctcp >NUL 2>&1
%z1% ecncapability=disabled
%z1% timestamps=disabled
%z1% netdma=enabled
%z1% dca=enabled
%z1% rsc=disabled
%z1% initialRto=2000
%z1% MaxSynRetransmissions=2
%z1% NonSackRttResiliency=disabled
SET "z1=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
reg add %z1% /v DefaultTTL /d 64 /t REG_DWORD /f
reg add %z1% /v EnableTCPA /d 1 /t REG_DWORD /f
reg add %z1% /v Tcp1323Opts /d 1 /t REG_DWORD /f
reg add %z1% /v TCPMaxDataRetransmissions /d 7 /t REG_DWORD /f
reg add %z1% /v MaxUserPort /d 65534 /t REG_DWORD /f
reg add %z1% /v TCPTimedWaitDelay /d 30 /t REG_DWORD /f
reg add %z1% /v SynAttackProtect /d 1 /t REG_DWORD /f
reg add %z1% /v EnableDCA /d 1 /t REG_DWORD /f
SET "z2=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider"
reg add %z2% /v LocalPriority /d 4 /t REG_DWORD /f
reg add %z2% /v HostsPriority /d 5 /t REG_DWORD /f
reg add %z2% /v DnsPriority /d 6 /t REG_DWORD /f
reg add %z2% /v NetbtPriority /d 7 /t REG_DWORD /f
Rem Optimizar numero de conexiones
SET "z1=HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl"
SET "z2=HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\Main\FeatureControl"
SET "z3=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
reg add "%z3%" /v MaxConnectionsPerServer /d 10 /t REG_DWORD /f
reg add "%z3%" /v MaxConnectionsPer1_0Server /d 10 /t REG_DWORD /f
Rem 32Bits
reg add "%z1%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /d 10 /t REG_DWORD /f
reg add "%z1%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /d 10 /t REG_DWORD /f
reg add "%z1%\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /d 10 /t REG_DWORD /f
reg add "%z1%\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /d 10 /t REG_DWORD /f
Rem 64Bits
reg add "%z2%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /d 10 /t REG_DWORD /f >NUL 2>&1
reg add "%z2%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /d 10 /t REG_DWORD /f >NUL 2>&1
reg add "%z2%\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /d 10 /t REG_DWORD /f >NUL 2>&1
reg add "%z2%\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /d 10 /t REG_DWORD /f >NUL 2>&1
SET "z1=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /d 1 /t REG_DWORD /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Size /d 3 /t REG_DWORD /f
reg add "%z1%" /v NetworkThrottlingIndex /d FFFFFFFF /f
reg add "%z1%" /v SystemResponsiveness /d 10 /t REG_DWORD /f
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f
Reg add "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\PSched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f >NUL 2>&1
Reg ADD "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f
Reg ADD "HKLM\SYSTEM\ControlSet001\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f
reg add HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config /v AutoConnectAllowedOEM /d 0 /t REG_DWORD /f
reg delete HKLM\SOFTWARE\Microsoft\WlanSvc\AnqpCache /v OsuRegistrationStatus /f >NUL 2>&1
Call :NagleOFF
Powershell.exe Disable-NetAdapterLso -Name *
Powershell.exe Enable-NetAdapterChecksumOffload -Name *
netsh interface ipv4 set subinterface "%interface%" mtu=1500 store=persistent
CLS
ECHO  * PARCHE APLICADO CORRECTAMENTE - PRESIONA ENTER *
GOTO SUCCESS

:AdobeGoogleUpdateOFF
CLS
Rem Desactivar configuracion Servicios de Google y Adobe
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Google ^| findstr Update') do sc config %%x start=disabled
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Adobe ^| findstr Update') do sc config %%x start=disabled
Rem Desactivar Tareas de Google y Adobe
for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| findstr ^^Google ^| findstr ^^Update') do schtasks /Change /TN "%%x" /Disable
for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| findstr ^^Adobe ^| findstr ^^Update') do schtasks /Change /TN "%%x" /Disable
Rem Deteniendo Servicios de Google y Adobe
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Google ^| findstr Update') do sc stop %%x
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Adobe ^| findstr Update') do sc stop %%x
sc config AdobeARMservice start= disabled
sc stop AdobeARMservice
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SunJavaUpdateSched" /f >NUL 2>&1
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" /v "SunJavaUpdateSched" /f >NUL 2>&1
reg add "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /V EnableJavaUpdate /T REG_DWORD /D 0 /F >NUL 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy" /V EnableJavaUpdate /T REG_DWORD /D 0 /F >NUL 2>&1
CALL :FirefoxPrefOFF
taskkill /IM jucheck.exe /F
taskkill /IM juscheck.exe /F
sc config MozillaMaintenance start=disabled
CLS
ECHO  * SE HAN DESACTIVADO CORRECTAMENTE LAS ACTUALIZACIONES - PRESIONA ENTER *
ECHO.
ECHO.
@PAUSE
GOTO MENU2

:AdobeGoogleUpdateON
CLS
Rem activar configuracion Servicios de Google y Adobe
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Google ^| findstr Update') do sc config %%x start=auto
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Adobe ^| findstr Update') do sc config %%x start=auto
Rem activar Tareas de Google y Adobe
for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| findstr ^^Google ^| findstr ^^Update') do schtasks /Change /TN "%%x" /Enable
for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| findstr ^^Adobe ^| findstr ^^Update') do schtasks /Change /TN "%%x" /Enable
Rem Iniciando Servicios de Google y Adobe
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Google ^| findstr Update') do sc start %%x
for /f "tokens=2 delims=()" %%x in ('sc query state^=all ^| findstr Adobe ^| findstr Update') do sc start %%x
sc config AdobeARMservice start=auto
sc start AdobeARMservice
reg add "HKLM\SOFTWARE\JavaSoft\Java Update\Policy" /V EnableJavaUpdate /T REG_DWORD /D 1 /F >NUL 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy" /V EnableJavaUpdate /T REG_DWORD /D 1 /F >NUL 2>&1
CALL :FirefoxPrefON
sc config MozillaMaintenance start=auto
CLS
ECHO  * SE HAN ACTIVADO CORRECTAMENTE LAS ACTUALIZACIONES - PRESIONA ENTER *
ECHO.
ECHO.
@PAUSE
GOTO MENU2

:FirefoxPrefOFF
SET "z1=%ProgramFiles%\Mozilla Firefox"
SET "z2=%PROGRAMFILES(x86)%\Mozilla Firefox"
SET "z3=defaults\pref"
SET "z4="
SET "z5="
IF EXIST "%z1%" SET "z4=%z1%\%z3%" & SET "z5=%z1%" & Call :FirefoxSET
IF EXIST "%z2%" SET "z4=%z2%\%z3%" & SET "z5=%z1%" & Call :FirefoxSET
GOTO:EOF

:FirefoxSET
IF Exist "%z4%" Rd /S /Q "%z4%" >NUL	
IF Not Exist "%z4%" MkDir "%z4%" >NUL	
echo // > "%z4%\local-settings.js"
echo pref^("general.config.filename", "mozilla.cfg"^); >> "%z4%\local-settings.js" 
echo pref^("general.config.obscure_value", 0^); >> "%z4%\local-settings.js" 
echo pref^("browser.rights.3.shown", true^); >> "%z4%\local-settings.js" 
echo // > "%z5%\mozilla.cfg"
echo lockPref^("app.update.service.enabled", false^); >> "%z5%\mozilla.cfg"
echo lockPref^("app.update.url", "https://localhost"^); >> "%z5%\mozilla.cfg"
GOTO:EOF

:FirefoxPrefON
SET "z1=%ProgramFiles%\Mozilla Firefox"
SET "z2=%PROGRAMFILES(x86)%\Mozilla Firefox"
IF EXIST "%z1%\defaults" RD /S /Q "%z1%\defaults"
IF EXIST "%z2%\defaults" RD /S /Q "%z2%\defaults"
IF Exist "%z1%\mozilla.cfg" Del /F /Q "%z1%\mozilla.cfg" >NUL
IF Exist "%z2%\mozilla.cfg" Del /F /Q "%z2%\mozilla.cfg" >NUL
GOTO:EOF

:UPDATESWINOFF
CLS
ECHO Se estan deshabilitando las actualizaciones de Windows...
sc stop wuauserv >NUL 2>&1
sc config wuauserv start=disabled >NUL 2>&1
SET "z1=HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization"
reg add "%z1%" /v SystemSettingsDownloadMode /d 0 /t REG_DWORD /f
reg add "%z1%\Config" /v DODownloadMode /d 0 /t REG_DWORD /f
reg add "%z1%\Config" /v DownloadMode /d 0 /t REG_DWORD /f
SET "z2=HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
reg add %z2% /v AUOptions /d 4 /t REG_DWORD /f
reg add %z2% /v NoAutoUpdate /d 1 /t REG_DWORD /f
SET "z3=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade"
reg add %z3% /v "AllowOSUpgrade" /t REG_DWORD /d 0 /f
reg add %z3% /v "ReservationsAllowed" /t REG_DWORD /d 0 /f
Rem Otros Desactivadores
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v AutoDownload /d 2 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /d 2 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /d 2 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferUpgrade /d 1 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /t REG_DWORD /d 1 /f
CLS
ECHO  * ACTUALIZACIONES DE WINDOWS DESACTIVADAS - PRESIONA ENTER *
ECHO.
ECHO.
@PAUSE
GOTO MENU2

:UPDATESWINON
CLS
ECHO Para habilitar nuevamente las Actualizaciones de Windows...
SET /P Elegir1= ^> Escribe ^"Si^" y presiona ENTER: 
IF /I NOT "%Elegir1%"=="si" GOTO Menu2
CLS
ECHO Se estan habilitando las actualizaciones de Windows...
sc config wuauserv start=auto >NUL 2>&1
sc start wuauserv >NUL 2>&1
SET "z1=HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization"
reg delete "%z1%" /v SystemSettingsDownloadMode /f >NUL 2>&1
reg add "%z1%\Config" /v DODownloadMode /d 3 /t REG_DWORD /f
reg add "%z1%\Config" /v DownloadMode /d 3 /t REG_DWORD /f
SET "z2=HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
reg delete %z2% /v AUOptions /f >NUL 2>&1
reg add %z2% /v NoAutoUpdate /d 0 /t REG_DWORD /f
SET "z3=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade"
reg add %z3% /v "AllowOSUpgrade" /t REG_DWORD /d 0 /f
reg add %z3% /v "ReservationsAllowed" /t REG_DWORD /d 0 /f
Rem Otros Activadores
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v AutoDownload /d 4 /t REG_DWORD /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /f >NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /d 4 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferUpgrade /d 0 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /t REG_DWORD /d 1 /f
CLS
ECHO Se estan habilitando las actualizaciones de Windows...
net start wuauserv >NUL 2>&1
CLS
ECHO  * ACTUALIZACIONES DE WINDOWS ACTIVADAS CORRECTAMENTE - PRESIONA ENTER *
ECHO.
ECHO.
@PAUSE
GOTO MENU2

:DEFAULT
netsh int tcp set heuristics default
CALL :AhorroEnergiaON
SET "z1=netsh int tcp set global"
%z1% rss=default
%z1% chimney=default
%z1% autotuninglevel=normal
%z1% congestionprovider=default >NUL 2>&1
%z1% ecncapability=default
%z1% timestamps=default
%z1% rsc=default
%z1% initialRto=3000
%z1% MaxSynRetransmissions=2
%z1% NonSackRttResiliency=default
SET "z1=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
REG DELETE %z1% /V DefaultTTL /f >NUL 2>&1
REG DELETE %z1% /V EnableTCPA /f >NUL 2>&1
reg add %z1% /v Tcp1323Opts /d 0 /t REG_DWORD /f
reg add %z1% /v TCPMaxDataRetransmissions /d 5 /t REG_DWORD /f
reg DELETE %z1% /v MaxUserPort /f >NUL 2>&1
reg DELETE %z1% /v TCPTimedWaitDelay /f >NUL 2>&1
REG DELETE %z1% /V SynAttackProtect /f >NUL 2>&1
REG DELETE %z1% /V EnableDCA /f >NUL 2>&1
SET "z2=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider"
reg add %z2% /v LocalPriority /d 499 /t REG_DWORD /f
reg add %z2% /v HostsPriority /d 500 /t REG_DWORD /f
reg add %z2% /v DnsPriority /d 2000 /t REG_DWORD /f
reg add %z2% /v NetbtPriority /d 2001 /t REG_DWORD /f
Rem Restaurar Numero de conexiones
SET "z1=HKLM\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl"
SET "z2=HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\Main\FeatureControl"
SET "z3=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
reg add "%z3%" /v MaxConnectionsPerServer /d 2 /t REG_DWORD /f >NUL 2>&1
reg add "%z3%" /v MaxConnectionsPer1_0Server /d 4 /t REG_DWORD /f >NUL 2>&1
Rem 32Bits
reg add "%z1%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /d 4 /t REG_DWORD /f
reg delete "%z1%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /f >NUL 2>&1
reg add "%z1%\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /d 2 /t REG_DWORD /f
reg delete "%z1%\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /f >NUL 2>&1
Rem 64Bits
reg add "%z2%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v explorer.exe /d 4 /t REG_DWORD /f >NUL 2>&1
reg delete "%z2%\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v iexplore.exe /f >NUL 2>&1
reg add "%z2%\FEATURE_MAXCONNECTIONSPERSERVER" /v explorer.exe /d 2 /t REG_DWORD /f >NUL 2>&1
reg delete "%z2%\FEATURE_MAXCONNECTIONSPERSERVER" /v iexplore.exe /f >NUL 2>&1
SET "z1=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /d 0 /t REG_DWORD /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v Size /d 1 /t REG_DWORD /f
reg add "%z1%" /v NetworkThrottlingIndex /d 10 /t REG_DWORD /f
reg add "%z1%" /v SystemResponsiveness /d 20 /t REG_DWORD /f
REG DELETE HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config /v AutoConnectAllowedOEM /f >NUL 2>&1
REG DELETE HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched /V NonBestEffortLimit /f >NUL 2>&1
REG DELETE HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\PSched /V NonBestEffortLimit /f >NUL 2>&1
Reg DELETE "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /f >NUL 2>&1
Reg DELETE "HKLM\SYSTEM\ControlSet001\Services\Tcpip\QoS" /v "Do not use NLA" /f >NUL 2>&1
Call :NagleON
Powershell.exe Disable-NetAdapterLso -Name *
Powershell.exe Enable-NetAdapterChecksumOffload -Name *
netsh interface ipv4 set subinterface "%interface%" mtu=1500 store=persistent
CLS
ECHO  * Se han reestablecido correctamente los valores por defecto *
GOTO SUCCESS

:SUCCESS
netsh int tcp show global
ECHO.
ECHO.
@PAUSE
GOTO MENU2

:WifiPropiedades
FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
FOR %%b IN (0 00 000) DO (
SET "Tj1=%%b%%a"
Call :MostrarD
 )
 )
set "n= ¤ "
set "n=%n:~2,1%"
start mshta.exe vbscript:Execute("MsgBox (""[802.11b Preamble] se recomienda Long & Short, pero si tienes buen internet o pocos PCs en red pon Long Only.""+Chr(13)+Chr(13)+""[AdHoc 11n] Enable para una conexion mas rapida en redes Adhoc(WiFi desde otro PC o Celular). Por defecto -> Disable""+Chr(13)+Chr(13)+""[Trasmit, Receive, Scan Interval] al maximo mejora la se%n%al.""+Chr(13)+""Por defecto -> Receive=256, Trasmit=512, Scan=60""),vbQuestion,""Instrucciones para el WI-FI --> (Opciones avanzadas)"":close")
GOTO Inicio
 
:MostrarD
CLS
SET "holita="
FOR /F "tokens=3" %%a in ('REG QUERY HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%Tj1% /v DriverDesc ^| findstr "Wireless"') do SET "holita=%%b"
IF "%holita%"=="" GOTO:EOF
cls
FOR /F "tokens=2* skip=2" %%a in ('REG QUERY HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%Tj1% /v DeviceInstanceID') do SET "Hola=%%b"
IF NOT "%hola%"=="" Start rundll32.exe devmgr.dll,DeviceProperties_RunDLL /DeviceID "%hola%" >NUL 2>NUL
GOTO:EOF

:IPV6Enable
SET "z1=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
SET "z2=DisabledComponents"
CLS
Echo Activando Protocolo IPV6...
reg delete %z1% /v %z2% /f >NUL 2>&1
powershell.exe Enable-NetAdapterBinding -Name * -ComponentID ms_tcpip6
CLS
Echo  * Soporte IPV6 Activado Correctamente *
Echo Nota: los cambios surtiran efectos luego del reinicio.
Echo.
PAUSE
GOTO Menu2

:IPV6Disable
SET "z1=HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
SET "z2=DisabledComponents"
CLS
reg add %z1% /v %z2% /t REG_DWORD /d 0xFF /f
CLS
Echo * IPV6 Desactivado Correctamente *
Echo Nota: los cambios surtiran efectos luego del reinicio.
Echo.
PAUSE
GOTO Menu2

:CalcularMTU
SET MTU=1500
CLS
Echo Calculando y Ajustando el Valor Correcto de MTU
netsh interface ipv4 set subinterface "%interface%" mtu=1500 store=persistent
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
set /a MTU=32
set /a STEP=750
set /a STROKES_LIMIT=30
set /a PACKETS_HEADER=28
set HOST_1=8.8.8.8
set HOST_2=1.1.1.1
for %%H in (%HOST_1% %HOST_2%) do (
	set host=%%H
	call:probe
	if !RESULT! == "0" (
		set HOSTGOOD="1"
		echo Exito, se pudo hacer ping a !host!
		echo.
		goto got
	) else (
		set HOSTGOOD="0"
	)
)
:got
if %HOSTGOOD% NEQ "1" (
SET mtu=1500
Call :MTUPantalla
GOTO:EOF
)
set /a MTU=STEP
set /a STROKES=0
:do
	set /a STEP=STEP-STEP/2
	call:probe
	if %RESULT% == "0" (
		if  "%MTU%" == "%MTU_LASTGOOD%" (
			goto done
		) else (
			set /a MTU_LASTGOOD=MTU
			set /a MTU=MTU+STEP
		)
	) else (
		set /a MTU=MTU-STEP
	)
	set /a STROKES=STROKES+1
if %STROKES% LSS %STROKES_LIMIT% (
	goto do
) else (
SET mtu=1500
Call :MTUPantalla
GOTO:EOF
)
:done
set /a MTU=MTU+PACKETS_HEADER
IF %MTU% LSS 576 SET MTU=576
Call :MTUPantalla
GOTO:EOF

:probe
if %host% NEQ "" (
	echo Enviando %MTU% bytes a %host%
	ping -f -l %MTU% -n "1" %host% >NUL
		if errorlevel 1 (
			echo ....... Fragmentado
			set RESULT="1"
		) else (
			echo ....... Contiguo
			set RESULT="0"
		)
echo.
)
goto:eof

:MTUPantalla
CLS
netsh interface ipv4 set subinterface "%interface%" mtu=%MTU% store=persistent
CLS
netsh interface ipv4 show subinterfaces
Echo.
Echo  El valor de MTU de tu %interface% a sido ajustado a %MTU%
Echo.
Echo  Puse cualquier tecla para continuar...
PAUSE >NUL
Goto:EOF

:NagleOFF
setlocal
for /f "usebackq" %%i in (`reg query HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces`) do (
  reg add %%i /v "TcpAckFrequency" /d "1" /t REG_DWORD /f
  reg add %%i /v "TCPNoDelay" /d "1" /t REG_DWORD /f
  reg add %%i /v "TcpDelAckTicks" /d "0" /t REG_DWORD /f
  )
reg add HKLM\SOFTWARE\Microsoft\MSMQ\Parameters /v "TCPNoDelay" /d "1" /t REG_DWORD /f
GOTO:EOF

:NagleON
for /f "usebackq" %%i in (`reg query HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces`) do (
  reg delete %%i /v "TcpAckFrequency" /f >NUL 2>NUL
  reg delete %%i /v "TCPNoDelay" /f >NUL 2>NUL
  reg delete %%i /v "TcpDelAckTicks" /f >NUL 2>NUL
  )
reg delete HKLM\SOFTWARE\Microsoft\MSMQ\Parameters /v "TCPNoDelay" /f
GOTO:EOF

:ModoDepDesactivado
CLS
Echo Desactivando todas las mitigaciones...
bcdedit.exe /set nx AlwaysOff
bcdedit.exe /set {current} nx AlwaysOff
bcdedit /deletevalue numproc
bcdedit /deletevalue {current} numproc
bcdedit /deletevalue useplatformclock
bcdedit /deletevalue {current} useplatformclock
bcdedit /deletevalue tscsyncpolicy
bcdedit /deletevalue {current} tscsyncpolicy
bcdedit /deletevalue vsmlaunchtype
bcdedit /deletevalue {current} vsmlaunchtype
Echo. 
ECHO  * Reinicie PC para que los cambios surtan efecto. - PRESIONA ENTER *
ECHO.
ECHO.
@PAUSE
Goto Menu2

:ModoDepActivado
CLS
Echo Activando todas las mitigaciones...
bcdedit.exe /set nx AlwaysOn
bcdedit.exe /set {current} nx AlwaysOn
bcdedit /set useplatformclock on
bcdedit /set {current} useplatformclock on
bcdedit /set tscsyncpolicy Enhanced
bcdedit /set {current} tscsyncpolicy Enhanced
bcdedit /set vsmlaunchtype auto
bcdedit /set {current} vsmlaunchtype auto
Echo. 
ECHO  * Reinicie PC para que los cambios surtan efecto. - PRESIONA ENTER *
ECHO.
ECHO.
@PAUSE
Goto Menu2

:HabilitarProxy
CLS
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d %Puerta%:3128 /f >NUL
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyEnable /t REG_DWORD /d 0x1 >NUL
gpupdate /force
GOTO:EOF

:DeshabilitarProxy
CLS
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
gpupdate /force
GOTO:EOF