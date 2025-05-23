; Lunexa Alpha GUI Wallet Installer for Windows
; Copyright (c) 2017-2020, The Monero Project
; See LICENSE
#define GuiVersion GetFileVersion("bin\lunexa-wallet-gui.exe")

[Setup]
AppName=Lunexa GUI Wallet
; For InnoSetup this is the property that uniquely identifies the application as such
; Thus it's important to keep this stable over releases
; With a different "AppName" InnoSetup would treat a mere update as a completely new application and thus mess up

AppVersion={#GuiVersion}
VersionInfoVersion={#GuiVersion}
DefaultDirName={commonpf}\Lunexa GUI Wallet
DefaultGroupName=Lunexa GUI Wallet
UninstallDisplayIcon={app}\lunexa-wallet-gui.exe
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64 arm64
WizardSmallImageFile=WizardSmallImage.bmp
WizardImageFile=WelcomeImage.bmp
DisableWelcomePage=no
LicenseFile=LICENSE
AppPublisher=The Lunexa Project
AppPublisherURL=https://lunexa.co
TimeStampsInUTC=yes
CompressionThreads=1

UsedUserAreasWarning=no
; The above directive silences the following compiler warning:
;    Warning: The [Setup] section directive "PrivilegesRequired" is set to "admin" but per-user areas (HKCU,userdocs)
;    are used by the script. Regardless of the version of Windows, if the installation is administrative then you should
;    be careful about making any per-user area changes: such changes may not achieve what you are intending.
; Background info:
; This installer indeed asks for admin rights so the Lunexa files can be copied to a place where they have at least
; a minimum of protection against changes, e.g. by malware, plus it handles things for the currently logged-in user
; in the registry (GUI wallet per-user options) and for some of the icons. For reasons too complicated to fully explain
; here this does not work as intended if the installing user does not have admin rights and has to provide the password
; of a user that does for installing: The settings of the admin user instead of those of the installing user are changed.
; Short of ripping out that per-user functionality the issue has no suitable solution. Fortunately, this will probably
; play a role in only in few cases as the first standard user in a Windows installation does have admin rights.
; So, for the time being, this installer simply disregards this problem.

[Messages]
SetupWindowTitle=%1 {#GuiVersion} Installer

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
; Without localized versions of special forms, messages etc. of the installer, and without translated ReadMe's
; it probably does not make much sense to offer other install-time languages beside English
; Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
; Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
; Name: "jp"; MessagesFile: "compiler:Languages\Japanese.isl"
; Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
; Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"

[Dirs]
Name: "{app}";
Name: "{app}\p2pool"; Permissions: users-full

[Files]
; The use of the flag "ignoreversion" for the following entries leads to the following behaviour:
; When updating / upgrading an existing installation ALL existing files are replaced with the files in this
; installer, regardless of file dates, version info within the files, or type of file (textual file or
; .exe/.dll file possibly with version info).
;
; This is far more robust than relying on version info or on file dates (flag "comparetimestamp").
; The only small drawback seems to be somewhat longer update times because each and every file is
; copied again, even if already present with correct file date and identical content.
;
; Note that it would be very dangerous to use "ignoreversion" on files that may be shared with other
; applications somehow. Luckily this is no issue here because ALL files are "private" to Lunexa.

Source: {#file AddBackslash(SourcePath) + "ReadMe.htm"}; DestDir: "{app}"; DestName: "ReadMe.htm"; Flags: ignoreversion
Source: "FinishImage.bmp"; Flags: dontcopy
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

; Lunexa GUI wallet exe and guide
Source: "bin\lunexa-wallet-gui.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\lunexa-gui-wallet-guide.pdf"; DestDir: "{app}"; Flags: ignoreversion

; Lunexa CLI wallet
Source: "bin\extras\lunexa-wallet-cli.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-gen-trusted-multisig.exe"; DestDir: "{app}"; Flags: ignoreversion

; Lunexa wallet RPC interface implementation
Source: "bin\extras\lunexa-wallet-rpc.exe"; DestDir: "{app}"; Flags: ignoreversion

; Lunexa daemon
Source: "bin\lunexad.exe"; DestDir: "{app}"; Flags: ignoreversion

; Lunexa daemon wrapped in a batch file that stops before the text window closes, to see any error messages
Source: "lunexa-daemon.bat"; DestDir: "{app}"; Flags: ignoreversion;

; Lunexa blockchain utilities
Source: "bin\extras\lunexa-blockchain-export.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-import.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-mark-spent-outputs.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-usage.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-import.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-ancestry.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-depth.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-prune-known-spent-data.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-prune.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-blockchain-stats.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\extras\lunexa-gen-ssl-cert.exe"; DestDir: "{app}"; Flags: ignoreversion

; Qt Quick 2D Renderer fallback for systems / environments with "low-level graphics" i.e. without 3D support
Source: "bin\start-low-graphics-mode.bat"; DestDir: "{app}"; Flags: ignoreversion

; Mesa, open-source OpenGL implementation; part of "low-level graphics" support
Source: "bin\opengl32sw.dll"; DestDir: "{app}"; Flags: ignoreversion


; Delete any files and directories that were installed by previous installer versions but are not
; needed anymore, thanks to the static linking of the GUI wallet exe - all those things are now
; neatly contained in that single exe file;
; InnoSetup does NOT automatically delete objects not present anymore in a new version.
; Deleting them is simpler and faster than forcing a full re-install.
[InstallDelete]
Type: filesandordirs; Name: "{app}\translations"
Type: files; Name: "{app}\Qt5*.dll"
Type: filesandordirs; Name: "{app}\Qt"
Type: filesandordirs; Name: "{app}\audio"
Type: filesandordirs; Name: "{app}\bearer"
Type: filesandordirs; Name: "{app}\platforms"
Type: filesandordirs; Name: "{app}\platforminputcontexts"
Type: filesandordirs; Name: "{app}\iconengines"
Type: filesandordirs; Name: "{app}\imageformats"
Type: filesandordirs; Name: "{app}\QtMultimedia"
Type: filesandordirs; Name: "{app}\mediaservice"
Type: filesandordirs; Name: "{app}\playlistformats"
Type: filesandordirs; Name: "{app}\QtGraphicalEffects"
Type: filesandordirs; Name: "{app}\private"
Type: filesandordirs; Name: "{app}\QtQml"
Type: filesandordirs; Name: "{app}\QtQuick"
Type: filesandordirs; Name: "{app}\QtQuick.2"
Type: filesandordirs; Name: "{app}\Material"
Type: filesandordirs; Name: "{app}\Universal"
Type: filesandordirs; Name: "{app}\scenegraph"
Type: filesandordirs; Name: "{app}\p2pool"
Type: files; Name: "{app}\D3Dcompiler_47.dll"
Type: files; Name: "{app}\libbz2-1.dll"
Type: files; Name: "{app}\libEGL.dll"
Type: files; Name: "{app}\libGLESV2.dll"
Type: files; Name: "{app}\libfreetype-6.dll"
Type: files; Name: "{app}\libgcc_s_seh-1.dll"
Type: files; Name: "{app}\libglib-2.0-0.dll"
Type: files; Name: "{app}\libgraphite2.dll"
Type: files; Name: "{app}\libharfbuzz-0.dll"
Type: files; Name: "{app}\libiconv-2.dll"
Type: files; Name: "{app}\libicudt??.dll"
Type: files; Name: "{app}\libicuin??.dll"
Type: files; Name: "{app}\libicuio??.dll"
Type: files; Name: "{app}\libicutu??.dll"
Type: files; Name: "{app}\libicuuc??.dll"
Type: files; Name: "{app}\libintl-8.dll"
Type: files; Name: "{app}\libjpeg-8.dll"
Type: files; Name: "{app}\liblcms2-2.dll"
Type: files; Name: "{app}\liblzma-5.dll"
Type: files; Name: "{app}\libmng-2.dll"
Type: files; Name: "{app}\libmd4c.dll"
Type: files; Name: "{app}\libpcre-1.dll"
Type: files; Name: "{app}\libpcre16-0.dll"
Type: files; Name: "{app}\libpcre2-16-0.dll"
Type: files; Name: "{app}\libpcre2-8-0.dll"
Type: files; Name: "{app}\libpng16-16.dll"
Type: files; Name: "{app}\libstdc++-6.dll"
Type: files; Name: "{app}\libtiff-5.dll"
Type: files; Name: "{app}\libunbound-8.dll"
Type: files; Name: "{app}\libwinpthread-1.dll"
Type: files; Name: "{app}\zlib1.dll"
Type: files; Name: "{app}\libhidapi-0.dll"
Type: files; Name: "{app}\libeay32.dll"
Type: files; Name: "{app}\ssleay32.dll"
Type: files; Name: "{app}\start-high-dpi.bat"
Type: files; Name: "{group}\Utilities\x (Check Blockchain Folder).lnk"


[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:";


[Run]
Filename: "{app}\ReadMe.htm"; Description: "Show ReadMe"; Flags: postinstall shellexec skipifsilent

; DON'T offer to run the wallet right away, let the people read about initial blockchain download first in the ReadMe
; Filename: "{app}\lunexa-wallet-gui.exe"; Description: "Run GUI Wallet now"; Flags: postinstall nowait skipifsilent


[Code]
var
  BlockChainDirPage: TInputDirWizardPage;
  blockChainDefaultDir: String;

procedure InitializeWizard;
var s: String;
    blockChainDir: String;
begin
  // Large image for the "Welcome" page, with page reconfigured
  WizardForm.WelcomeLabel1.Visible := false;
  WizardForm.WelcomeLabel2.Visible := false;
  WizardForm.WizardBitmapImage.Height := 300;
  WizardForm.WizardBitmapImage.Width := 500;

  // Image for the "Finnish" screen, in standard WizardBitmapImage size of 164 x 314
  ExtractTemporaryFile('FinishImage.bmp');
  WizardForm.WizardBitmapImage2.Bitmap.LoadFromFile(ExpandConstant('{tmp}\FinishImage.bmp'));

  // Additional wizard page for entering a special blockchain location
  blockChainDefaultDir := ExpandConstant('{commonappdata}\bitlunexa');
  s := 'The default folder to store the Lunexa blockchain is ' + blockChainDefaultDir;
  s := s + '. As this will need more than 90 GB of free space, you may want to use a folder on a different drive.';
  s := s + ' If yes, specify that folder here.';

  BlockChainDirPage := CreateInputDirPage(wpSelectDir,
    'Select Blockchain Directory', 'Where should the blockchain be installed?',
    s,
    False, '');
  BlockChainDirPage.Add('');

  // Evaluate proposal for the blockchain location
  // In case of an update take the blockchain location from the actual setting in the registry
  RegQueryStringValue(HKEY_CURRENT_USER, 'Software\lunexa-project\lunexa', 'blockchainDataDir', blockChainDir);
  if blockChainDir = '' then begin
    blockChainDir := GetPreviousData('BlockChainDir', '');
  end;
  if blockChainDir = '' then begin
    // Unfortunately 'TInputDirWizardDirPage' does not allow empty field, so "propose" Lunexa default location
    blockChainDir := blockChainDefaultDir;
  end;
  BlockChainDirPage.Values[0] := blockChainDir;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  // Store the selected folder for further reinstall/upgrade
  SetPreviousData(PreviousDataKey, 'BlockChainDir', BlockChainDirPage.Values[0]);
end;

function BlockChainDir(Param: String) : String;
// Directory of the blockchain
var s: String;
begin
  s := BlockChainDirPage.Values[0];
  Result := s;
  // No quotes for folder name with blanks as this is never used as part of a command line
end;

function BlockChainDirOrEmpty(Param: String) : String;
VAR s: String;
begin
  s := BlockChainDir('');
  if s = blockChainDefaultDir then begin
    // No need to add the default dir as setting
    s := '';
  end;
  Result := s;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var s: String;
begin
  // Fill the 'Ready Memo' with the normal settings and the custom settings
  s := '';
  s := s + MemoDirInfo + NewLine + NewLine;

  s := s + 'Blockchain folder' + NewLine;
  s := s + Space + BlockChainDir('') + NewLine;

  Result := s;
end;

function DaemonLog(Param: String) : String;
// Full filename of the log of the daemon
begin
  Result := BlockChainDir('') + '\bitlunexa.log';
  // No quotes for filename with blanks as this is never used as part of a command line
end;

function DaemonFlags(Param: String): String;
// Flags to add to the shortcut to the daemon
var s: String;
begin
  s := BlockChainDir('');
  if s = blockChainDefaultDir then begin
    // No need to add the default dir as flags for the daemon
    s := '';
  end;
  if Pos(' ', s) > 0 then begin
    // Quotes needed for filename with blanks
    s := '"' + s + '"';
  end;
  if s <> '' then begin
    s := '--data-dir ' + s;
  end;
  Result := s;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var s: TArrayOfString;
begin
  if CurStep = ssPostInstall then begin
    // Re-build "lunexa-daemon.bat" according to actual install and blockchain directory used
    SetArrayLength(s, 3);
    s[0] := 'REM Execute the Lunexa daemon and then stay with window open after it exits';
    s[1] := '"' + ExpandConstant('{app}\lunexad.exe') + '" ' + DaemonFlags('');
    s[2] := 'PAUSE';
    SaveStringsToFile(ExpandConstant('{app}\lunexa-daemon.bat'), s, false); 
  end;
end;

function InitializeUninstall(): Boolean;
var s: String;
begin
  s := 'Please note: Uninstall will not delete any downloaded blockchain. ';
  s := s + 'If you do not need it anymore you have to delete it manually.';
  s := s + #13#10#13#10 + 'Uninstall will not delete any wallets that you created either.';
  MsgBox(s, mbInformation, MB_OK);
  Result := true;
end;


[Icons]
; Icons in the "Lunexa GUI Wallet" program group
; Windows will almost always display icons in alphabetical order, per level, so specify the text accordingly
Name: "{group}\GUI Wallet"; Filename: "{app}\lunexa-wallet-gui.exe";
Name: "{group}\GUI Wallet Guide"; Filename: "{app}\lunexa-gui-wallet-guide.pdf"; IconFilename: "{app}\lunexa-wallet-gui.exe"
Name: "{group}\Uninstall GUI Wallet"; Filename: "{uninstallexe}"

; Sub-folder "Utilities";
; Note that Windows 10, unlike Windows 7, ignores such sub-folders completely
; and insists on displaying ALL icons on one single level
Name: "{group}\Utilities\Lunexa Daemon"; Filename: "{app}\lunexad.exe"; Parameters: {code:DaemonFlags}
Name: "{group}\Utilities\Read Me"; Filename: "{app}\ReadMe.htm"

; CLI wallet: Needs a working directory ("Start in:") set in the icon, because with no such directory set
; it tries to create new wallets without a path given in the probably non-writable program folder and will abort with an error
Name: "{group}\Utilities\Textual (CLI) Wallet"; Filename: "{app}\lunexa-wallet-cli.exe"; WorkingDir: "{userdocs}\Lunexa\wallets"

; Icons for troubleshooting problems / testing / debugging
; To show that they are in some way different (not for everyday use), make them visually different
; from the others by text, and make them sort at the end by the help of "x" in front 
Name: "{group}\Utilities\x (Check Default Blockchain Folder)"; Filename: "{win}\Explorer.exe"; Parameters: {code:BlockChainDir}
Name: "{group}\Utilities\x (Check Daemon Log)"; Filename: "Notepad"; Parameters: {code:DaemonLog}
Name: "{group}\Utilities\x (Check Default Wallet Folder)"; Filename: "{win}\Explorer.exe"; Parameters: """{userdocs}\Lunexa\wallets"""
Name: "{group}\Utilities\x (Check GUI Wallet Log)"; Filename: "Notepad"; Parameters: """{userappdata}\lunexa-wallet-gui\lunexa-wallet-gui.log"""
Name: "{group}\Utilities\x (Try Daemon, Exit Confirm)"; Filename: "{app}\lunexa-daemon.bat"
Name: "{group}\Utilities\x (Try GUI Wallet Low Graphics Mode)"; Filename: "{app}\start-low-graphics-mode.bat"
Name: "{group}\Utilities\x (Try Kill Daemon)"; Filename: "Taskkill.exe"; Parameters: "/IM lunexad.exe /T /F"

; Desktop icons, optional with the help of the "Task" section
Name: "{commondesktop}\GUI Wallet"; Filename: "{app}\lunexa-wallet-gui.exe"; Tasks: desktopicon


[Registry]
; Store any special flags for the daemon in the registry location where the GUI wallet will take it from
; So if the wallet is used to start the daemon instead of the separate icon the wallet will pass the correct flags
; Side effect, mostly positive: The uninstaller will clean the registry
Root: HKCU; Subkey: "Software\lunexa-project"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\lunexa-project\lunexa"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\lunexa-project\lunexa"; ValueType: string; ValueName: "blockchainDataDir"; ValueData: {code:BlockChainDirOrEmpty};

; Configure a custom URI scheme: Links starting with "lunexa:" will start the GUI wallet exe with the URI as command-line parameter
; Used to easily start payments; example URI: "lunexa://<address>?tx_amount=5.0"
Root: HKCR; Subkey: "lunexa"; ValueType: "string"; ValueData: "URL:Lunexa Payment Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "lunexa"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "lunexa\DefaultIcon"; ValueType: "string"; ValueData: "{app}\lunexa-wallet-gui.exe,0"
Root: HKCR; Subkey: "lunexa\shell\open\command"; ValueType: "string"; ValueData: """{app}\lunexa-wallet-gui.exe"" ""%1"""

; Configure a custom URI scheme: Links starting with "lunexaseed:" will start the GUI wallet exe with the URI as command-line parameter
; Used to easily hand over custom seed node info to the wallet, with an URI of the form "lunexaseed://a.b.c.d:port"
Root: HKCR; Subkey: "lunexaseed"; ValueType: "string"; ValueData: "URL:Lunexa Seed Node Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "lunexaseed"; ValueType: "string"; ValueName: "URL Protocol"; ValueData: ""
Root: HKCR; Subkey: "lunexaseed\DefaultIcon"; ValueType: "string"; ValueData: "{app}\lunexa-wallet-gui.exe,0"
Root: HKCR; Subkey: "lunexaseed\shell\open\command"; ValueType: "string"; ValueData: """{app}\lunexa-wallet-gui.exe"" ""%1"""
