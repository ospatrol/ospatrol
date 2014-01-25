;--------------------------------
;Include Modern UI

!include "MUI.nsh"

;--------------------------------
;General

!define MUI_ICON favicon.ico
!define MUI_UNICON ospatrol-uninstall.ico
!define VERSION "2.7.2-beta"
!define NAME "OSPatrol"
!define /date CDATE "%b %d %Y at %H:%M:%S"

Name "${NAME} Windows Agent v${VERSION}"
BrandingText "Copyright (C) 2003 - 2013 Trend Micro Inc."
OutFile "ospatrol-win32-agent.exe"

InstallDir "$PROGRAMFILES\ospatrol-agent"
InstallDirRegKey HKLM Software\OSPatrol ""

;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING

;--------------------------------
;Pages
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the install of ${Name}.\r\n\r\nClick next to continue."
  !define MUI_FINISHPAGE_TITLE_3LINES
  !define MUI_FINISHPAGE_RUN "$INSTDIR\win32ui.exe"
  !define  MUI_FINISHPAGE_RUN_TEXT "Run OSPatrol Agent Manager"

  ; Page for choosing components.
  !define MUI_COMPONENTSPAGE_TEXT_TOP "Select the options you want to be executed. Click next to continue."
  !define MUI_COMPONENTSPAGE_NODESC

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  ; These have to be defined again to work with the uninstall pages
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_FINISHPAGE_TITLE_3LINES
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Function to stop OSPatrol service if running

Function .onInit
    IfFileExists $INSTDIR\ospatrol.conf 0 +3
    MessageBox MB_OKCANCEL "${NAME} is already installed. It will be stopped before continuing." /SD IDOK IDOK NoAbort
    Abort
    NoAbort:

   ;; Stopping ospatrol service.
   nsExec::ExecToStack '"net" "stop" "OSPatrolSvc"'
FunctionEnd

;--------------------------------
;Main install section

Section "OSPatrol Agent (required)" MainSec

SectionIn RO
SetOutPath $INSTDIR

ClearErrors

File \
ospatrol-agent.exe \
default-ospatrol.conf \
manage_agents.exe \
os_win32ui.exe \
ospatrol-rootcheck.exe \
internal_options.conf \
setup-windows.exe \
setup-syscheck.exe \
setup-iis.exe \
service-start.exe \
service-stop.exe \
doc.html \
rootkit_trojans.txt \
rootkit_files.txt \
add-localfile.exe \
LICENSE.txt \
rootcheck\rootcheck.conf \
rootcheck\db\win_applications_rcl.txt \
rootcheck\db\win_malware_rcl.txt \
rootcheck\db\win_audit_rcl.txt \
help.txt \
vista_sec.csv \
route-null.cmd \
restart-ospatrol.cmd

WriteRegStr HKLM SOFTWARE\ospatrol "Install_Dir" "$INSTDIR"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "DisplayName" "${NAME} ${VERSION}"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "DisplayVersion" "${VERSION}"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "DisplayIcon" "${MUI_ICON}"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "HelpLink" "http://ospatrol.com/go/help-win"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "URLInfoAbout" "http://ospatrol.com"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "UninstallString" '"$INSTDIR\uninstall.exe"'
WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "NoModify" 1
WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol" "NoRepair" 1
WriteUninstaller "uninstall.exe"

; Writing version and install information
FileOpen $0 $INSTDIR\VERSION.txt w
IfErrors done
FileWrite $0 "${NAME} v${VERSION} - "
FileWrite $0 "Installed on ${CDATE}"
FileClose $0
done:

CreateDirectory "$INSTDIR\rids"
CreateDirectory "$INSTDIR\syscheck"
CreateDirectory "$INSTDIR\shared"
CreateDirectory "$INSTDIR\active-response"
CreateDirectory "$INSTDIR\active-response\bin"
Delete "$INSTDIR\active-response\bin\route-null.cmd"
Delete "$INSTDIR\active-response\bin\restart-ospatrol.cmd"
Rename "$INSTDIR\rootkit_trojans.txt" "$INSTDIR\shared\rootkit_trojans.txt"
Rename "$INSTDIR\rootkit_files.txt" "$INSTDIR\shared\rootkit_files.txt"
Rename "$INSTDIR\win_malware_rcl.txt" "$INSTDIR\shared\win_malware_rcl.txt"
Rename "$INSTDIR\win_audit_rcl.txt" "$INSTDIR\shared\win_audit_rcl.txt"
Rename "$INSTDIR\win_applications_rcl.txt" "$INSTDIR\shared\win_applications_rcl.txt"
Rename "$INSTDIR\route-null.cmd" "$INSTDIR\active-response\bin\route-null.cmd"
Rename "$INSTDIR\restart-ospatrol.cmd" "$INSTDIR\active-response\bin\restart-ospatrol.cmd"
Rename "$INSTDIR\os_win32ui.exe" "$INSTDIR\win32ui.exe"
Delete "$SMPROGRAMS\OSPATROL\Edit.lnk"
Delete "$SMPROGRAMS\OSPATROL\Uninstall.lnk"
Delete "$SMPROGRAMS\OSPATROL\Documentation.lnk"
Delete "$SMPROGRAMS\OSPATROL\Edit Config.lnk"
Delete "$SMPROGRAMS\OSPATROL\*.*"

; Remove start menu entry.
RMDir "$SMPROGRAMS\OSPATROL"

; Creating start menu directory
CreateDirectory "$SMPROGRAMS\OSPATROL"
CreateShortCut "$SMPROGRAMS\OSPATROL\Manage Agent.lnk" "$INSTDIR\win32ui.exe" "" "$INSTDIR\win32ui.exe" 0
CreateShortCut "$SMPROGRAMS\OSPATROL\Documentation.lnk" "$INSTDIR\doc.html" "" "$INSTDIR\doc.html" 0
CreateShortCut "$SMPROGRAMS\OSPATROL\Edit Config.lnk" "$INSTDIR\ospatrol.conf" "" "$INSTDIR\ospatrol.conf" 0
CreateShortCut "$SMPROGRAMS\OSPATROL\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0

; Install in the services  (perhaps it would be better to use a plug-in here?)
;nsExec::ExecToStack '"$INSTDIR\ospatrol-agent.exe" install-service'
ExecWait '"$INSTDIR\ospatrol-agent.exe" install-service'
;nsExec::ExecToStack '"$INSTDIR\setup-windows.exe" "$INSTDIR"'
ExecWait '"$INSTDIR\setup-windows.exe" "$INSTDIR"'

SectionEnd

Section "Scan and monitor IIS logs (recommended)" IISLogs

nsExec::ExecToStack '"$INSTDIR\setup-iis.exe" "$INSTDIR"'

SectionEnd

Section "Enable integrity checking (recommended)" IntChecking

nsExec::ExecToStack '"$INSTDIR\setup-syscheck.exe" "$INSTDIR" "enable"'

SectionEnd

;--------------------------------
;Uninstall section
Section "Uninstall"

  ;Need a step to check for a running agent manager, otherwise it and the INSTDIR directory will not be removed.

  ; Stop ospatrol. Perhaps we should look for an exit status here. Also, may be a good place to use a plug-in.
  nsExec::ExecToStack '"net" "stop" "OSPatrolSvc"'

  ; Uninstall from the services. Again, maybe use a plugin here.
  nsExec::ExecToStack '"$INSTDIR\ospatrol-agent.exe" uninstall-service'

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OSPatrol"
  DeleteRegKey HKLM SOFTWARE\OSPatrol

  ; Remove files and uninstaller. There have been instances where the ospatrol-agent directory and executable is left. Why?
  Delete "$INSTDIR\ospatrol-agent.exe"
  Delete "$INSTDIR\manage_agents.exe"
  Delete "$INSTDIR\ospatrol.conf"
  Delete "$INSTDIR\uninstall.exe"
  Delete "$INSTDIR\*"
  Delete "$INSTDIR\rids\*"
  Delete "$INSTDIR\syscheck\*"
  Delete "$INSTDIR\shared\*"
  Delete "$INSTDIR\active-response\bin\*"
  Delete "$INSTDIR\active-response\*"
  Delete "$INSTDIR"

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\OSPATROL\*.*"
  Delete "$SMPROGRAMS\OSPATROL\*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\OSPATROL"
  RMDir "$INSTDIR\shared"
  RMDir "$INSTDIR\syscheck"
  RMDir "$INSTDIR\rids"
  RMDir "$INSTDIR\active-response\bin"
  RMDir "$INSTDIR\active-response"
  RMDir "$INSTDIR"

SectionEnd
