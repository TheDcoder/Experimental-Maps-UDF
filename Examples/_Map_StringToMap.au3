#include "..\Map.au3"

Example()

Func Example()
	Local $sString = "key1=value1;key2=value2" ; This is the string to convert
	Local $mMap = _Map_StringToMap($sString) ; ConvertIt!

	_Map_Display($mMap, "Converted Map") ; Display the result
EndFunc