#include "../Map.au3"

Example()

Func Example()
	Local $mMap[]

	$mMap["Key"] = "Value"
	_Map_Display($mMap, "Before Reassigning Key")

	_Map_ReassignKey($mMap, "Key", "Reassigned Key")

	_Map_Display($mMap, "After Reassigning Key")
EndFunc