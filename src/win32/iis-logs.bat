@echo off

rem Searching for IIS logs.
rem If we find any log in the NCSA or W3C extended format, 
rem change the config to support that. If not, let the user know.
rem Example of log to look: nc060215.log or ex060723.log

echo.
echo Looking for IIS log files to monitor.
echo For more information visit:
echo http://ospatrol.com/go/win-iis
echo.
echo.

IF EXIST %WinDir%\System32\LogFiles\W3SVC1\nc??????.log (
    echo    * IIS NCSA log found. Changing config to read it.
    echo.  >> ospatrol.conf
    echo ^<ospatrol_config^> >> ospatrol.conf
    echo   ^<localfile^> >> ospatrol.conf
    echo     ^<location^>%WinDir%\System32\LogFiles\W3SVC1\nc%%y%%m%%d.log^</location^> >> ospatrol.conf
    echo     ^<log_format^>iis^</log_format^> >> ospatrol.conf 
    echo   ^</localfile^> >> ospatrol.conf
    echo ^</ospatrol_config^> >> ospatrol.conf
    pause
    )

IF EXIST %WinDir%\System32\LogFiles\W3SVC1\ex??????.log (
    echo    * IIS W3C extended log found. Changing config to read it.
    echo.  >> ospatrol.conf
    echo ^<ospatrol_config^> >> ospatrol.conf
    echo   ^<localfile^> >> ospatrol.conf
    echo     ^<location^>%WinDir%\System32\LogFiles\W3SVC1\ex%%y%%m%%d.log^</location^> >> ospatrol.conf
    echo     ^<log_format^>iis^</log_format^> >> ospatrol.conf
    echo   ^</localfile^> >> ospatrol.conf
    echo ^</ospatrol_config^> >> ospatrol.conf
    pause
    )

IF EXIST %WinDir%\System32\LogFiles\W3SVC3\ex??????.log (
    echo    * IIS W3C extended log found. Changing config to read it.
    echo.  >> ospatrol.conf
    echo ^<ospatrol_config^> >> ospatrol.conf
    echo   ^<localfile^> >> ospatrol.conf
    echo     ^<location^>%WinDir%\System32\LogFiles\W3SVC3\nc%%y%%m%%d.log^</location^> >> ospatrol.conf
    echo     ^<log_format^>iis^</log_format^> >> ospatrol.conf
    echo   ^</localfile^> >> ospatrol.conf
    echo ^</ospatrol_config^> >> ospatrol.conf
    pause
    )

IF EXIST %WinDir%\System32\LogFiles\W3SVC1 (
    echo    * IIS Log found. Look at the link above if you want to monitor it.
    pause
    exit )

rem EOF

