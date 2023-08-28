#Requires AutoHotkey v2.0

; Get the script's directory
scriptDir := A_ScriptDir

; Name of the text file to read
fileName := "app.txt"

; Build the full file path
filePath := scriptDir . "\" . fileName

; Create an empty array
arrApps := []

; Open the text file to read each line
fileContent := FileRead(filePath)
; OutputDebug(fileContent)
Loop Parse, fileContent, "`n", "`r"
{
    ; Remove trailing line breaks
    line := StrReplace(A_LoopField, "`r`n", "")
    ; OutputDebug line
    if (line = ""){
        ; OutputDebug "hhh"
        continue
    }
    ; Ignore lines starting with #
    if (SubStr(line, 1, 1) != "#"){
        ; Add each line to the array
        newLine := StrReplace(line, "$(USERNAME)", A_UserName)
        arrApps.Push(newLine)
    } 
}

; Traverse the list of applications and start each app, starting from 1
for index, inputString in arrApps {
    arrElements := StrSplit(inputString, ",")
    appPath := arrElements[2]
    ; Get the directory of the application
    appDir :=  GetDirectoryFromPath(appPath)
    ; OutputDebug(appDir)
    ; Start the application in its directory
    SetWorkingDir(appDir)
    Run appPath, appDir
    delay := Integer(arrElements[1])
    Sleep delay
    ; ; Check if it's the last item
    ; if (index = arrApps.Length -1) {
    ;     Sleep 5000 ; If it's the last item, pause for 5 seconds
    ; } else {
    ;     Sleep 1000 ; Otherwise, pause 1 second between each app
    ; }
}

; Get the directory from a path
GetDirectoryFromPath(path) {
    return SubStr(path, 1, InStr(path, "\", false, -1))
}
