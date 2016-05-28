#include "..\Map.au3"

Example()

Func Example()
	Local $aArray[5] = ["Foo", "Bar", "Baz", "Qux", "Norf"] ; This is the array to convert
	Local $sKeys = "Primary Place Holder;Secondary Place Holder;Tertiary Place Holder;Quaternary Place Holder;Quinary Place Holder" ; Keys in String Format
	Local $aKeys[5] = ["Primary Place Holder", "Secondary Place Holder", "Tertiary Place Holder", "Quaternary Place Holder", "Quinary Place Holder"] ; Keys in Array Format

	Local $mConvertedMap[]

	$mConvertedMap = _Map_1DArrayToMap($aArray, $sKeys) ; Convert Array To Map with Keys in String format
	_Map_Display($mConvertedMap, "Converted Array") ; Display Map

	$mConvertedMap = _Map_1DArrayToMap($aArray, $aKeys) ; Convert Array To Map with Keys in Array format
	_Map_Display($mConvertedMap, "Converted Array") ; Display Map
EndFunc