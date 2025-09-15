# Appearance-based Mapping Demo

## Overview
This demo showcases RTAB-Map's appearance-based loop closure detection capability without using depth information. It processes a sequence of 2D images to perform visual SLAM using only camera appearance features, making it suitable for monocular camera setups.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- rtabmap_legacy package (for camera node)
- OpenCV with SURF feature detector support

### Hardware Requirements
- **For live demo**: USB camera or laptop webcam
- **For dataset demo**: No additional hardware needed (uses provided image sequence)

### Installation
```bash
# Install RTAB-Map packages
sudo apt-get install ros-noetic-rtabmap-ros

# Ensure SURF support (may require building from source if not available)
# Check with: rosrun rtabmap rtabmap --params | grep SURF
```

## Dataset Information
The demo includes a sample image sequence located at:
```
rtabmap_demos/launch/data/demo_appearance/
```

This dataset contains indoor office/lab images suitable for demonstrating visual loop closure detection.

## Setup Instructions

### Option 1: Using Provided Dataset (Recommended for first try)
1. **Launch the demo**:
   ```bash
   roslaunch rtabmap_demos demo_appearance_mapping.launch
   ```

2. The demo will automatically:
   - Load images from the demo_appearance directory
   - Process them at 2 Hz
   - Display RTAB-Map visualization
   - Stop after processing all images once

### Option 2: Using Live Camera
1. **Modify the launch file** to use your camera:
   ```bash
   # Edit the launch file to change device_id and remove video_or_images_path
   roscd rtabmap_demos/launch
   cp demo_appearance_mapping.launch demo_appearance_mapping_live.launch
   ```

2. **Edit the camera parameters**:
   ```xml
   <!-- In demo_appearance_mapping_live.launch, modify the camera node -->
   <param name="device_id" value="0" type="int"/>  <!-- Your camera ID -->
   <param name="video_or_images_path" value="" type="string"/>  <!-- Empty for live camera -->
   <param name="auto_restart" value="true" type="bool"/>  <!-- Keep running -->
   ```

3. **Launch with live camera**:
   ```bash
   roslaunch rtabmap_demos demo_appearance_mapping_live.launch
   ```

## Usage Instructions

### Basic Operation
1. **Monitor the visualization**: The RTAB-Map visualization window will show:
   - Current camera image
   - Feature matches
   - Loop closure detections
   - Memory statistics

2. **Understanding the output**:
   - Green lines indicate successful loop closures
   - Red rejected matches show the system's robustness
   - The graph shows the topological map structure

### Interactive Controls
- **Pause/Resume**: Use the GUI pause button to control processing
- **Parameters**: Adjust detection thresholds in real-time
- **View modes**: Switch between different visualization modes

## Configuration Parameters

### Key Launch Arguments
- `localization` (default: false): Enable localization-only mode

### Important RTAB-Map Parameters
- `RGBD/Enabled`: Set to "false" for appearance-based mode
- `Rtabmap/DetectionRate`: "0" = process at camera rate (2 Hz)
- `Mem/RehearsalSimilarity`: "0.4" = 40% similarity threshold for loop closure
- `Mem/STMSize`: "15" = short-term memory size
- `Kp/DetectorStrategy`: "0" = use SURF features
- `SURF/HessianThreshold`: "100" = SURF detection threshold

### Camera Configuration
- `frame_rate`: 2.0 Hz (can be adjusted for different processing speeds)
- `auto_restart`: false (process dataset once) / true (continuous for live camera)

## Expected Output

### Console Output
```
[ INFO]: rtabmap: Update rate=2.00s, Limit=0.000s, RTAB-Map=0.000s, Maps update=0.000s pub=0.000s (local map=1, WM=15)
[ INFO]: rtabmap: Features extracted = 150
[ INFO]: rtabmap: Loop closure detected! (ID=X)
```

### Visualization
- **Camera view**: Current processed image with detected features
- **Graph view**: Topological map with nodes and loop closures
- **Statistics**: Memory usage, timing information, and detection rates

### Database Output
- Creates `rtabmap.db` containing the visual map
- Can be loaded later for localization or further mapping

## Understanding the Results

### Loop Closure Indicators
- **Successful closures**: Indicated by connecting lines in the graph
- **Feature count**: Higher feature counts generally improve performance
- **Similarity scores**: Values above the threshold (0.4) trigger loop closure evaluation

### Performance Metrics
- **Processing time**: Should be reasonable for real-time operation
- **Memory usage**: Short-term memory (STM) and working memory (WM) sizes
- **Detection rate**: Frequency of successful loop closure detections

## Troubleshooting

### Common Issues
1. **No SURF features detected**:
   - Check if RTAB-Map was compiled with SURF support
   - Verify adequate lighting and texture in images
   - Lower SURF/HessianThreshold if needed

2. **Few loop closures detected**:
   - Ensure the camera returns to previously seen areas
   - Adjust Mem/RehearsalSimilarity threshold
   - Check image quality and feature richness

3. **Processing too slow**:
   - Reduce camera frame rate
   - Lower image resolution
   - Adjust SURF parameters for faster detection

### Performance Tips
- Provide rich visual environments with good texture
- Ensure adequate but not excessive lighting
- Move the camera smoothly without rapid motions
- Create clear loops by returning to starting positions

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_appearance_mapping.launch`
- **Image dataset**: `rtabmap_demos/launch/data/demo_appearance/`
- **Config**: `rtabmap_demos/launch/config/appearance_gui.ini`

## Advanced Usage

### Custom Image Sequences
Replace the demo_appearance directory with your own image sequence:
```bash
# Create your image directory
mkdir -p /path/to/your/images

# Update launch file parameter
<param name="video_or_images_path" value="/path/to/your/images" type="string"/>
```

### Video Files
You can also use video files instead of image sequences:
```bash
<param name="video_or_images_path" value="/path/to/your/video.mp4" type="string"/>
```

## Related Documentation
- [RTAB-Map Parameters](http://wiki.ros.org/rtabmap_ros#Parameters)
- [Visual SLAM Tutorial](https://github.com/introlab/rtabmap/wiki)
- [Loop Closure Detection](https://github.com/introlab/rtabmap/wiki/Loop-closure-detection)