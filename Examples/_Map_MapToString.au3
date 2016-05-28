#include "..\Map.au3"
#include <MsgBoxConstants.au3>

Example()

Func Example()
	Local $mMap[]
	$mMap["key1"] = "value1"
	$mMap["key2"] = "value2"

	Local $sString = _Map_MapToString($mMap)

	MsgBox($MB_ICONINFORMATION, "Converted String", $sString)
EndFunc