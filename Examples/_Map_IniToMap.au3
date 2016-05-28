#include "..\Map.au3"
#include <File.au3>
#include <FileConstants.au3>

Example()

Func Example()
	Local $sTempFile = _TempFile(@TempDir, '_Map_IniToMap Example ~ ', '.ini') ; Decide the name of the temp Ini file
	FileClose(FileOpen($sTempFile, $FO_APPEND)) ; Create the temp Ini file
	Local $mIniFile[]
	Local $mSectionOne[]
	Local $mSectionTwo[]

	$mSectionOne["Primary"] = "Foo"
	$mSectionOne["Secondary"] = "Bar"
	$mSectionOne["Tertiary"] = "Baz"
	$mSectionOne["Quaternary"] = "Qux"
	$mSectionOne["Quinary"] = "Norf"

	$mSectionTwo["Cat"] = "Tiger"
	$mSectionTwo["Dog"] = "Fox"
	$mSectionTwo["Hyaenidae"] = "Hyena"

	$mIniFile["Placeholders"] = $mSectionOne ; This section is called "Placeholders"
	$mIniFile["Animal Families"] = $mSectionTwo ; This section is called "Animal Families"

	_Map_MapToIni($mIniFile, $sTempFile)
	ShellExecuteWait($sTempFile)

	$mIniFile = _Map_IniToMap($mIniFile, $sTempFile) ; Read the contents of a Map
	_Map_Display($mIniFile, '$mIniFile')

	Local $aSections = MapKeys($mIniFile) ; Get the names of the Sections in the Ini File
	For $i = 0 To UBound($aSections) - 1
		_Map_Display($mIniFile[$aSections[$i]], '$mIniFile["' & $aSections[$i] & '"]')
	Next

	FileDelete($sTempFile) ; Delete the Temp File
EndFunc