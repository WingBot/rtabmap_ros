# Two Kinects Demo

## Overview
This demo demonstrates multi-camera SLAM using two Microsoft Kinect sensors positioned at different angles. It showcases RTAB-Map's ability to handle multiple RGB-D cameras simultaneously, providing increased field of view and mapping robustness through sensor redundancy.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- freenect_launch package for Kinect drivers
- Multiple USB 3.0 ports or powered USB hubs

### Hardware Requirements
- **Two Microsoft Kinect sensors** (Kinect v1 or Kinect for Xbox 360)
- **USB connections**: Each Kinect requires separate USB connection
- **Power supply**: Kinects need adequate power (use powered USB hubs if necessary)
- **Physical mounting**: Rigid mounting system for both cameras

### Installation
```bash
# Install Kinect drivers and RTAB-Map
sudo apt-get install ros-noetic-freenect-launch ros-noetic-rtabmap-ros

# Install libfreenect if not already installed
sudo apt-get install libfreenect-dev
```

## Hardware Setup

### Physical Configuration
The demo assumes a specific geometric arrangement:
- **Camera 1**: Positioned at origin (base_link)
- **Camera 2**: Positioned 90 degrees clockwise relative to Camera 1
- **Offset**: Camera 2 at (-0.1325, -0.1975, 0.0) meters from Camera 1

### Mounting Considerations
1. **Rigid mounting**: Ensure both Kinects are firmly mounted
2. **Overlap**: Configure for some field-of-view overlap between cameras
3. **Calibration**: Both cameras should be properly calibrated
4. **Power**: Ensure stable power supply for both sensors

## Setup Instructions

### 1. Connect Hardware
```bash
# Connect both Kinects to separate USB ports
# Verify both devices are recognized
lsusb | grep Microsoft

# Should show two Kinect entries with different device IDs
```

### 2. Launch the Demo
```bash
# Start the dual Kinect SLAM demo
roslaunch rtabmap_demos demo_two_kinects.launch
```

### 3. Verify Sensor Data
```bash
# Check both camera feeds
rostopic list | grep -E "(camera1|camera2)"

# Monitor data rates
rostopic hz /camera1/rgb/image_raw
rostopic hz /camera2/rgb/image_raw
```

## Configuration Details

### Camera Setup
The launch file automatically configures:

#### Camera 1 (Primary)
```xml
<include file="$(find freenect_launch)/launch/freenect.launch">
  <arg name="depth_registration" value="True" />
  <arg name="camera" value="camera1" />
  <arg name="device_id" value="#1" />
</include>
```

#### Camera 2 (Secondary)
```xml
<include file="$(find freenect_launch)/launch/freenect.launch">
  <arg name="depth_registration" value="True" />
  <arg name="camera" value="camera2" />
  <arg name="device_id" value="#2" />
</include>
```

### Transform Configuration
Static transforms define the spatial relationship:
```xml
<!-- Camera 1 at origin -->
<node pkg="tf" type="static_transform_publisher" name="base_to_camera1_tf"
    args="0.0 0.0 0.0 0.0 0.0 0.0 /base_link /camera1_link 100" />

<!-- Camera 2 at 90 degrees -->
<node pkg="tf" type="static_transform_publisher" name="base_to_camera2_tf"
    args="-0.1325 -0.1975 0.0 -1.570796327 0.0 0.0 /base_link /camera2_link 100" />
```

## Usage Instructions

### Basic Operation
1. **Verify both cameras**: Ensure both Kinects are streaming data
2. **Check transforms**: Verify TF tree shows both camera frames
3. **Monitor SLAM**: Watch map building with dual camera input
4. **Move the rig**: Translate/rotate to explore environment

### Multi-camera Advantages
- **Increased FOV**: Combined field of view from both cameras
- **Redundancy**: Continue operation if one camera fails
- **Better features**: More visual features from multiple viewpoints
- **Robust tracking**: Enhanced pose estimation with dual sensors

### Troubleshooting Camera Issues
```bash
# Check individual camera functionality
roslaunch freenect_launch freenect.launch camera:=camera1 device_id:="#1"
roslaunch freenect_launch freenect.launch camera:=camera2 device_id:="#2"

# Verify USB bandwidth
lsusb -t
# Ensure cameras are on separate USB controllers if possible
```

## Configuration Parameters

### Key Launch Arguments
- `rviz` (default: false): Enable RViz visualization
- `rtabmap_viz` (default: true): Enable RTAB-Map visualization

### RTAB-Map Multi-camera Parameters
The demo configures RTAB-Map for optimal multi-camera performance:
- **Feature distribution**: Balanced feature extraction across cameras
- **Synchronization**: Temporal alignment of multi-camera data
- **Transformation**: Proper handling of multiple camera frames

### RGBD Odometry Parameters
Key parameters for dual-camera odometry:
- `strategy`: Frame-to-Map (0) or Frame-to-Frame (1)
- `feature`: Feature detector type (SURF, SIFT, ORB, etc.)
- `max_depth`: Maximum depth for feature extraction
- `min_inliers`: Minimum correspondences for pose estimation

## Expected Output

### Multi-camera Data Streams
```bash
# Camera 1 topics
/camera1/rgb/image_raw
/camera1/depth_registered/image_raw
/camera1/rgb/camera_info

# Camera 2 topics  
/camera2/rgb/image_raw
/camera2/depth_registered/image_raw
/camera2/rgb/camera_info
```

### SLAM Performance
- **Enhanced features**: More visual features from dual cameras
- **Improved tracking**: Better pose estimation accuracy
- **Robustness**: Continued operation with partial camera failure
- **Larger mapping area**: Extended coverage per movement

### Visualization Features
- **Dual point clouds**: Separate point clouds from each camera
- **Merged map**: Combined mapping result
- **Transform visualization**: Camera pose relationships
- **Feature tracking**: Multi-camera feature correspondences

## Advanced Configuration

### Custom Camera Positioning
Modify transform publishers for different arrangements:
```xml
<!-- Example: Side-by-side configuration -->
<node pkg="tf" type="static_transform_publisher" name="base_to_camera2_tf"
    args="0.2 0.0 0.0 0.0 0.0 0.0 /base_link /camera2_link 100" />
```

### Camera Calibration
For optimal performance, calibrate each camera:
```bash
# Calibrate camera 1
rosrun camera_calibration cameracalibrator.py \
  --size 8x6 --square 0.108 \
  image:=/camera1/rgb/image_raw camera:=/camera1/rgb

# Calibrate camera 2
rosrun camera_calibration cameracalibrator.py \
  --size 8x6 --square 0.108 \
  image:=/camera2/rgb/image_raw camera:=/camera2/rgb
```

### Synchronization Tuning
```bash
# Adjust synchronization parameters if needed
rosparam set /rtabmap/rtabmap/approx_sync true
rosparam set /rtabmap/rtabmap/queue_size 10
```

## Troubleshooting

### Common Issues

1. **One camera not detected**:
   ```bash
   # Check USB connections
   lsusb | grep Microsoft
   
   # Verify device permissions
   ls -l /dev/video*
   
   # Try different USB ports
   ```

2. **USB bandwidth issues**:
   ```bash
   # Reduce image resolution
   rosparam set /camera1/rgb/image_width 320
   rosparam set /camera1/rgb/image_height 240
   
   # Reduce frame rate
   rosparam set /camera1/driver/data_skip 2
   ```

3. **Synchronization problems**:
   ```bash
   # Check timestamp alignment
   rostopic echo /camera1/rgb/image_raw/header
   rostopic echo /camera2/rgb/image_raw/header
   
   # Enable approximate synchronization
   rosparam set /rtabmap/rtabmap/approx_sync true
   ```

4. **Poor multi-camera performance**:
   - Verify camera calibration quality
   - Check transform accuracy
   - Ensure adequate lighting for both cameras
   - Monitor system resources (CPU, memory)

### Performance Optimization
- **USB allocation**: Use separate USB controllers for each camera
- **Processing power**: Ensure adequate CPU for dual-camera processing
- **Memory usage**: Monitor RAM consumption with dual streams
- **Network bandwidth**: Consider data compression if using remote processing

## Applications

### Suitable Use Cases
- **Wide-area mapping**: Environments requiring broad coverage
- **Redundant systems**: Applications requiring fault tolerance
- **Research platforms**: Multi-camera SLAM algorithm development
- **Inspection tasks**: Comprehensive visual documentation

### Environment Requirements
- **Good lighting**: Adequate illumination for both cameras
- **Textured surfaces**: Rich visual features for tracking
- **Stable mounting**: Minimize camera shake and vibration
- **Power availability**: Reliable power for dual cameras

## Limitations and Considerations

### Hardware Limitations
- **USB bandwidth**: Limited by USB controller capacity
- **Power consumption**: Two cameras require more power
- **Heat generation**: Extended operation may cause overheating
- **Synchronization**: Slight timing differences between cameras

### Software Considerations
- **Computational load**: Increased processing requirements
- **Memory usage**: Higher RAM consumption
- **Calibration complexity**: More parameters to calibrate
- **Debug complexity**: More complex troubleshooting

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_two_kinects.launch`
- **Dependencies**: freenect_launch drivers
- **Calibration**: Camera calibration files (if created)

## Related Documentation
- [freenect_launch Documentation](http://wiki.ros.org/freenect_launch)
- [Multi-camera Calibration](http://wiki.ros.org/camera_calibration)
- [RTAB-Map Multi-camera Setup](https://github.com/introlab/rtabmap/wiki/Multi-cameras)
- [USB Camera Troubleshooting](http://wiki.ros.org/usb_cam/Troubleshooting)