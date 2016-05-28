#include "../Map.au3"

Example()

Func Example()
	Local $mMap[]

	$mMap["Key"] = "Value"
	_Map_Display($mMap, "Before Renaming Key")

	_Map_RenameKey($mMap, "Key", "Renamed Key")

	_Map_Display($mMap, "After Renaming Key")
EndFunc