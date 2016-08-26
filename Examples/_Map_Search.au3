#include <Array.au3>
#include "..\Map.au3"

Example()

Func Example()
	Local $mMap[] ; Create the $mMap

	$mMap["Item to ignore"] = "find me" ; This element will be ignored
	$mMap["Item to search"] = "Find me" ; This element will be found

	Local $aItemsFound = _Map_Search($mMap, "Find me", True) ; Perform a case-sensitive search on $mMap

	_ArrayDisplay($aItemsFound) ; Display the $aItemsFound
EndFunc