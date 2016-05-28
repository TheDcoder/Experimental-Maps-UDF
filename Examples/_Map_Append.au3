#include "..\Maps.au3"

Example()

Func Example()
	Local $mMap[]

	$mMap["Cat Family"] = "Tiger" ; Add a member of cat family
	$mMap["Dog Family"] = "Fox" ; Add a member of dog family
	_Map_Display($mMap, "_Map_Append Example (Before Appending)")
	_Map_Append($mMap, "Hyaenidae Family", "Hyena") ; Append a member of Hyaenidae family! (Yeah, Hyena is nither a dog nor a cat :P)
	_Map_Display($mMap, "_Map_Append Example (After Appending)")
EndFunc