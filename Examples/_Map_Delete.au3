#include "..\Maps.au3"
#include <MsgBoxConstants.au3>

Example()

Func Example()
	Local $mMap[]

	$mMap["Foo"] = "Bar"
	_Map_Display($mMap, "Map Before Deletion")
	_Map_Delete($mMap) ; Delete the Map
	_Map_Display($mMap, "Map After Deletion")

	$mMap["Foo"] = "Bar"
	_Map_Display($mMap, "Map Before Deletion")
	_Map_Delete($mMap, True) ; Delete the Map and count the elements
	MsgBox($MB_ICONINFORMATION, "Example", "The no. of elements deleted: " & @extended)
	_Map_Display($mMap, "Map After Deletion")
EndFunc