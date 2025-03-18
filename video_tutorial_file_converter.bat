@echo off
setlocal enabledelayedexpansion

:start
cls
echo ================================================
echo Advanced Tutorial Video Converter
echo ================================================

rem Ask to enter the path to the input video file
echo.
set /p INPUT_PATH="Enter the path to the input video file: "

rem Remove surrounding quotes if present
set INPUT_FILE=!INPUT_PATH!
set INPUT_FILE=!INPUT_FILE:"=!

rem Check if file exists
if not exist "!INPUT_FILE!" (
    echo Error: Input file not found or inaccessible.
    echo Make sure the path is correct and try again.
    goto end
)

rem Ask to select the output format
echo.
echo Select output format:
echo 1. WebM (VP9) - Best for web streaming
echo 2. MP4 (H.264) - Better compatibility
set FORMAT_CHOICE=
set /p FORMAT_CHOICE="Enter your choice (1-2) [1]: "

rem Set the chosen format
set FORMAT=webm
set VIDEO_CODEC=libvpx-vp9
set AUDIO_CODEC=libopus
set AUDIO_SAMPLING=48000
set EXTENSION=webm
set CODEC_PARAMS=-deadline good -cpu-used 2 -row-mt 1 -tile-columns 2 -frame-parallel 1 -auto-alt-ref 1 -lag-in-frames 25 -speed 2 -b:v 0 -threads 0

if "!FORMAT_CHOICE!"=="2" (
    set FORMAT=mp4
    set VIDEO_CODEC=libx264
    set AUDIO_CODEC=aac
    set AUDIO_SAMPLING=44100
    set EXTENSION=mp4
    set CODEC_PARAMS=-preset medium -profile:v high -level 4.1 -threads 0
)

rem Ask to enter the desire output file path and name without extension
echo.
set /p OUTPUT_PATH="Enter the desired output file path and name (without extension): "

rem Remove surrounding quotes from output path if present
set OUTPUT_FILE=!OUTPUT_PATH!
set OUTPUT_FILE=!OUTPUT_FILE:"=!

rem Ensure the output has the correct extension
set OUTPUT_FILE=!OUTPUT_FILE!.!EXTENSION!

rem Ask to select the resolution
echo.
echo Select resolution:
echo 1. 1080p (recommended)
echo 2. 720p
echo 3. 480p
echo 4. Original (maintain source resolution)
set RES_CHOICE=
set /p RES_CHOICE="Enter your choice (1-4) [1]: "

rem Set the chosen resolution
set RESOLUTION=1080
set SCALE_FILTER=scale=-2:!RESOLUTION!:flags=lanczos
if "!RES_CHOICE!"=="2" set RESOLUTION=720
if "!RES_CHOICE!"=="3" set RESOLUTION=480
if "!RES_CHOICE!"=="4" (
    set RESOLUTION=original
    set SCALE_FILTER=null
)

rem Ask to select the frame rate
echo.
echo Select frame rate:
echo 1. 60fps (smoothest motion)
echo 2. 30fps (recommended to tutorials)
echo 3. 24fps (film-like)
echo 4. Original (maintain source frame rate)
set FPS_CHOICE=
set /p FPS_CHOICE="Enter your choice (1-4) [2]: "

rem Set the chosen FPS
set FPS=30
set FPS_FILTER=fps=!FPS!
if "!FPS_CHOICE!"=="1" set FPS=60
if "!FPS_CHOICE!"=="3" set FPS=24
if "!FPS_CHOICE!"=="4" (
    set FPS=original
    set FPS_FILTER=
)

rem Ask to select audio quality
echo.
echo Select audio quality:
echo 1. High (128kbps - clear narration)
echo 2. Medium (96kbps - recommended for tutorials)
echo 3. Low (64kbps - smaller file size)
set AUDIO_CHOICE=
set /p AUDIO_CHOICE="Enter your choice (1-3) [1]: "

rem Set the audio bitrate
set AUDIO_BITRATE=96k
if "!AUDIO_CHOICE!"=="1" set AUDIO_BITRATE=128k
if "!AUDIO_CHOICE!"=="3" set AUDIO_BITRATE=64k

rem Ask to select the optimization preset
echo.
echo Select optimization preset:
echo 1. Text-heavy (code, documents)
echo 2. Balanced (general tutorials)
echo 3. Motion-heavy (UI demos, animations)
set PRESET_CHOICE=
set /p PRESET_CHOICE="Enter your choice (1-3) [2]: "

rem Set default quality settings
set CRF=23
set SHARPNESS=0.5
set DENOISE=0
set USE_TWO_PASS=N
set TUNE_OPTION=
set SCENE_DETECT=N
set AUDIO_NORM=N
set CREATE_THUMBNAIL=N

rem Dynamic CRF based on resolution
if "!RESOLUTION!"=="1080" (
    if "!VIDEO_CODEC!"=="libvpx-vp9" (
        set CRF=22
    ) else (
        set CRF=21
    )
) else if "!RESOLUTION!"=="720" (
    if "!VIDEO_CODEC!"=="libvpx-vp9" (
        set CRF=21
    ) else (
        set CRF=20
    )
) else if "!RESOLUTION!"=="480" (
    if "!VIDEO_CODEC!"=="libvpx-vp9" (
        set CRF=20
    ) else (
        set CRF=19
    )
)

rem Ask about two-pass encoding
if "!VIDEO_CODEC!"=="libvpx-vp9" (
    echo.
    echo Would you like to use two-pass encoding for better quality?
    echo This will increase processing time but improve quality for the same file size.
    echo 1. Yes - Better quality (recommended for final renders)
    echo 2. No - Faster processing (good for testing)
    set TWOPASS_CHOICE=
    set /p TWOPASS_CHOICE="Enter your choice (1-2) [1]: "
    
    if not "!TWOPASS_CHOICE!"=="2" (
        set USE_TWO_PASS=Y
    )
)

rem Ask about scene detection
echo.
echo Use scene detection for improved keyframe placement?
echo This optimizes streaming by adding keyframes at scene changes.
echo 1. Yes - Better streaming (recommended)
echo 2. No - Standard keyframe interval
set SCENE_CHOICE=
set /p SCENE_CHOICE="Enter your choice (1-2) [1]: "

if not "!SCENE_CHOICE!"=="2" (
    set SCENE_DETECT=Y
)

rem Ask about audio normalization
echo.
echo Apply audio normalization for consistent volume levels?
echo 1. Yes - Normalize audio (recommended for varied audio sources)
echo 2. No - Keep original audio levels
set AUDIO_NORM_CHOICE=
set /p AUDIO_NORM_CHOICE="Enter your choice (1-2) [1]: "

if not "!AUDIO_NORM_CHOICE!"=="2" (
    set AUDIO_NORM=Y
)

rem Ask about thumbnail generation
echo.
echo Generate a thumbnail image from the video?
echo 1. Yes - Create thumbnail
echo 2. No - Skip thumbnail creation
set THUMB_CHOICE=
set /p THUMB_CHOICE="Enter your choice (1-2) [1]: "

if not "!THUMB_CHOICE!"=="2" (
    set CREATE_THUMBNAIL=Y
)

rem Set tune option based on preset choice
if "!PRESET_CHOICE!"=="1" (
    rem Text-heavy preset
    if "!VIDEO_CODEC!"=="libx264" (
        set TUNE_OPTION=stillimage,ssim
    )
) else if "!PRESET_CHOICE!"=="3" (
    rem Motion-heavy preset
    if "!VIDEO_CODEC!"=="libx264" (
        set TUNE_OPTION=animation
    )
) else (
    rem Balanced preset
    if "!VIDEO_CODEC!"=="libx264" (
        set TUNE_OPTION=grain
    )
)

rem Update codec params with appropriate tune option for x264
if "!VIDEO_CODEC!"=="libx264" (
    if not "!TUNE_OPTION!"=="" (
        set CODEC_PARAMS=!CODEC_PARAMS! -tune !TUNE_OPTION!
    )
)

rem Set keyframe options
set KEYFRAME_OPTS=-g 240 -keyint_min 48
if "!SCENE_DETECT!"=="Y" (
    set KEYFRAME_OPTS=!KEYFRAME_OPTS! -force_key_frames "expr:gte(t,n_forced*5)"
    if "!VIDEO_CODEC!"=="libx264" (
        set KEYFRAME_OPTS=!KEYFRAME_OPTS! -sc_threshold 40
    )
)

rem Set audio normalization
set AUDIO_NORM_FILTER=
if "!AUDIO_NORM!"=="Y" (
    set AUDIO_NORM_FILTER=loudnorm=I=-16:LRA=11:TP=-1.5,
)

rem Adjust CRF based on preset and codec
if "!PRESET_CHOICE!"=="1" (
    rem Text-heavy preset with reduced sharpness
    if "!VIDEO_CODEC!"=="libvpx-vp9" (
        set CRF=20
    ) else (
        set CRF=19
    )
    set SHARPNESS=1.0
    set DENOISE=0.1
    
    if "!RESOLUTION!"=="original" (
        set FILTER_COMPLEX="!FPS_FILTER!,unsharp=3:3:!SHARPNESS!:3:3:0"
    ) else (
        set FILTER_COMPLEX="!FPS_FILTER!,!SCALE_FILTER!,unsharp=3:3:!SHARPNESS!:3:3:0"
    )
) else if "!PRESET_CHOICE!"=="3" (
    rem Motion-heavy preset
    if "!VIDEO_CODEC!"=="libvpx-vp9" (
        set CRF=23
    ) else (
        set CRF=22
    )
    set SHARPNESS=0.3
    set DENOISE=0.8
    
    if "!RESOLUTION!"=="original" (
        set FILTER_COMPLEX="!FPS_FILTER!,hqdn3d=!DENOISE!:!DENOISE!:1:1,unsharp=3:3:!SHARPNESS!:3:3:0"
    ) else (
        set FILTER_COMPLEX="!FPS_FILTER!,!SCALE_FILTER!,hqdn3d=!DENOISE!:!DENOISE!:1:1,unsharp=3:3:!SHARPNESS!:3:3:0"
    )
) else (
    rem Balanced preset
    if "!VIDEO_CODEC!"=="libvpx-vp9" (
        set CRF=21
    ) else (
        set CRF=21
    )
    set SHARPNESS=0.6
    set DENOISE=0.4
    
    if "!RESOLUTION!"=="original" (
        set FILTER_COMPLEX="!FPS_FILTER!,hqdn3d=!DENOISE!:!DENOISE!:0.5:0.5,unsharp=3:3:!SHARPNESS!:3:3:0"
    ) else (
        set FILTER_COMPLEX="!FPS_FILTER!,!SCALE_FILTER!,hqdn3d=!DENOISE!:!DENOISE!:0.5:0.5,unsharp=3:3:!SHARPNESS!:3:3:0"
    )
)

rem Calculate approximate output file size
echo.
echo Calculating approximate file size...
for /f "tokens=*" %%i in ('ffprobe -v error -select_streams v:0 -show_entries stream^=duration -of default^=noprint_wrappers^=1:nokey^=1 "!INPUT_FILE!"') do set VIDEO_DURATION=%%i

rem Remove decimal point from duration
set VIDEO_DURATION=!VIDEO_DURATION:.=!

rem Check if duration is valid
if not defined VIDEO_DURATION (
    echo Error: Could not determine video duration.
    goto end
)

rem Calculate minutes
set /a MINUTES=!VIDEO_DURATION! / 60

rem Set approximate bitrate based on resolution and codec
if "!VIDEO_CODEC!"=="libvpx-vp9" (
    if "!RESOLUTION!"=="1080" (
        set /a APPROX_BITRATE=1500
    ) else if "!RESOLUTION!"=="720" (
        set /a APPROX_BITRATE=1000
    ) else if "!RESOLUTION!"=="480" (
        set /a APPROX_BITRATE=700
    ) else (
        set /a APPROX_BITRATE=1200
    )
) else (
    if "!RESOLUTION!"=="1080" (
        set /a APPROX_BITRATE=2500
    ) else if "!RESOLUTION!"=="720" (
        set /a APPROX_BITRATE=1700
    ) else if "!RESOLUTION!"=="480" (
        set /a APPROX_BITRATE=1000
    ) else (
        set /a APPROX_BITRATE=2000
    )
)

rem Calculate total bitrate and estimated file size
set /a AUDIO_BITRATE_NUM=!AUDIO_BITRATE:k=!
set /a TOTAL_BITRATE=!APPROX_BITRATE! + !AUDIO_BITRATE_NUM!
set /a EST_SIZE_MB=(!TOTAL_BITRATE! * !MINUTES! * 60) / 8 / 1024

echo.
echo Processing with these settings:
echo Input: "!INPUT_FILE!"
echo Output: "!OUTPUT_FILE!" (Format: !FORMAT!, Codec: !VIDEO_CODEC!)
if "!RESOLUTION!"=="original" (
    echo Resolution: Original
) else (
    echo Resolution: !RESOLUTION!p
)
if "!FPS!"=="original" (
    echo Frame rate: Original
) else (
    echo Frame rate: !FPS!fps
)
echo Audio bitrate: !AUDIO_BITRATE!
echo Video quality: CRF !CRF!
if "!VIDEO_CODEC!"=="libx264" echo Tune: !TUNE_OPTION!
if "!USE_TWO_PASS!"=="Y" echo Two-pass encoding: Yes
if "!SCENE_DETECT!"=="Y" echo Scene detection: Enabled
if "!AUDIO_NORM!"=="Y" echo Audio normalization: Enabled
if "!CREATE_THUMBNAIL!"=="Y" echo Thumbnail creation: Enabled
echo Estimated file size: ~!EST_SIZE_MB! MB
echo.

rem Ask if want to proceed with the chosen settings
:confirm
echo.
echo Do you want to proceed with these settings? (Y/N)
set /p PROCEED="> "
if /i "!PROCEED!"=="Y" (
    goto proceed
) else if /i "!PROCEED!"=="N" (
    echo Discarding settings and returning to start...
    goto start
) else (
    echo Invalid choice. Please enter Y or N.
    goto confirm
)

:proceed
echo.
echo Converting video... Please wait...
echo This may take several minutes depending on the size of your video.
echo.

rem Set color space parameters
set COLOR_PARAMS=-colorspace bt709 -color_primaries bt709 -color_trc bt709

rem Set audio filters
set AUDIO_FILTERS=-af "!AUDIO_NORM_FILTER!aresample=async=1:min_hard_comp=0.100000:first_pts=0"

rem For two-pass VP9 encoding
if "!USE_TWO_PASS!"=="Y" (
    if "!VIDEO_CODEC!"=="libvpx-vp9" (
	    echo.
        echo Running first pass to check the file...
        ffmpeg -y -i "!INPUT_FILE!" ^
            -map_metadata -1 ^
            -c:v !VIDEO_CODEC! -crf !CRF! !CODEC_PARAMS! -pass 1 ^
            -an ^
            -f null NUL ^
			-loglevel quiet > NUL 2>&1
        echo.    
        echo Running second pass to convert and optimize...
        ffmpeg -i "!INPUT_FILE!" ^
            -map_metadata -1 ^
            -fflags +bitexact ^
            -flags:v +bitexact ^
            -flags:a +bitexact ^
            -c:v !VIDEO_CODEC! -crf !CRF! !CODEC_PARAMS! -pass 2 ^
            !KEYFRAME_OPTS! ^
            -c:a !AUDIO_CODEC! -b:a !AUDIO_BITRATE! -ar !AUDIO_SAMPLING! ^
            !AUDIO_FILTERS! ^
            -vf !FILTER_COMPLEX! ^
            !COLOR_PARAMS! ^
            -movflags +faststart ^
            -pix_fmt yuv420p ^
            "!OUTPUT_FILE!" ^
            -stats -loglevel warning
                    
        del ffmpeg2pass-0.log 2>NUL
        del ffmpeg2pass-0.log.mbtree 2>NUL
    ) else (
        echo Two-pass encoding is only available for VP9 codec. Using single-pass...
        goto single_pass
    )
) else (
    :single_pass
    ffmpeg -i "!INPUT_FILE!" ^
        -map_metadata -1 ^
        -fflags +bitexact ^
        -flags:v +bitexact ^
        -flags:a +bitexact ^
        -c:v !VIDEO_CODEC! -crf !CRF! !CODEC_PARAMS! ^
        !KEYFRAME_OPTS! ^
        -c:a !AUDIO_CODEC! -b:a !AUDIO_BITRATE! -ar !AUDIO_SAMPLING! ^
        !AUDIO_FILTERS! ^
        -vf !FILTER_COMPLEX! ^
        !COLOR_PARAMS! ^
        -movflags +faststart ^
        -pix_fmt yuv420p ^
        "!OUTPUT_FILE!" ^
        -stats -loglevel warning
)

echo.
echo Conversion completed successfully!
echo Output file: "!OUTPUT_FILE!"

rem Generate thumbnail if requested
if "!CREATE_THUMBNAIL!"=="Y" (
    echo.
    echo Generating thumbnail...
    ffmpeg -i "!INPUT_FILE!" -ss 00:00:05 -vframes 1 -vf "scale=!RESOLUTION!:-2:flags=lanczos" -q:v 2 -update 1 "!OUTPUT_FILE!.png" -y -loglevel warning
    echo Thumbnail created: "!OUTPUT_FILE!.png"
)

echo.
echo File information:
ffprobe -v error -select_streams v:0 -show_entries stream=width,height,codec_name,r_frame_rate -of default=noprint_wrappers=1 "!OUTPUT_FILE!"
echo.
ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate,bit_rate -of default=noprint_wrappers=1 "!OUTPUT_FILE!"
echo.

:ask_another
echo.
echo Would you like to convert another video? (Y/N)
set /p ANOTHER="> "
if /i "!ANOTHER!"=="Y" (
    goto start
) else if /i "!ANOTHER!"=="N" (
    goto end
) else (
    echo Invalid choice. Please enter Y or N.
    goto ask_another
)

:end
echo.
echo Press any key to exit...
pause > nul
