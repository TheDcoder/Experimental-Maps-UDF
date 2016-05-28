#include <Array.au3>
#include "..\Maps.au3"

Example()

Func Example()
	Local $mMap[]

	$mMap["Item to ignore"] = "find me"
	$mMap["Item to search"] = "Find me"

	Local $aItemsFound = _Map_Search($mMap, "Find me", True)

	_ArrayDisplay($aItemsFound)
EndFunc