@echo off

:start
echo.
echo Arguments: 720p, 360p, mp3, playlist, adx, cut, twitch
SET choice=
SET /p choice=What would you like to do? [arguments]: 
IF '%choice%'=='720p' GOTO 720p
IF '%choice%'=='360p' GOTO 360p
IF '%choice%'=='mp3' GOTO mp3
IF '%choice%'=='playlist' GOTO playlist
IF '%choice%'=='adx' GOTO adx
IF '%choice%'=='cut' GOTO cut
IF '%choice%'=='twitch' GOTO twitch
IF NOT '%choice%'=='' GOTO start
IF '%choice%'=='' GOTO start

:720p
echo.
echo This will rescale a video to 720p
set /p inputfile=720p - Enter the filepath name (Drag and drop): 
set /p outputfile=Enter the output filename: 
ffmpeg.exe -i %inputfile% -vf scale=-1:720 "%outputfile%_720p.mp4"
pause
GOTO end

:360p
echo.
echo This will rescale a video to 360p
set /p inputfile=360p - Enter the filepath name (Drag and drop): 
set /p outputfile=Enter the output filename: 
ffmpeg.exe -i %inputfile% -vf scale=-1:360 "%outputfile%_360p.mp4"
pause
GOTO end

:mp3
echo.
echo This will convert a file to mp3 if file format is supported
set /p inputfile=MP3 - Enter the filepath name (Drag and drop): 
set /p outputfile=Enter the output filename: 
ffmpeg.exe -i %inputfile% -codec:a libmp3lame -q:a 0 "%outputfile%_mp3.mp3"
pause
GOTO end

:playlist
echo.
echo Download an entire playlist (supports multiple websites)
set /p playlisturl=Paste Playlist ID here: 
youtube-dl.exe -cit "%playlisturl%"
pause
GOTO end

:adx
echo.
echo Create ADX file for Sonic Adventure 2 Battle (Requires Mod Loader)
set /p inputfile=MP3 - Enter the filepath name (Drag and drop): 
set /p outputfile=Enter the output filename: 
ffmpeg.exe -i %inputfile% "%outputfile%.wav"
rename %outputfile%.wav %outputfile%.adx
pause
GOTO end

:cut
echo.
echo This will cut a specified part out of a video
set /p inputfile=Cut - Enter the filepath name (Drag and drop): 
set /p outputfile=Enter the output filename: 
set /p starttime=Enter start time in HH:MM:SS: 
set /p endtime=Enter end time in HH:MM:SS: 
ffmpeg.exe -ss %starttime% -i %inputfile% -to %endtime% -c copy "%outputfile%_trimmed.mp4"
pause
GOTO end

:twitch
echo.
echo This assumes you have MPC-HC installed ( https://github.com/clsid2/mpc-hc/releases/tag/1.9.10 )
set /p twitch=Paste Twitch URL here:
"C:\Program Files\MPC-HC\mpc-hc64.exe" %twitch%
pause

:end
echo Script has ended.
EXIT