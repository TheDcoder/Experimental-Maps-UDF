#include-once
#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

; #INDEX# =======================================================================================================================
; Title .........: Maps UDF
; AutoIt Version : 3.3.15.0 (Beta)
; Description ...: Experimental Maps UDF.
; Author(s) .....: Damon Harris (TheDcoder)
; Links .........: Forum  - https://www.autoitscript.com/forum/topic/178897-experimental-maps-udf/
;                  GitHub - https://github.com/TheDcoder/Experimental-Maps-UDF
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Map_1DArrayToMap
; _Map_2DArrayToMap
; _Map_Append
; _Map_Concatenate
; _Map_ConvertToArray
; _Map_Delete
; _Map_Display
; _Map_IniToMap
; _Map_MapToIni
; _Map_MapToString
; _Map_ReassignKey
; _Map_Search
; _Map_StringToMap
; _Map_Unique
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; <None>
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $MAP_CONVERT2DARRAY = 1
Global Const $MAP_CONVERT1DARRAY = 2
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; ...
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_1DArrayToMap
; Description ...: Converts a 1 dimensional array to a map.
; Syntax ........: _Map_1DArrayToMap(Byref $aArray, $vKeys[, $sDelimiter = ';'[, $iInitialElement = 0]])
; Parameters ....: $aArray              - [in/out] Array to convert.
;                  $vKeys               - A array containing the keys for each element OR
;                                         A string delimited with $sDelimiter containing the keys for each element.
;                  $sDelimiter          - [optional] Delimiter used to split the string (Ignored if an array). Default is ';'.
;                  $iInitialElement     - [optional] Element to take as a starting point. Default is 0.
; Return values .: Success: Converted Map
;                  Failure: False & @error set to:
;                           1 - If $vKeys is not an Array neither a String.
;                           2 - $aArray is not 1 dimensional.
;                           3 - If the no. of Elements in $aArray & $vKeys differ.
;                           4 - Conflicting keys were found, @extended contains the no. of conflicts.
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......:
; Related .......: _Map_2DArrayToMap
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_1DArrayToMap(ByRef $aArray, $vKeys, $sDelimiter = ';', $iInitialElement = 0)
	If IsString($vKeys) Then ; If it is a string then...
		$vKeys = StringSplit($vKeys, $sDelimiter, $STR_NOCOUNT) ; Get the list of keys...
	ElseIf Not IsArray($vKeys) Then ; Else, If it's not a Array, Then...
		Return SetError(1, 0, False) ; Return False & set @error to 1
	EndIf
	If Not UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then Return SetError(2, 0, False) ; If the $aArray is multi-dimensional then return...
	Local $iKeyCount = UBound($vKeys) ; Count the $iKeyCount
	Local $iElementCount = UBound($aArray) ; Count the $iElementCount
	If Not $iKeyCount = $iElementCount - $iInitialElement Then Return SetError(3, 0, False) ; If there are different no. of keys than elements then return...
	Local $mReturnMap[] ; Declare the $mReturnMap
	Local $iErrorCount = 0 ; Declare the $iErrorCount
	For $iElement = $iInitialElement To ($iElementCount - 1) + $iInitialElement ; Loop...
		_Map_Append($mReturnMap, $vKeys[$iElement], $aArray[$iElement]) ; Append the element
		$iErrorCount += @error ; Add up the error count
	Next
	If $iErrorCount > 0 Then Return SetError(4, $iErrorCount, False) ; If there was/were (a) error(s) then return...
	Return $mReturnMap ; Return the $mReturnMap
EndFunc   ;==>_Map_1DArrayToMap

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_2DArrayToMap
; Description ...: Converts a 2 dimensional array to a map.
; Syntax ........: _Map_2DArrayToMap(Byref $aArray[, $iKeyColumn = 0[, $iValueColumn = 1[, $iInitialRow = 0]]])
; Parameters ....: $aArray              - [in/out] Array to convert.
;                  $iKeyColumn          - [optional] The index of column containing the keys. Default is 0.
;                  $iValueColumn        - [optional] The index of column containing the values. Default is 1.
;                  $iInitialRow         - [optional] Row to take as a starting point. Default is 0.
; Return values .: Success: Converted Map.
;                  Failure: False & @error set to:
;                           1 - If $aArray is not 2 dimensional.
;                           2 - Conflicting keys were found, @extended contains the no. of conflicts.
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......:
; Related .......: _Map_1DArrayToMap
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_2DArrayToMap(ByRef $aArray, $iKeyColumn = 0, $iValueColumn = 1, $iInitialRow = 0)
	If Not UBound($aArray, $UBOUND_DIMENSIONS) = 2 Then Return SetError(1, 0, False) ; If the $aArray is not 2 dimensional then return...
	Local $iRowCount = UBound($aArray) ; Count the elements in $aArray
	Local $mReturnMap[] ; Declare the $mReturnMap
	Local $iErrorCount = 0 ; Declare the $iErrorCount
	For $iRow = $iInitialRow To ($iRowCount - 1) + $iInitialRow ; Loop...
		_Map_Append($mReturnMap, $aArray[$iRow][$iKeyColumn], $aArray[$iRow][$iValueColumn]) ; Append the element
		$iErrorCount += @error ; Add up the error count
	Next
	If $iErrorCount > 0 Then Return SetError(2, $iErrorCount, False) ; If there was/were (a) error(s) then return...
	Return $mReturnMap ; Return the $mReturnMap
EndFunc   ;==>_Map_2DArrayToMap

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_Append
; Description ...: Append an element to a map. (Different from MapAppend)
; Syntax ........: _Map_Append(Byref $mMap, $vKey, $vContents)
; Parameters ....: $mMap                - [in/out] Map to proccess.
;                  $vKey                - The key to the element.
;                  $vContents           - Contents of the element.
; Return values .: Success: True
;                  Failure: False & @error set to non-zero
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: Keys are case-sensitive.
; Related .......: MapAppend
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_Append(ByRef $mMap, $vKey, $vContents)
	If MapExists($mMap, $vKey) Then Return SetError(1, 0, False) ; The key already exists then return...
	$mMap[$vKey] = $vContents ; Append the contents
	Return True ; Return True
EndFunc   ;==>_Map_Append

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_Concatenate
; Description ...: Concatenate 2 maps
; Syntax ........: _Map_Concatenate(Byref $mMapOne, Byref $mMapTwo)
; Parameters ....: $mMapOne             - [in/out] Map 1.
;                  $mMapTwo             - [in/out] Map 2.
; Return values .: Success: Combination of $mMapOne & $mMapTwo.
;                  Failure: Concatenated map + @error set to number of key naming conflicts.
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: The concatenated map is still returned even if there is an error.
; Related .......: _Map_Append.
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_Concatenate(ByRef $mMapOne, ByRef $mMapTwo)
	Local $mReturnMap[] ; Declare the $mReturnMap
	Local $aKeys = MapKeys($mMapOne) ; Get the $aKeys of $mMapOne
	For $vKey In $aKeys ; Loop...
		_Map_Append($mReturnMap, $vKey, $mMapOne[$vKey]) ; Append element
	Next
	$aKeys = MapKeys($mMapTwo) ; Get the $aKeys of $mMapTwo
	Local $iErrorCount = 0 ; Declare $iErrorCount
	For $vKey In $aKeys ; Loop...
		_Map_Append($mReturnMap, $vKey, $mMapTwo[$vKey]) ; Append element
		$iErrorCount += @error ; Add up the $iErrorCount
	Next
	Return SetError($iErrorCount, 0, $mReturnMap) ; Return the $mReturnMap
EndFunc   ;==>_Map_Concatenate

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_ConvertToArray
; Description ...: Converts a Map to Array.
; Syntax ........: _Map_ConvertToArray(Byref $mMap[, $iArrayDimension = $MAP_CONVERT2DARRAY])
; Parameters ....: $mMap                - [in/out] Map to process.
;                  $iArrayDimension     - [optional] The dimension of the return array. Default is $MAP_CONVERT2DARRAY.
; Return values .: Success: A 1D Array containing all the contents of the map.
;                           A 2D Array containing key & value pair.
;                  Failure: False & @error set to non-zero
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: 1. Only $MAP_CONVERT1DARRAY & $MAP_CONVERT2DARRAY are accepted in $iArrayDimension parameter, anything else sets
;                     @error to 1
;                  2. The 1st (0) element or the 2nd (1) column of 1st row contains the No. of keys/elements
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_ConvertToArray(ByRef $mMap, $iArrayDimension = $MAP_CONVERT2DARRAY)
	Local $iKeyCount = UBound($mMap) ; Count the no. of keys in $mMap
	Local $aKeys = MapKeys($mMap) ; Get the keys in $mMap
	Switch $iArrayDimension ; Switch based on the user's choice
		Case $MAP_CONVERT1DARRAY ; If the user wants a 1D Array
			Local $aReturnArray[$iKeyCount + 1] ; Declare the $aReturnArray
			$aReturnArray[0] = $iKeyCount ; Store the total number of elements in the 0 element
			For $iElement = 0 To $iKeyCount - 1 ; Loop...
				$aReturnArray[$iElement + 1] = $mMap[$aKeys[$iElement]] ; Populate the $aReturnArray
			Next
			Return $aReturnArray ; Return the $aReturnArray

		Case $MAP_CONVERT2DARRAY ; If the user wants a 2D Array
			Local $aReturnArray[$iKeyCount + 1][2] ; Declare the $aReturnArray
			$aReturnArray[0][0] = "No. of Rows" ; Store the total number of elements in the 0 element
			$aReturnArray[0][1] = $iKeyCount ; Store the total number of elements in the 0 element
			For $iRow = 1 To $iKeyCount ; Loop...
				$aReturnArray[$iRow][0] = $aKeys[$iRow - 1] ; Populate the $aReturnArray
				$aReturnArray[$iRow][1] = $mMap[$aKeys[$iRow - 1]] ; Populate the $aReturnArray
			Next
			Return $aReturnArray ; Return the $aReturnArray

		Case Else ; Any other silly choices the user chooses
			Return SetError(1, 0, False) ; Return False and set @error to 1
	EndSwitch
EndFunc   ;==>_Map_ConvertToArray

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_Delete
; Description ...: Deletes all the elements in a map.
; Syntax ........: _Map_Delete(Byref $mMap, $bHardWay = False)
; Parameters ....: $mMap                - [in/out] Map to process.
;                  $bHardWay            - [optional] If True, The elements are removed one by one. Not recommended.
; Return values .: Success: True & If $bHardWay Then @extended contains No. of elements in the map.
;                  Failure: False, @extended contains the Error Count & @error is set to non-zero.
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: Only the elements are deleted, not the map itself! You can reuse the map if you wish.
; Related .......: MapRemove
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_Delete(ByRef $mMap, $bHardWay = False)
	If Not $bHardWay Then ; If Not the $bHardWay Then...
		Local $mEmptyMap[] ; Declare a $mEmptyMap
		$mMap = $mEmptyMap ; Replace $mMap with $mEmptyMap
		Return True ; Return True
	EndIf
	Local $iErrorCount = 0 ; Declare the $iErrorCount
	Local $aKeys = MapKeys($mMap) ; Get the $aKeys in $mMap
	For $iKeyCount = 0 To UBound($aKeys) - 1 ; Loop...
		MapRemove($mMap, $aKeys[$iKeyCount]) ; Remove the key
		If @error Then $iErrorCount += 1 ; Add up the $iErrorCount
	Next
	If $iErrorCount > 0 Then Return SetError(1, $iErrorCount, False) ; If there was/were (a) error(s) then return...
	Return SetExtended($iKeyCount, True) ; Return True & set @extended to $iKeyCount
EndFunc   ;==>_Map_Delete

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_Display
; Description ...: Displays the Key & Value pair in a ListView.
; Syntax ........: _Map_Display(Byref $mMap[, $sTitle = "Map Display"])
; Parameters ....: $mMap                - [in/out] Map to display.
;                  $sTitle              - [optional] Title for the Display window. Default is "Map Display".
; Return values .: Success: True
;                  Failure: False & @error is set to non-zero
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: This function is intended to be used for Debugging. Its still in development, so it does not provide flexible
;                  functionality like _ArrayDisplay
; Related .......: _ArrayDisplay
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_Display(ByRef $mMap, $sTitle = "Map Display")
	If Not IsMap($mMap) Then
		Return SetError(1, 0, False)
	EndIf
	Local Const $esDataSepChar = Opt("GUIDataSeparatorChar") ; Get the GUIDataSeparatorChar
	Local $hGUI = GUICreate($sTitle, 300, 300, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX, $WS_MAXIMIZEBOX)) ; Create the $hGUI
	Local $idListView = GUICtrlCreateListView("Key|Value", 0, 0, 300, 264) ; Create the $idListView
	Local $idCopyButton = GUICtrlCreateButton("Copy Text", 3, 268, 146, 30) ; Create the $idCopyButton
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO) ; Set Resizing
	Local $idExitButton = GUICtrlCreateButton("Exit Script", 149, 268, 148, 30) ; Create the $idExitButton
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO) ; Set Resizing

	Local $aKeys = MapKeys($mMap) ; Get the $aKeys in the map
	;Local $iKeyCount = UBound($mMap) ; Get the $iKeyCount
	Local $sContents = "" ; Declare the variable in which the contents will be stored

	For $vKey In $aKeys ; Loop...
		$sContents = $vKey & $esDataSepChar
		Switch VarGetType($mMap[$vKey]) ; Switch to the Var Type
			Case "Map"
				$sContents &= '{Map}' ; Store the contents

			Case "Array"
				$sContents &= '{Array}' ; Store the contents

			Case "Object"
				$sContents &= '{Object}' ; Store the contents

			Case "DLLStruct"
				$sContents &= '{Struct}' ; Store the contents

			Case "Function"
				$sContents &= '{Function}' ; Store the contents

			Case "UserFunction"
				$sContents &= '{UDF}' ; Store the contents

			Case Else
				$sContents &= $mMap[$vKey] ; Store the contents
		EndSwitch
		GUICtrlCreateListViewItem($sContents, $idListView) ; Create the ListViewItem in $idListView
	Next

	_GUICtrlListView_SetColumnWidth($idListView, 0, $LVSCW_AUTOSIZE) ; Autosize the $idListView to fit the text
	GUISetState() ; Display the GUI
	Local $nMsg = 0

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($hGUI) ; Delete the GUI
				Return True ; Return True

			Case $idExitButton
				Exit ; Exit

			Case $idCopyButton
				$sContents = GUICtrlRead(GUICtrlRead($idListView)) ; Copy the $sContents of the ListViewItem
				ClipPut($sContents) ; ClipPut them!
				MsgBox($MB_ICONINFORMATION, $sTitle, "The following has been copied to your clipboard: " & @CRLF & @CRLF & $sContents) ; Display a message
		EndSwitch
	WEnd
EndFunc   ;==>_Map_Display

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_IniToMap
; Description ...: Get a map representation of a Ini File.
; Syntax ........: _Map_IniToMap($sFile)
; Parameters ....: $sFile               - Path of the Ini File.
; Return values .: Success: Map representation of $sFile
;                  Failure: False & @error set to non-zero
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: The map is in this format:
;                  $mIniFile["Section"]["Key"] = "Value"
; Related .......: _Map_MapToIni
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_IniToMap(ByRef $mIniFile, $sFile)
	If Not FileExists($sFile) Then ; If not file exists then...
		Return SetError(1, 0, False) ; Return False & set @error to 1
	EndIf
	Local $mKeys[] ; Declare the map which will hold the $mKeys
	Local $aSections = IniReadSectionNames($sFile) ; Declare the array which will hold the $aSections
	Local $aKeys[0] ; Declare the array which will hold the $mKeys
	For $iSection = 1 To $aSections[0] ; Loop...
		$aKeys = IniReadSection($sFile, $aSections[$iSection]) ; Store the $aKeys
		For $iKey = 1 To $aKeys[0][0] ; Loop...
			$mKeys[$aKeys[$iKey][0]] = $aKeys[$iKey][1] ; Store the $mKeys
		Next
		$mIniFile[$aSections[$iSection]] = $mKeys ; Store $mKeys in $mIniFile
		_Map_Delete($mKeys) ; Delete the $mKeys
	Next
	Return $mIniFile ; Return the $mIniFile
EndFunc   ;==>_Map_IniToMap

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_MapToIni
; Description ...: Map to Ini File.
; Syntax ........: _Map_MapToIni(Byref $mIniFile, $sFile)
; Parameters ....: $mIniFile            - [in/out] Map representation of a INI File (See Remarks).
;                  $sFile               - Location of Ini File.
; Return values .: Success: True
;                  Failure: False & @error to non-zero
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: 1. The map must be in this format: (same format as _Map_IniToMap)
;                     $mIniFile["Section"]["Key"] = "Value"
;                  2. The $sFile will be created if it does not already exist, albeit the root directory will not be created if
;                     it does not exist.
; Related .......: _Map_IniToMap
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_MapToIni(ByRef $mIniFile, $sFile)
	Local $aSections = MapKeys($mIniFile) ; Get the $aSections from $mIniFile
	Local $aKeys[0] ; Declare the $aKeys
	For $iSection = 0 To UBound($aSections) - 1 ; Loop...
		$aKeys = MapKeys($mIniFile[$aSections[$iSection]]) ; Store the $aKeys
		For $iKey = 0 To UBound($aKeys) - 1 ; Loop...
			IniWrite($sFile, $aSections[$iSection], $aKeys[$iKey], $mIniFile[$aSections[$iSection]][$aKeys[$iKey]]) ; Write to $sFile
		Next
	Next
	Return True ; Return True
EndFunc   ;==>_Map_MapToIni

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_MapToString
; Description ...: Converts a Map to String
; Syntax ........: _Map_MapToString(Byref $mMap[, $sElementDelimiter = ';'[, $sPairDelimiter = '=']])
; Parameters ....: $mMap                - [in/out] Map to process.
;                  $sElementDelimiter   - [optional] Delimiter used to seperate elements. Default is ';'.
;                  $sPairDelimiter      - [optional] Delimiter used to seperate key and value pair. Default is '='.
; Return values .: Success: Converted String & @extended set to the no. of elements
;                  Failure: N/A
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......:
; Related .......: _Map_StringToMap
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_MapToString(ByRef $mMap, $sElementDelimiter = ';', $sPairDelimiter = '=')
	Local $aKeys = MapKeys($mMap) ; Get the $aKeys
	Local $sString = "" ; Declare the $sString
	For $iKey = 0 To UBound($aKeys) - 1 ; Loop...
		$sString &= $sElementDelimiter & $aKeys[$iKey] & $sPairDelimiter & $mMap[$aKeys[$iKey]] ; Append the string...
	Next
	$sString = StringTrimLeft($sString, StringLen($sElementDelimiter)) ; Trim the $sString (The first $sElementDelimiter)
	Return SetExtended($iKey + 1, $sString) ; Return $sString & set @extended to the number of elements
EndFunc   ;==>_Map_MapToString

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_RenameKey
; Description ...: Rename a key in a Map.
; Syntax ........: _Map_RenameKey(Byref $mMap, $vKey, $vNewKey)
; Parameters ....: $mMap                - [in/out] Map to process.
;                  $vKey                - Key to rename.
;                  $vNewKey             - New key's name.
; Return values .: Success: True
;                  Failure: False & @error set to non-zero
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......: Function will fail if $vKey does not exist or $vNewKey already exists
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_RenameKey(ByRef $mMap, $vKey, $vNewKey)
	If Not MapExists($mMap, $vKey) Or MapExists($mMap, $vNewKey) Then ; If the $vKey does not exists or $vNewKey does exists then...
		Return SetError(1, 0, False) ; Return False & set @error to 1
	EndIf
	$mMap[$vNewKey] = $mMap[$vKey] ; Transfer the contents to its $vNewKey
	MapRemove($mMap, $vKey) ; Remove the $v(Old)Key
	Return True ; Return True
EndFunc   ;==>_Map_ReassignKey

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_Search
; Description ...: Searches for a string in a map.
; Syntax ........: _Map_Search(Byref $mMap, $vSearch[, $bCaseSense = False])
; Parameters ....: $mMap                - [in/out] $mMap to search.
;                  $vSearch             - What to search for.
;                  $bCaseSense          - [optional] Case Sensitive?. Default is False.
; Return values .: Success: An 2D array holding keys in which the content matched (with item count in [0])
;                  Failure: An array with [0] = 0
; Author ........: Your Name
; Modified ......:
; Remarks .......: The format of returned Array: (n denotes a Natural Number)
;                  The nth match is located in $aArray[n]. In the [0] columun is the name of the key and in the [1] is the Position of the text matched.
;
;                  See example for more details.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_Search(ByRef $mMap, $vSearch, $bCaseSense = False)
	Local $aKeys = MapKeys($mMap) ; Get the $aKeys
	Local $vFound[] ; Matching items will be stored in this map
	Local $iStringPos = 0 ; Position of string
	Local $iCaseSense = $bCaseSense ? $STR_CASESENSE : $STR_NOCASESENSEBASIC ; Convert $bCaseSense to $iCaseSense to make it usable with StringInStr
	For $vKey In $aKeys ; Loop...
		$iStringPos = StringInStr($mMap[$vKey], $vSearch, $iCaseSense) ; Search for $vSearch
		If Not $iStringPos = 0 Then $vFound[$vKey] = $iStringPos ; If its is found then append it
	Next
	Return _Map_ConvertToArray($vFound) ; Return
EndFunc   ;==>_Map_Search

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_StringToMap
; Description ...: Converts a String to Map
; Syntax ........: _Map_StringToMap($sString[, $sElementDelimiter = ';'[, $sPairDelimiter = '=']])
; Parameters ....: $sString             - String to process.
;                  $sElementDelimiter   - [optional] Delimiter used to seperate elements. Default is ';'.
;                  $sPairDelimiter      - [optional] Delimiter used to seperate key and value. Default is '='.
; Return values .: Success: Converted Map & @extended is set to the no. of elements
;                  Failure: False & @error set to:
;                           1 - If $sPairDelimiter not found.
;                           2 - If a key already exists.
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......:
; Related .......: _Map_MapToString
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_StringToMap($sString, $sElementDelimiter = ';', $sPairDelimiter = '=')
	Local $aElements = StringSplit($sString, $sElementDelimiter) ; Split the $aElements
	Local $aKeyAndValue[0] ; Declare the array which will hold the $aKeyAndValue
	Local $mMap[] ; Declare the $mMap
	Local Enum $KEY, $VALUE ; Constants for $aKeyAndValue
	For $iElement = 1 To $aElements[0] ; Loop...
		$aKeyAndValue = StringSplit($aElements[$iElement], $sPairDelimiter, $STR_NOCOUNT) ; Split $aKeyAndValue
		If @error Then Return SetError(1, 0, False) ; If error then Return False & set @error to 1
		_Map_Append($mMap, $aKeyAndValue[$KEY], $aKeyAndValue[$VALUE]) ; Append the $iElement to the $mMap
		If @error Then Return SetError(2, 0, False) ; If error then Return False & set @error to 2
	Next
	Return SetExtended($iElement, $mMap) ; Return the $mMap & set @extended to $iElement count
EndFunc   ;==>_Map_StringToMap

; #FUNCTION# ====================================================================================================================
; Name ..........: _Map_Unique
; Description ...: Removes all duplicate values from a map.
; Syntax ........: _Map_Unique(Byref $mMap)
; Parameters ....: $mMap                - [in/out] $mMap to process.
; Return values .: Success: Number of duplicates
;                  Failure: N/A
; Author ........: Damon Harris (TheDcoder)
; Modified ......:
; Remarks .......:
; Related .......: _Array_Unique
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Map_Unique(ByRef $mMap)
	Local $mContent[] ; This will be used to store content
	Local $aKeys = MapKeys($mMap) ; Get the $aKeys
	Local $iReplacements = 0 ; Number of replacements
	For $iKey = 0 To UBound($aKeys) - 1 ; Loop...
		If MapExists($mContent, $mMap[$aKeys[$iKey]]) Then ; If the content already exists then...
			MapRemove($mMap, $aKeys[$iKey]) ; Remove the element from the $mMap
			$iReplacements += 1 ; Add up the no. of replacements
		Else ; Else...
			$mContent[$mMap[$aKeys[$iKey]]] = "" ; Store the content
		EndIf
	Next
	Return $iReplacements ; Return no. of $iReplacements
EndFunc   ;==>_Map_Unique
