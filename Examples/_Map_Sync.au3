#include <Array.au3>
#include "..\Map.au3"

Example()

Func Example()
	Local $mOldMap[], $mNewMap[] ; Create the old and new maps.

	; Assign values to the $mOldMap
	$mOldMap["alpha"] = "foo"
	$mOldMap["beta"] = "bar"
	$mOldMap["omega"] = "norf" ; This will not synced because "omega" does not exist in the $mNewMap

	; Assign values to the $mNewMap
	$mNewMap["alpha"] = "foo" ; This value will not change but it will be touched!
	$mNewMap["beta"] = "baz" ; This will change to "bar"!
	$mNewMap["gamma"] = "qux " ; This will be untouched!

	Local $mSyncedMap = _Map_Sync($mOldMap, $mNewMap) ; Sync the old and new maps

	_Map_Display($mSyncedMap, "Synced Map") ; Display the $mSyncedMap
EndFunc