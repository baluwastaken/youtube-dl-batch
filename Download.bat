@echo off
title Youtube Downloader
SETLOCAL
if not exist youtube-dl.exe goto nothere
if not exist ffmpeg.exe goto nothere
if not exist ffplay.exe goto nothere
if not exist ffprobe.exe goto nothere
goto start

:nothere
echo Du brauchst die youtube-dl.exe die ffmpeg.exe die ffplay.exe und die ffprobe.exe
echo Soll ich diese Dateien Herunterladen?
choice
if errorlevel 2 goto start
cls
echo Wird Heruntergeladen...
powershell -Command "Invoke-WebRequest https://youtube-dl.org/downloads/latest/youtube-dl.exe -OutFile youtube-dl.exe" 
powershell -Command "Invoke-WebRequest https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip -OutFile ffmpeg.zip" 
powershell Expand-Archive ffmpeg.zip -DestinationPath ffmpeg 
set "dir=%cd%"
cd ffmpeg
cd ffmpeg-latest-win64-static
cd bin 
copy ffmpeg.exe "%dir%/ffmpeg.exe" >nul
copy ffplay.exe "%dir%/ffplay.exe" >nul
copy ffprobe.exe "%dir%/ffprobe.exe" >nul
cd %dir%
del /s /q ffmpeg.zip >nul
rmdir /s /q ffmpeg >nul
echo Herunterladen erfolgreich.
ping localhost >nul
goto start

:start
echo Pruefe auf Updates...
echo Wenn dieser Prozess laenger dauert wird dein youtube-dl gerade geupdated
youtube-dl --update >> nul
cls
echo _____________________________________
echo Youtube Downloader
echo Youtube-dl Version:
youtube-dl --version
echo 1) Video/Playlist herunterladen (mp4)
echo 2) Video/Playlist herunterladen (mp3)
echo 3) Script beenden
echo _____________________________________
choice /c 1234
if errorlevel 3 exit
if errorlevel 2 goto downloadaud
if errorlevel 1 goto downloadvid

:downloadvid
ECHO __     _____ ____  _____ ___
echo \ \   / /_ _^|  _ \^| ____/ _ \
echo  \ \ / / ^| ^|^| ^| ^| ^|  _^|^| ^| ^| ^|
echo   \ V /  ^| ^|^| ^|_^| ^| ^|__^| ^|_^| ^|
echo    \_/  ^|___^|____/^|_____\___/
echo Bitte gib die Video/Playlist URL an
echo Wenn in der URL "LIST=" ist dann ist es Eine Playlist und die ganze Playlist wird heruntergeladen.
echo Kein ^& Symbol in der URL oder Das Script funktioniert nicht richtig.
set /p URL=Bitte fuege die URL ein: 
echo Ich werde jetzt das Video bzw die Playlist herunterladen (als mp4 Datei) okay?
choice
if errorlevel 2 goto start
youtube-dl -i -f mp4  %URL% -o "./Downloads/%%(title)s.%%(ext)s"
echo Erfolgreich heruntergeladen.
pause
goto start

:downloadaud
echo     _   _   _ ____ ___ ___
echo    / \ ^| ^| ^| ^|  _ \_ _/ _ \
echo   / _ \^| ^| ^| ^| ^| ^| ^| ^| ^| ^| ^|
echo  / ___ \ ^|_^| ^| ^|_^| ^| ^| ^|_^| ^|
echo /_/   \_\___/^|____/___\___/
echo Bitte gib die Video/Playlist URL an
echo Wenn in der URL "LIST=" ist dann ist es Eine Playlist und die ganze Playlist wird heruntergeladen.
echo Kein ^& Symbol in der URL oder Das Script funktioniert nicht richtig.
set /p URL=Bitte fuege die URL ein: 
echo Ich werde jetzt das Video bzw die Playlist herunterladen (als mp3 Datei) okay?
choice
if errorlevel 2 goto start
youtube-dl -i --extract-audio --audio-format mp3 %URL% -o "./Downloads/%%(title)s.%%(ext)s"
echo Erfolgreich heruntergeladen.
pause
goto start