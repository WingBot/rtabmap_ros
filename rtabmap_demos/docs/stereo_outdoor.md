# Stereo Outdoor Mapping Demo

## Overview
This demo demonstrates RTAB-Map's stereo vision SLAM capabilities for outdoor environments. It processes stereo camera data to create 3D maps without requiring additional depth sensors, making it ideal for outdoor robotics applications where structured light sensors may not be effective.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- stereo_image_proc package for stereo processing
- image_transport for image compression/decompression
- rosbag for data playback

### Hardware Requirements
- **For live use**: Calibrated stereo camera rig
- **For demo**: Recorded stereo bag file with outdoor data

### Installation
```bash
# Install required packages
sudo apt-get install ros-noetic-rtabmap-ros ros-noetic-stereo-image-proc ros-noetic-image-transport-plugins

# Verify stereo_image_proc is available
rospack find stereo_image_proc
```

## Dataset Information

### Required Bag File Topics
The demo expects a bag file containing:
```
/stereo_camera/left/image_raw_throttle/compressed   # Left camera image (compressed)
/stereo_camera/right/image_raw_throttle/compressed  # Right camera image (compressed)
/stereo_camera/left/camera_info_throttle            # Left camera calibration
/stereo_camera/right/camera_info_throttle           # Right camera calibration
/tf                                                 # Transform tree
```

### Recording Your Own Data
To record stereo data for this demo:
```bash
rosbag record \
  /stereo_camera/left/image_raw_throttle/compressed \
  /stereo_camera/right/image_raw_throttle/compressed \
  /stereo_camera/left/camera_info_throttle \
  /stereo_camera/right/camera_info_throttle \
  /tf
```

## Setup Instructions

### 1. Prepare the Stereo Bag File
Ensure you have a stereo bag file with the required topics. The example mentions `stereo_outdoor.bag`.

### 2. Launch the Demo
```bash
# Start the stereo outdoor mapping demo
roslaunch rtabmap_demos demo_stereo_outdoor.launch
```

### 3. Play the Bag File
```bash
# Play the stereo bag file with clock simulation
rosbag play --clock stereo_outdoor.bag
```

### Alternative Visualization Options
```bash
# Use RViz instead of RTAB-Map visualization
roslaunch rtabmap_demos demo_stereo_outdoor.launch rviz:=true rtabmap_viz:=false

# Disable stereo synchronization (if having timing issues)
roslaunch rtabmap_demos demo_stereo_outdoor.launch stereo_sync:=false

# Disable local bundle adjustment
roslaunch rtabmap_demos demo_stereo_outdoor.launch local_bundle:=false
```

## Usage Instructions

### Basic Operation
1. **Launch the demo** with your preferred visualization settings
2. **Start bag playback** using `rosbag play --clock`
3. **Monitor the processing**:
   - Stereo rectification and disparity calculation
   - Feature extraction and matching
   - Map building and loop closure detection

### Processing Pipeline
The demo follows this processing chain:
1. **Image decompression**: Decompress left/right images
2. **Stereo rectification**: Correct lens distortion and align stereo pair
3. **Disparity calculation**: Compute depth from stereo correspondence
4. **Point cloud generation**: Create 3D points from disparity
5. **SLAM processing**: Extract features and build map

### Monitoring Progress
Watch for these indicators:
- Disparity images showing depth information
- Feature matches between frames
- Loop closure detections
- 3D point cloud accumulation

## Configuration Parameters

### Key Launch Arguments
- `rviz` (default: true): Enable RViz visualization
- `rtabmap_viz` (default: false): Enable RTAB-Map visualization  
- `local_bundle` (default: true): Enable local bundle adjustment
- `stereo_sync` (default: false): Enable approximate stereo synchronization

### Stereo Processing Parameters
The demo automatically configures stereo_image_proc with:
- Image rectification
- Disparity computation
- Point cloud generation

### RTAB-Map Parameters
Key parameters for stereo outdoor mapping:
- `subscribe_stereo`: true (process stereo input)
- `Stereo/MaxDisparity`: 128.0 (maximum disparity in pixels)
- `RGBD/CreateOccupancyGrid`: false (use 3D mapping)
- `Vis/EstimationType`: 1 (3D visual odometry)

## Expected Output

### Topics Published
- `/stereo_camera/disparity`: Disparity image
- `/stereo_camera/points2`: Stereo point cloud
- `/rtabmap/cloud_map`: Accumulated 3D map
- `/rtabmap/grid_map`: 2D occupancy grid (if enabled)

### Visualization
- **Disparity image**: Shows depth information as grayscale
- **3D point cloud**: Real-time stereo reconstruction
- **Map accumulation**: Progressive 3D map building
- **Feature tracks**: Visual feature correspondences

### Performance Metrics
```
Stereo processing: X.X Hz
Features: XXX (left) / XXX (right)  
Inliers: XXX / XXX
Loop closures: X detected
```

## Understanding Stereo Processing

### Disparity Quality
Good stereo results require:
- **Proper calibration**: Accurate intrinsic and extrinsic parameters
- **Adequate baseline**: Sufficient separation between cameras
- **Textured environment**: Rich visual features for correspondence
- **Appropriate lighting**: Avoid overexposure or shadows

### Depth Range
Stereo depth range depends on:
- **Baseline**: Wider baseline = better distant depth
- **Focal length**: Longer focal length = better distant depth  
- **Image resolution**: Higher resolution = better precision
- **Disparity range**: Configurable maximum disparity

## Troubleshooting

### Common Issues

1. **Poor disparity quality**:
   ```bash
   # Check camera calibration
   rostopic echo /stereo_camera/left/camera_info
   
   # Verify stereo rectification
   rosrun image_view stereo_view stereo:=/stereo_camera image:=image_rect_color
   ```

2. **Synchronization problems**:
   ```bash
   # Enable approximate sync if timestamps don't match exactly
   roslaunch rtabmap_demos demo_stereo_outdoor.launch stereo_sync:=true
   ```

3. **Slow processing**:
   ```bash
   # Reduce disparity range
   rosparam set /stereo_image_proc/disparity_range 64
   
   # Reduce image resolution or frame rate
   ```

4. **No depth information**:
   - Verify stereo calibration quality
   - Check for adequate texture in the scene
   - Ensure proper camera synchronization

### Performance Optimization
- Use hardware-accelerated stereo processing if available
- Optimize disparity parameters for your scene
- Consider reducing image resolution for real-time operation
- Tune RTAB-Map parameters for outdoor environments

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_stereo_outdoor.launch`
- **No specific dataset**: Requires user-provided stereo bag file

## Advanced Configuration

### Custom Stereo Setup
For different stereo rigs, modify:
```xml
<!-- Update topic names for your stereo setup -->
<remap from="left/image_rect_color" to="/your_stereo/left/image_rect_color"/>
<remap from="right/image_rect_color" to="/your_stereo/right/image_rect_color"/>
<remap from="left/camera_info" to="/your_stereo/left/camera_info"/>
<remap from="right/camera_info" to="/your_stereo/right/camera_info"/>
```

### Stereo Parameters
Key stereo_image_proc parameters to tune:
```bash
# Disparity calculation
rosparam set /stereo_image_proc/correlation_window_size 15
rosparam set /stereo_image_proc/min_disparity 0
rosparam set /stereo_image_proc/disparity_range 128

# Uniqueness and texture filtering
rosparam set /stereo_image_proc/uniqueness_ratio 15.0
rosparam set /stereo_image_proc/texture_threshold 10
```

## Related Documentation
- [stereo_image_proc Documentation](http://wiki.ros.org/stereo_image_proc)
- [Camera Calibration Tutorial](http://wiki.ros.org/camera_calibration/Tutorials)
- [RTAB-Map Stereo Configuration](https://github.com/introlab/rtabmap/wiki/Stereo-camera)