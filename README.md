# Advanced Tutorial Video Converter Script

This script is a powerful and customizable batch file designed to convert video files into optimized formats for tutorials, presentations, and general use. It leverages **FFmpeg** to provide advanced encoding options, including resolution scaling, frame rate adjustment, audio normalization, and more. The script is ideal for content creators, educators, and anyone who needs to process videos with specific quality and file size requirements.

## Key Features

1. **Input Flexibility**:
   - Accepts any video file as input.
   - Automatically removes surrounding quotes from file paths.

2. **Output Format Options**:
   - **WebM (VP9)**: Best for web streaming with high compression efficiency.
   - **MP4 (H.264)**: Better compatibility with most devices and platforms.

3. **Resolution Scaling**:
   - Supports 1080p, 720p, 480p, or original resolution.
   - Uses the Lanczos scaling algorithm for high-quality downscaling.

4. **Frame Rate Control**:
   - Options for 60fps, 30fps, 24fps, or original frame rate.

5. **Audio Quality Settings**:
   - High (128kbps), Medium (96kbps), or Low (64kbps) audio bitrate.
   - Optional audio normalization for consistent volume levels.

6. **Preset Modes**:
   - **Text-heavy**: Optimized for videos with text, code, or documents (sharper details, minimal denoising).
   - **Balanced**: General-purpose settings for most tutorials (moderate sharpness and denoising).
   - **Motion-heavy**: Ideal for UI demos or animations (smoother motion, higher denoising).

7. **Two-Pass Encoding**:
   - Optional two-pass encoding for VP9 to improve quality at the same file size.

8. **Scene Detection**:
   - Automatically detects scene changes for better keyframe placement.

9. **Thumbnail Generation**:
   - Optionally generates a thumbnail image from the video.

10. **File Size Estimation**:
    - Calculates and displays the approximate output file size before encoding.

11. **User Confirmation**:
    - Displays all settings and asks for confirmation before proceeding.

## How It Works

1. The script prompts the user for input file paths, output format, resolution, frame rate, and other settings.
2. It calculates the estimated file size and displays the chosen settings.
3. The user can confirm or discard the settings and start over.
4. FFmpeg is used to encode the video with the selected options.
5. Optionally, a thumbnail is generated from the video.

## Requirements

- **FFmpeg**: Ensure FFmpeg is installed and added to your system's PATH.
- **Windows**: The script is designed for Windows and uses batch file syntax.

## Usage

1. Download the script and save it as `video_converter.bat`.
2. Double-click the script to run it.
3. Follow the on-screen prompts to configure the video conversion.
4. The output file will be saved in the same directory as the input file (or the specified output path).

## Example Use Cases

- **Tutorials**: Convert screen recordings into optimized formats for online sharing.
- **Presentations**: Resize and compress videos for embedding in slideshows.
- **Web Streaming**: Create WebM files for efficient web playback.
- **Archiving**: Reduce file size while maintaining quality for long-term storage.

## Customization

- Modify the `SHARPNESS`, `DENOISE`, and `CRF` values in the script to fine-tune the output quality.
- Adjust the `CODEC_PARAMS` for advanced control over encoding settings.

## Notes

- The script is designed to be user-friendly but assumes basic familiarity with FFmpeg and video encoding concepts.
- Test the script with sample videos to ensure the output meets your expectations.

## License

This script is provided under the MIT License. Feel free to modify and distribute it as needed.

## GitHub Repository

For the latest updates and contributions, visit the [GitHub repository](https://github.com/HermesZum/Advanced-Video-Converter-and-Optimizer).

This description provides a comprehensive overview of the script's features, usage, and customization options, making it suitable for a GitHub repository or documentation file. Let me know if you need further adjustments!
