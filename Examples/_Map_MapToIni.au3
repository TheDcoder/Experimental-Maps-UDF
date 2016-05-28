#include "..\Map.au3"
#include <File.au3>
#include <FileConstants.au3>

Example()

Func Example()
	Local $sTempFile = _TempFile(@TempDir, '_Map_MapToIni Example ~ ', '.ini') ; Decide the name of the temp Ini file
	FileClose(FileOpen($sTempFile, $FO_APPEND)) ; Create the temp Ini file
	Local $mIniFile[] ; This map will store the contents of our Ini file
	Local $mSectionInIni[] ; This map will store the contents of a section in our Ini file

	$mSectionInIni["Primary"] = "Foo"
	$mSectionInIni["Secondary"] = "Bar"
	$mSectionInIni["Tertiary"] = "Baz"
	$mSectionInIni["Quaternary"] = "Qux"
	$mSectionInIni["Quinary"] = "Norf"

	$mIniFile["Placeholders"] = $mSectionInIni ; This section is called "Placeholders"
	_Map_MapToIni($mIniFile, $sTempFile)
	ShellExecuteWait($sTempFile)

	$mIniFile = _Map_IniToMap($sTempFile)

	FileDelete($sTempFile) ; Delete the Temp File
EndFunc