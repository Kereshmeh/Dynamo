; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
[Setup]
AppName=Dynamo 0.7.0
AppVerName=Dynamo 0.7.0
AppPublisher=Autodesk, Inc.
AppID={{6B5FA6CA-9D69-46CF-B517-1F90C64F7C0B}
AppCopyright=
AppPublisherURL=http://www.dynamobim.org
AppSupportURL=
AppUpdatesURL=
AppVersion=0.7.0
VersionInfoVersion=0.7.0
VersionInfoCompany=Autodesk 
VersionInfoDescription=Dynamo 0.7.0
VersionInfoTextVersion=Dynamo 0.7.0
VersionInfoCopyright=
DefaultDirName=C:\Autodesk\Dynamo07\Core
DefaultGroupName=Dynamo
OutputDir=Installers
OutputBaseFilename=InstallDynamo0.7.0
SetupIconFile=Extra\logo_square_32x32.ico
Compression=lzma
SolidCompression=true
RestartIfNeededByRun=false
FlatComponentsList=false
ShowLanguageDialog=auto
DirExistsWarning=no
UninstallFilesDir={app}\Uninstall
UninstallDisplayIcon={app}\logo_square_32x32.ico
UninstallDisplayName=Dynamo 0.7.0
UsePreviousAppDir=no

[Types]
Name: "full"; Description: "Full installation"
Name: "compact"; Description: "Compact installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Dirs]
Name: "{app}\definitions"
Name: "{app}\samples"
Name: "{app}\dll"
Name: "{app}\nodes"

[Components]
Name: "DynamoCore"; Description: "Dynamo Core Functionality"; Types: full compact custom; Flags: fixed
Name: "DynamoForRevit2013"; Description: "Dynamo For Revit 2013"; Types: full compact custom;
Name: "DynamoForRevit2014"; Description: "Dynamo For Revit 2014"; Types: full compact custom;
Name: "DynamoForVasariBeta3"; Description: "Dynamo For Vasari Beta 3"; Types: full compact custom; 
Name: "DynamoTrainingFiles"; Description: "Dynamo Training Files"; Types: full

[Files]
;Core Files
Source: temp\bin\*; DestDir: {app}; Flags: ignoreversion overwritereadonly; Components: DynamoCore
Source: temp\bin\nodes\*; DestDir: {app}\nodes; Flags: ignoreversion overwritereadonly; Components: DynamoCore
Source: Extra\Nodes_32_32.ico; DestDir: {app}; Flags: ignoreversion overwritereadonly; Components: DynamoCore
Source: Extra\README.txt; DestDir: {app}; Flags: isreadme ignoreversion overwritereadonly; Components: DynamoCore
Source: Extra\fsharp_redist.exe; DestDir: {app}; Flags: ignoreversion overwritereadonly; Components: DynamoCore
Source: Extra\IronPython-2.7.3.msi; DestDir: {tmp}; Flags: deleteafterinstall;
Source: Extra\DynamoAddinsRestore.bat; DestDir: {app}; Flags: ignoreversion overwritereadonly; Components: DynamoCore
Source: Extra\DynamoAddinsBackup.bat; DestDir: {app}; Flags: ignoreversion overwritereadonly; Components: DynamoCore

;LibG
Source: temp\bin\LibG\*; DestDir: {app}\dll; Flags: ignoreversion overwritereadonly; Components: DynamoCore
Source: Extra\InstallASMForDynamo.exe; DestDir:{app}; Flags: ignoreversion overwritereadonly; Components: DynamoCore

;UI
Source: temp\bin\UI\*; DestDir: {app}\UI; Flags: ignoreversion overwritereadonly recursesubdirs; Components: DynamoCore

;Samples
Source: temp\Samples\*.*; DestDir: {app}\samples; Flags: ignoreversion overwritereadonly recursesubdirs; Components: DynamoTrainingFiles

[UninstallDelete]
;Keep the old deletion steps for those who installed 0.7.0 before the rename
Type: files; Name: "{commonappdata}\Autodesk\Revit\Addins\2013\Dynamo07.addin"
Type: files; Name: "{commonappdata}\Autodesk\Revit\Addins\2014\Dynamo07.addin"
Type: files; Name: "{commonappdata}\Autodesk\Vasari\Addins\2014\Dynamo07.addin"
Type: files; Name: "{commonappdata}\Autodesk\Revit\Addins\2013\DynamoVersionSelector.addin"
Type: files; Name: "{commonappdata}\Autodesk\Revit\Addins\2014\DynamoVersionSelector.addin"
Type: files; Name: "{commonappdata}\Autodesk\Vasari\Addins\2014\DynamoVersionSelector.addin"
Type: filesandordirs; Name: {app}\dll

[Run]
Filename: "{app}\fsharp_redist.exe"; Parameters: "/q"; Flags: runascurrentuser
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\IronPython-2.7.3.msi"" /qb"; WorkingDir: {tmp};
;Filename: "del"; Parameters: "/q {app}\fsharp_redist.exe"; Flags: postinstall runascurrentuser runhidden
Filename: "{app}\InstallASMForDynamo.exe";
Filename: "{app}\DynamoAddinsBackup.bat";

[UninstallRun]
Filename: "{app}\DynamoAddinsRestore.bat";

[Icons]
Name: "{group}\Dynamo"; Filename: "{app}\DynamoSandbox.exe"

[Code]
{ HANDLE INSTALL PROCESS STEPS }

// added custom uninstall trigger based on http://stackoverflow.com/questions/2000296/innosetup-how-to-automatically-uninstall-previous-installed-version
/////////////////////////////////////////////////////////////////////
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function Revit2014Installed(): Boolean;
begin
   result := FileOrDirExists(ExpandConstant('{commonappdata}\Autodesk\Revit\Addins\2014'));
end;

function Revit2013Installed(): Boolean;
begin
   result := FileOrDirExists(ExpandConstant('{commonappdata}\Autodesk\Revit\Addins\2013'));
end;

function FormItInstalled(): Boolean;
begin
   result := FileOrDirExists(ExpandConstant('{commonappdata}\Autodesk\Vasari\Addins\2014'));
end;

function InitializeSetup(): Boolean;
begin
  if (Revit2014Installed() or Revit2013Installed() or FormItInstalled()) then
    begin
    result := true;
    end
  else
    begin
    MsgBox('Dynamo requires an installation of Revit 2013, Revit 2014, or Vasari Beta 3 in order to proceed!', mbCriticalError, MB_OK);
    result := false;
    end;
end;

/////////////////////////////////////////////////////////////////////
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;


/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

// check if the components exists, if they do enable the component for installation
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpSelectComponents then
    if not FileOrDirExists(ExpandConstant('{commonappdata}\Autodesk\Revit\Addins\2013')) then
    begin
      WizardForm.ComponentsList.Checked[1] := False;
      WizardForm.ComponentsList.ItemEnabled[1] := False;
    end;
	if not FileOrDirExists(ExpandConstant('{commonappdata}\Autodesk\Revit\Addins\2014')) then
    begin
      WizardForm.ComponentsList.Checked[2] := False;
      WizardForm.ComponentsList.ItemEnabled[2] := False;
    end;
	if not FileOrDirExists(ExpandConstant('{commonappdata}\Autodesk\Vasari\Addins\2014')) then
    begin
      WizardForm.ComponentsList.Checked[3] := False;
      WizardForm.ComponentsList.ItemEnabled[3] := False;
    end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  AddInFileContents: String;
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;

  if CurStep = ssPostInstall then
  begin

	{ CREATE NEW ADDIN FILE }
	AddInFileContents := '<?xml version="1.0" encoding="utf-8" standalone="no"?>' + #13#10;
	AddInFileContents := AddInFileContents + '<RevitAddIns>' + #13#10;
	AddInFileContents := AddInFileContents + '  <AddIn Type="Application">' + #13#10;
  AddInFileContents := AddInFileContents + '    <Name>Dynamo For Revit</Name>' + #13#10;
	AddInFileContents := AddInFileContents + '    <Assembly>'  + ExpandConstant('{app}') + '\DynamoRevitVersionSelector.dll</Assembly>' + #13#10;
	AddInFileContents := AddInFileContents + '    <AddInId>8D83C886-B739-4ACD-A9DB-1BC78F315B2B</AddInId>' + #13#10;
	AddInFileContents := AddInFileContents + '    <FullClassName>Dynamo.Applications.VersionLoader</FullClassName>' + #13#10;
	AddInFileContents := AddInFileContents + '  <VendorId>ADSK</VendorId>' + #13#10;
	AddInFileContents := AddInFileContents + '  <VendorDescription>Autodesk, github.com/ikeough/dynamo</VendorDescription>' + #13#10;
	AddInFileContents := AddInFileContents + '  </AddIn>' + #13#10;
  AddInFileContents := AddInFileContents + '</RevitAddIns>' + #13#10;
	
    if (WizardForm.ComponentsList.Checked[1]) then
    begin
      SaveStringToFile(ExpandConstant('{commonappdata}\Autodesk\Revit\Addins\2013\DynamoVersionSelector.addin'), AddInFileContents, False);
    end;
  
    if (WizardForm.ComponentsList.Checked[2]) then
    begin
      SaveStringToFile(ExpandConstant('{commonappdata}\Autodesk\Revit\Addins\2014\DynamoVersionSelector.addin'), AddInFileContents, False);
    end;

    if (WizardForm.ComponentsList.Checked[3]) then
    begin
      SaveStringToFile(ExpandConstant('{commonappdata}\Autodesk\Vasari\Addins\2014\DynamoVersionSelector.addin'), AddInFileContents, False);
    end;

  end;
end;
