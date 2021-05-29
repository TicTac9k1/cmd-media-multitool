@echo off

echo.
echo  This script requires the following tools installed or have the .exe files in the same folder as this script
echo.
echo  youtube-dl.exe - https://github.com/ytdl-org/youtube-dl/releases
echo  ffmpeg.exe - https://github.com/BtbN/FFmpeg-Builds/releases
echo  wget for Windows - http://gnuwin32.sourceforge.net/packages/wget.htm - Required for OpenDirectory download task
echo  MPC-HC - https://github.com/clsid2/mpc-hc/releases - Required for opening Twitch livestreams through media player

:start
echo.
echo  Arguments: convert, twitch, ytdl, 4chan, opendirectory, sa2b
SET choice=
SET /p choice= What would you like to do? [arguments]: 
IF '%choice%'=='convert' GOTO mediaconvertoptions
IF '%choice%'=='4chan' GOTO 4chanoptions
IF '%choice%'=='ytdl' GOTO ytdloptions
IF '%choice%'=='twitch' GOTO twitch
IF '%choice%'=='opendirectory' GOTO opendirectory
IF '%choice%'=='sa2b' GOTO adxconvert
IF '%choice%'=='test' GOTO 4chanwebm
IF NOT '%choice%'=='' GOTO start
IF '%choice%'=='' GOTO start

// Option Select

:mediaconvertoptions
echo.
echo  Arguments: 720p, 360p, mp3, mp4, cut, go-back
echo.
echo  720p: This will rescale a video to 720p
echo  360p: This will rescale a video to 360p
echo  mp3: This will convert a file to mp3
echo  mp4: This will convert a file to mp4
echo  cut: This will cut a specified part out of a video
echo.
SET choice=
SET /p choice= What would you like to do? [arguments]: 
IF '%choice%'=='720p' GOTO 720p
IF '%choice%'=='360p' GOTO 360p
IF '%choice%'=='mp3' GOTO mp3
IF '%choice%'=='mp4' GOTO mp4
IF '%choice%'=='cut' GOTO cut
IF '%choice%'=='go-back' GOTO start
IF NOT '%choice%'=='' GOTO mediaconvertoptions
IF '%choice%'=='' GOTO mediaconvertoptions

:4chanoptions
echo.
echo When making a video webm, make sure to cut out the clip beforehand if the clip exceeds 2 minutes
echo The audio option makes sure no bitrate is lost to video ensuring highest audio quality but a single frame of video is required so we use an image
echo.
echo  Arguments: video, audio, go-back
SET choice=
SET /p choice= Video or audio? [arguments]: 
IF '%choice%'=='video' GOTO 4chanwebm
IF '%choice%'=='audio' GOTO 4chanmusic
IF '%choice%'=='go-back' GOTO start
IF NOT '%choice%'=='' GOTO 4chanoptions
IF '%choice%'=='' GOTO 4chanoptions

:ytdloptions
echo.
echo  Arguments: ytdl, playlist, go-back
echo.
echo  ytdl: This saves a supported stream (live or vod) locally
echo  playlist: Download an entire playlist (supports multiple websites)
echo.
SET choice=
SET /p choice= What would you like to do? [arguments]: 
IF '%choice%'=='ytdl' GOTO ytdl
IF '%choice%'=='playlist' GOTO playlist
IF '%choice%'=='go-back' GOTO start
IF NOT '%choice%'=='' GOTO ytdloptions
IF '%choice%'=='' GOTO ytdloptions


// Tasks

:cut
echo.
set /p inputfile= Cut - Enter the filepath name (Drag and drop): 
set /p starttime= Enter start time in HH:MM:SS and subtract 5 seconds: 
set /p runtime= Enter the run time duration in MM:SS: 
set /p outputfile= Enter the output filename: 
ffmpeg.exe -ss %starttime% -i %inputfile% -to 00:%runtime% -c copy -strict -2 "%outputfile%.mp4"
pause
GOTO start

:360p
echo.
set /p inputfile= 360p - Enter the filepath name (Drag and drop): 
set /p outputfile= Enter the output filename: 
ffmpeg.exe -i %inputfile% -vf scale=-1:360 "%outputfile%_360p.mp4"
pause
GOTO start

:720p
echo.
set /p inputfile= 720p - Enter the filepath name (Drag and drop): 
set /p outputfile= Enter the output filename: 
ffmpeg.exe -i %inputfile% -vf scale=-1:720 "%outputfile%_720p.mp4"
pause
GOTO start

:mp3
echo.
set /p inputfile= MP3 - Enter the filepath name (Drag and drop): 
set /p outputfile= Enter the output filename: 
ffmpeg.exe -i %inputfile% -codec:a libmp3lame -q:a 0 "%outputfile%_mp3.mp3"
pause
GOTO start

:mp4
echo.
set /p inputfile= MP4 - Enter the filepath name (Drag and drop): 
set /p outputfile= Enter the output filename: 
ffmpeg.exe -i %inputfile% "%outputfile%_mp4.mp4"
pause
GOTO start

:twitch
echo.
echo  This assumes you have MPC-HC installed ( https://github.com/clsid2/mpc-hc/releases/tag/1.9.10 )
set /p twitch= Paste Twitch username here: 
"C:\Program Files\MPC-HC\mpc-hc64.exe" https://twitch.tv/%twitch%
pause
GOTO start

:4chanwebm
echo.
echo  This will make a video webm suitable for 4chan with a general duration of 2 minutes
set /p inputfile= 4chan - Enter the filepath name (Drag and drop): 
set /p outputfile= Enter the output filename: 
ffmpeg -i %inputfile% -c:v libvpx -c:a libvorbis -crf 4 -b:a 96K -filter:v scale=512:-1:force_original_aspect_ratio=decrease,fps=25 "%outputfile%.webm"
pause
GOTO start

:4chanmusic
echo.
echo  This will make a audio webm suitable for 4chan limiting video bitrate with a general duration of 4 minutes
set /p inputfile= 4chan - Enter the filepath name (Drag and drop): 
set /p imagefile= Replace video with image small res image (Drag and drop): 
set /p outputfile= Enter the output filename: 
ffmpeg.exe -i %inputfile% -codec:a libmp3lame -q:a 0 "%outputfile%_mp3.mp3"
ffmpeg -framerate 1 -i %imagefile% -i "%outputfile%_mp3.mp3" -c:v vp8 -c:a libvorbis -filter:v scale=512:-1:force_original_aspect_ratio -crf 4 -b:a 160K -fs 4096K "%outputfile%.webm"
del "%outputfile%_mp3.mp3"
pause
GOTO start

:ytdl
echo.
set /p ytdl= Paste URL here: 
youtube-dl.exe %ytdl%
pause
GOTO start

:playlist
echo.
set /p playlisturl= Paste Playlist ID here: 
youtube-dl.exe -cit "%playlisturl%"
pause
GOTO start

:opendirectory
echo.
echo This requires wget ( http://gnuwin32.sourceforge.net/packages/wget.htm )
set /p opendirectoryurl= Enter open directory URL here: 
SET PATH=%PATH%;C:\Program Files (x86)\GnuWin32\bin
wget.exe -m -np -c -w 2 -R "index.html*" "%opendirectoryurl%"
pause
GOTO start

:adxconvert
echo.
echo  Create ADX file for Sonic Adventure 2 Battle (Requires Mod Loader)
set /p inputfile= MP3 - Enter the filepath name (Drag and drop): 
set /p outputfile=Enter the output filename: 
ffmpeg.exe -i %inputfile% "%outputfile%.wav"
rename %outputfile%.wav %outputfile%.adx
pause
GOTO start

:end
echo Script has ended.
EXIT