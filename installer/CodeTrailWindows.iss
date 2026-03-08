#define AppName "CodeTrail Windows"
#define AppPublisher "Gabriel Contesini"
#define AppExeName "CodeTrailWindows.exe"
#define AppVersion "__APP_VERSION__"
#define AppSourceDir "__APP_SOURCE_DIR__"

[Setup]
AppId={{0C27A87D-3AB8-43D6-89B6-E1B09F3B9EE7}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\CodeTrail Windows
DefaultGroupName=CodeTrail Windows
OutputDir=..\artifacts\installer
OutputBaseFilename=CodeTrailWindows-{#AppVersion}-setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExeName}

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
Source: "{#AppSourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\CodeTrail Windows"; Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\{#AppExeName}"
Name: "{autodesktop}\CodeTrail Windows"; Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\{#AppExeName}"

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Abrir CodeTrail Windows"; Flags: nowait postinstall skipifsilent
