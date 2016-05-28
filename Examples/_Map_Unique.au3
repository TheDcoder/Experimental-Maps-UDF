#include "..\Map.au3"

Example()

Func Example()
	Local $mMap[]

	$mMap[1] = "1"
	$mMap[2] = "1"
	$mMap[3] = "2"
	$mMap[4] = "2"
	$mMap[5] = "3"

	_Map_Unique($mMap)

	_Map_Display($mMap, "Unique Map")
EndFunc