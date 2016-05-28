#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

#include "../Map.au3"

Example()

Func Example()
	Local $aArray[5][2] = [["Primary Place Holder", "Foo"], _
	["Secondary Place Holder", "Bar"], _
	["Tertiary Place Holder", "Baz"], _
	["Quaternary Place Holder", "Qux"], _
	["Quinary Place Holder", "Norf"]]

	Local $mConvertedMap[]

	$mConvertedMap = _Map_2DArrayToMap($aArray)
	_Map_Display($mConvertedMap)
EndFunc