#Requires AutoHotkey v1.1
#NoEnv
#SingleInstance Force

; Preload Explorer detection to avoid first-click issue
SetTimer, EnsureExplorerReady, -100

#If ExplorerUnderMouse()
MButton::OpenFolderInNewWindow()
#If

OpenFolderInNewWindow() {
    Click, right
    hMenu := WaitForContextMenu()
    
    if (hMenu = "FAIL") {
        ; Retry once if the first attempt fails
        Sleep, 100
        Click, right
        hMenu := WaitForContextMenu()
        if (hMenu = "FAIL")
            return
    }

    ContextMenuSelect(hMenu, "Op&en in new window") 
}

WaitForContextMenu() {
    hMenu := "Null"
    Loop, 30 {  ; Wait up to 300ms for context menu to appear
        SendMessage, 0x1E1,,,, ahk_class #32768 ; MN_GETHMENU := 0x1E1
        hMenu := ErrorLevel
        if (hMenu != "FAIL" && hMenu != "Null")
            return hMenu
        Sleep, 10
    }
    return "FAIL"
}

ContextMenuSelect(hMenu, vNeedle := "Op&en in new window") {
    SendMessage, 0x1E1,,,, ahk_class #32768 ; MN_GETHMENU := 0x1E1
    hMenu := ErrorLevel
    vNeedle := StrReplace(vNeedle, "&")
    
    Loop, % DllCall("user32\GetMenuItemCount", Ptr,hMenu) {
        vID := DllCall("user32\GetMenuItemID", Ptr,hMenu, Int,A_Index-1, UInt)
        if (vID = 0) || (vID = 0xFFFFFFFF) 
            continue
        vChars := DllCall("user32\GetMenuString", Ptr,hMenu, UInt,A_Index-1, Ptr,0, Int,0, UInt,0x400) + 1
        VarSetCapacity(vText, vChars << !!A_IsUnicode)
        DllCall("user32\GetMenuString", Ptr,hMenu, UInt,A_Index-1, Str,vText, Int,vChars, UInt,0x400)
        if (StrReplace(vText, "&") = vNeedle) {
            PostMessage, 0x1F1, % A_Index-1, 0,, ahk_class #32768 ; MN_DBLCLK := 0x1F1
        }
    }
}

ExplorerUnderMouse() {
    MouseGetPos,,, hWnd
    WinGetClass, winClass, ahk_id %hWnd%
    Return winClass ~= "^(Progman|WorkerW|(Cabinet|Explore)WClass)$"
}

EnsureExplorerReady() {
    if !WinExist("ahk_class CabinetWClass") {
        Run, explorer.exe
        WinWait, ahk_class CabinetWClass, , 2
    }
}