[Setup]
AppName=MiddleClick Utility
AppVersion=1.0
DefaultDirName={autopf}\MiddleClickUtil
DefaultGroupName=MiddleClick Utility
UninstallDisplayName=MiddleClick Utility
UninstallDisplayIcon={app}\MiddleClickUtil.exe
OutputDir=.
OutputBaseFilename=MiddleClickUtilInstaller
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

[Files]
Source: "MiddleClickUtil.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "assets\icon.ico"; DestDir: "{app}"

[Icons]
Name: "{autoprograms}\MiddleClick Utility"; Filename: "{app}\MiddleClickUtil.exe"
Name: "{userstartup}\MiddleClick Utility"; Filename: "{app}\MiddleClickUtil.exe"

[Run]
Filename: "{app}\MiddleClickUtil.exe"; Description: "Launch MiddleClick Utility"; Flags: nowait postinstall

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

