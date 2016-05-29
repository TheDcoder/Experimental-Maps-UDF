#include "..\Map.au3"
#include <MsgBoxConstants.au3>

Example()

Func Example()
	Local $mMap[] ; Declare the $mMap

	; Add some elements to the Map :)
	$mMap['1'] = "Foo"
	$mMap['2'] = "Bar"
	$mMap['3'] = "Baz"

	Local $oDictObject = _Map_MapToDictObject($mMap) ; Convert the $mMap to a $oDictObject

	Local $sMsgBoxContents ; We will store the string representation of $oDictObject in this variable
	For $vKey In $oDictObject.Keys() ; Loop
		$sMsgBoxContents &= '$oDictObject.Item(' & $vKey & ') = ' & $oDictObject.Item($vKey) & @CRLF
	Next
	MsgBox($MB_ICONINFORMATION, '$oDictObject', $sMsgBoxContents)
EndFunc