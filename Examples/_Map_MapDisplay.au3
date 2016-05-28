#include "..\Maps.au3"

Example()

Func Example()
	Local $mMap[] ; Declare the map
	Local $aArray[0] ; Declare the $aArray which will be used to store in $mMap
	Local $mMiniMap[] ; Declare the $mMiniMap which will be used to store in $mMap

	$mMap["Array"] = $aArray
	$mMap["Map"] = $mMiniMap
	$mMap["Binary"] = Binary(0x000000)
	$mMap["Boolean"] = True
	$mMap["Pointer"] = Ptr(-1)
	$mMap["Handle"] = WinGetHandle(AutoItWinGetTitle())
	$mMap["Integer"] = 1
	$mMap["Float"] = 0.1
	$mMap["Object"] = ObjCreate("Scripting.Dictionary")
	$mMap["String"] = "This is a string"
	$mMap["Struct"] = DllStructCreate("wchar[256]")
	$mMap["Keyword"] = Default
	$mMap["Function"] = ConsoleWrite
	$mMap["User Defined Function"] = _Map_Display

	_Map_Display($mMap, "Map containing all dataypes in AutoIt")
EndFunc