#include "..\Map.au3"

Example()

Func Example()
	Local $mMapOne[]
	Local $mMapTwo[]

	$mMapOne[1] = "Item 1"
	$mMapTwo[2] = "Item 2"

	Local $mConcatenatedMap = _Map_Concatenate($mMapOne, $mMapTwo)

	_Map_Display($mConcatenatedMap, "Concatenated Map")
EndFunc