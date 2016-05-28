#include "..\Map.au3"

Example()

Func Example()
	Local $oDictObject = ObjCreate("Scripting.Dictionary") ; Declare the $oDictObject

	; Add some Items to the $oDictObject
	$oDictObject.Add("1", "Foo")
	$oDictObject.Add("2", "Bar")
	$oDictObject.Add("3", "Bax")

	Local $mMap = _Map_DictObjectToMap($oDictObject) ; Convert the $oDictObject to a $mMap

	_Map_Display($mMap, "Converted Map") ; Display the $mMap
EndFunc