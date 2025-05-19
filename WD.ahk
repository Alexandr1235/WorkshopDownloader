#Requires AutoHotkey v2
#Warn All, Off
;#NoEnv
#NoTrayIcon
#SingleInstance
;if not DirExist("steamapps")
;{
;DirCreate("steamapps")
;}
if not FileExist("steamcmd.exe")
{ 
try {
If Not FileExist("steamcmd.zip")
{ 
MsgBox("A Steamcmd.exe will be downloaded for work the program")
Download "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", "steamcmd.zip"
}
If FileExist("steamcmd.zip")
{ 
RunWAIT("TAR -xf steamcmd.zip")
}
}
catch {
MsgBox("Failed to download Steamcmd.exe")
}
}
If Not FileExist("steamcmd.exe")
{
MsgBox("Not found steamcmd in folder program.  `n Upload it manually")
Run "https://developer.valvesoftware.com/wiki/SteamCMD"
}
MyGui := Gui(, "WorkshopDownloader")
MyGui.Opt("+LastFound +AlwaysOnTop")
WinSetTransColor("0Xcccccc")
MyGui.Color := "ffffff"
MyGui.Marginx := "0"
MyGui.Marginy := "0"
MyGui.SetFont("bold c000000 S10", "Trebuchet MS")
MyGui.Add("edit", "w380 r1 vUrl")
MyGui.Add("Button", "Default y+7", "SteamApi ").OnEvent("Click", start_SteamApi)
MyGui.Add("Button", "Default x+7", "ABCVG ").OnEvent("Click", start_ABCVG)
MyGui.Add("Button", "Default x+7", "GGNTW").OnEvent("Click", start_ggntw)
MyGui.Add("Button", "Default x+7", "SteamCmd").OnEvent("Click", start1)
MyGui.Add("Button", "Default x+12", "About").OnEvent("Click", start3)
MyGui.Show()
Return

start1(*) {
    Saved := MyGui.Submit("nohide")
if !((oUrl := RegExReplace(Saved.Url, "[^0-9]", "")) ~= "[0-9]" )  {
MsgBox "Error Request Url" 
MyGui.Show()
return
}
apiUrl := "https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/" 
oApi := ComObject("MSXML2.XMLHTTP.6.0")
Try {
oApi.Open("POST", apiUrl)
oApi.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
;oApi.SetRequestHeader("itemcount", "0")
apiSend :=  "itemcount=1&publishedfileids[0]=" oUrl "&format=xml"
oApi.Send(apiSend)
}
catch  {
MsgBox "Error Request https" 
MyGui.Show()
return
}
html := oApi.ResponseText
;FileAppend (A_Tab A_NowUTC html), A_ScriptDir "\StreamRequest.log"
  if (oApi.status == "200" or oApi.status == "304")
{
RegExMatch(html, "s)<title>(.*?)</title>",  &title)
RegExMatch(html, "s)<consumer_app_id>(.*?)</consumer_app_id>",  &consumer)
;RegExMatch(html, "s)<description>(.*?)</description>", &description)
;RegExMatch(html, "s)<preview_url>(.*?)</preview_url>",  &preview)
} else {
MsgBox("Status " oApi.status,, 16)
MyGui.Show()
return
}
if !((RegExMatch(html, "s)<file_size>(.*?)</file_size>", &filesize))){
MsgBox "Error Request File" 
MyGui.Show()
return
}
;nGui := Gui(, "MiniGui")
;nGui.Opt("+LastFound +AlwaysOnTop +resize")
       ; Width := (A_ScreenWidth - 40) / 3  ; Minus 28 to allow room for borders and margins inside.
        ;Height := (A_ScreenHeight - 40)
;nGui.Add("ActiveX", "w" Width " h" Height ,"mshtml: <img src=" preview[1] " style=width:200px;height:200px;  /> <div class=detailBox plain><div style=width   : 200px; height  : 50px; position: relative; z-index : 1; background: #eee;>						<div class=game_area_purchase_game>							<h1><span>123</span><h1><br>456</br></h1>							 ")
;nGui.Show("xCenter yCenter AutoSize ")

;MsgBox(html , 16) 

MsgBox "Title: " title[1] "`nFilesize: " round( filesize[1]  / 1024 / 1024 , 2 ) " mb" 
runwait "steamcmd.exe +login anonymous +workshop_download_item " consumer[1] " " oUrl " +exit"
MyGui.Show()
Return
}

start_ABCVG(*) {
 Saved := MyGui.Submit("nohide")
if !((oUrl := RegExReplace(Saved.Url, "[^0-9]", "")) ~= "[0-9]" )  {
MsgBox "Error Request Url" 
MyGui.Show()
return
}
; api steam start
apiUrl := "https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/" 
oApi := ComObject("MSXML2.XMLHTTP.6.0")
Try {
oApi.Open("POST", apiUrl)
oApi.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
apiSend :=  "itemcount=1&publishedfileids[0]=" oUrl "&format=xml"
oApi.Send(apiSend)
}
catch  {
MsgBox "Error Request https" 
MyGui.Show()
return
}
html := oApi.ResponseText
  if (oApi.status == "200" or oApi.status == "304")
{
RegExMatch(html, "s)<consumer_app_id>(.*?)</consumer_app_id>",  &consumer)
} else {
MsgBox("Status " oApi.status,, 16)
MyGui.Show()
return
}

;api steam end


apiUrlABCVG := "http://steamworkshop.download/online/steamonline.php" 
oApiABCVG := ComObject("MSXML2.XMLHTTP.6.0")
Try {
oApiABCVG.Open("POST", apiUrlABCVG)
oApiABCVG.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
Json  := "item=" oUrl "`&app=" consumer[1]
oApiABCVG.Send(Json)
}
catch  {
MsgBox "Error Request link" 
MyGui.Show()
return
}
htmlABCVG := oApiABCVG.ResponseText
if !((RegExMatch(htmlABCVG, "<br>Download LINK: <a href='(.*?)'>", &ABCVG))){
MsgBox "File not found in database ABCVG" 
MyGui.Show()
return
}
run ABCVG[1]
MyGui.Show()
Return
}

start_SteamApi(*) {
    Saved := MyGui.Submit("nohide")
if !((oUrl := RegExReplace(Saved.Url, "[^0-9]", "")) ~= "[0-9]" )  {
MsgBox "Error Request Url" 
MyGui.Show()
return
}
apiUrl := "https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/" 
oApi := ComObject("MSXML2.XMLHTTP.6.0")
Try {
oApi.Open("POST", apiUrl)
oApi.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
apiSend :=  "itemcount=1&publishedfileids[0]=" oUrl "&format=xml"
oApi.Send(apiSend)
}
catch  {
MsgBox "Error Request https" 
MyGui.Show()
return
}
html := oApi.ResponseText
;FileAppend (A_Tab A_NowUTC html), A_ScriptDir "\StreamRequest.log"
  if (oApi.status == "200" or oApi.status == "304")
{
RegExMatch(html, "s)<title>(.*?)</title>",  &title)
RegExMatch(html, "s)<file_size>(.*?)</file_size>", &filesize)
} else {
MsgBox("Status " oApi.status,, 16)
MyGui.Show()
return
}
if !(RegExMatch(html, "s)<file_url>(.*?)</file_url>", &file_url)) or (file_url[1] == ""){
MsgBox "SteamApi has disabled this file downloads." 
MyGui.Show()
return
}
;FileAppend (A_Tab A_NowUTC html), A_ScriptDir "\StreamRequest.log"
MsgBox "Title: " title[1] "`nFilesize: " round( filesize[1]  / 1024 / 1024 , 2 ) " mb" 
run file_url[1] 
MyGui.Show()
Return
}

start_ggntw(*) {
    Saved := MyGui.Submit("nohide")
if !((oUrl := RegExReplace(Saved.Url, "[^0-9]", "")) ~= "[0-9]" )  {
MsgBox "Error Request Url" 
MyGui.Show()
return
}

apiUrl := "https://api.ggntw.com/steam.request" 
oApi := ComObject("MSXML2.XMLHTTP.6.0")
Try {
oApi.Open("POST", apiUrl)
oApi.SetRequestHeader("Content-Type","application/json")
Json  := "{`"url`":`"?id=" oUrl "`"}"
oApi.Send(Json)
}
catch  {
MsgBox "Error Request https" 
MyGui.Show()
return
}
html := oApi.ResponseText
if !((RegExMatch(html, "s)url`"`:`"(.*?)`"`,`"", &ggntw))){
MsgBox "File not found in database GGNTW"
MyGui.Show()
return
}
ggntwurl := StrReplace(ggntw[1], "\/", "/")
run ggntwurl
MyGui.Show()
Return
}


start3(*) {
MyGui.Submit("nohide")
MsgBox ("Create 2025 by Alexandr1235. Build 1.0 Rev.1`nThanks for using this FREE program.`n" A_TAB "alexandr1235@ya.ru `nThis program for functioning uses:`n`aAPI Steampowered by Valve `n`aSteam Client Bootstrapper by Valve Developer Community `n`aAPI GGNETWORK`n`aAPI  ABCVG Network By Vova1234")
MyGui.Show()
Return
}

GuiClose:
ExitApp
Return