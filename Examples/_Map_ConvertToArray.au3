#include <Array.au3>
#include "..\Map.au3"

Example()

Func Example()
	Local $mMap[] ; Create our map
	$mMap["Primary Place Holder"] = "Foo"
	$mMap["Secondary Place Holder"] = "Bar"
	$mMap["Tertiary Place Holder"] = "Baz"
	$mMap["Quaternary Place Holder"] = "Qux"
	$mMap["Quinary Place Holder"] = "Norf"

	Local $aConvertedArray

	$aConvertedArray = _Map_ConvertToArray($mMap, $MAP_CONVERT1DARRAY) ; Map to 1D Array
	_ArrayDisplay($aConvertedArray, "1D Conversion")

	$aConvertedArray = _Map_ConvertToArray($mMap, $MAP_CONVERT2DARRAY) ; Map to 2D Array
	_ArrayDisplay($aConvertedArray, "2D Conversion")
EndFunc