# Data Recorder Demo

## Overview
This demo provides a utility for recording sensor data from RTAB-Map sessions for later playback and analysis. It's useful for creating datasets, debugging SLAM performance, and sharing scenarios with the community.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- rosbag for data recording
- Robot drivers or sensor packages for your specific hardware

### Hardware Requirements
- Any robot or sensor setup supported by RTAB-Map
- Adequate disk space for recording (can be several GB per session)

## Setup Instructions

### 1. Configure Your Robot
Ensure your robot or sensor setup is working:
```bash
# Example for TurtleBot
roslaunch turtlebot_bringup minimal.launch

# Example for manual sensor setup
roslaunch your_robot_package sensors.launch
```

### 2. Launch the Data Recorder
```bash
roslaunch rtabmap_demos demo_data_recorder.launch
```

### 3. Start Recording
The recorder will save data to bags automatically, or you can control recording manually.

## Usage Instructions

### Automatic Recording
The demo can be configured to automatically record all relevant topics:
```bash
# Topics typically recorded:
# - Camera feeds (RGB, depth, camera_info)
# - Laser scans
# - Odometry
# - Transform tree (TF)
# - IMU data (if available)
```

### Manual Recording Control
```bash
# Start recording manually
rosbag record -O session_$(date +%Y%m%d_%H%M%S).bag \
  /camera/rgb/image_raw \
  /camera/depth/image_raw \
  /camera/rgb/camera_info \
  /scan \
  /odom \
  /tf \
  /imu/data
```

### Data Organization
Organize your recorded data:
```bash
# Create organized directory structure
mkdir -p ~/rtabmap_datasets/$(date +%Y%m%d)/
mv *.bag ~/rtabmap_datasets/$(date +%Y%m%d)/

# Add metadata
echo "Recording date: $(date)" > ~/rtabmap_datasets/$(date +%Y%m%d)/metadata.txt
echo "Environment: Office/Outdoor/Indoor" >> ~/rtabmap_datasets/$(date +%Y%m%d)/metadata.txt
```

## Configuration Parameters

### Recording Topics
Customize which topics to record:
```xml
<!-- In the launch file, modify the topics list -->
<arg name="topics" default="/camera/rgb/image_raw /camera/depth/image_raw /scan /odom /tf"/>
```

### Storage Options
- **Compression**: Enable bag compression to save disk space
- **Duration**: Set maximum recording duration
- **Size limits**: Limit bag file size
- **Split**: Split into multiple files for large sessions

### Quality Settings
```bash
# High quality (uncompressed)
rosbag record --lz4 /camera/rgb/image_raw

# Compressed (smaller files)
rosbag record /camera/rgb/image_raw/compressed
```

## Expected Output

### Recorded Files
- **Bag files**: `session_YYYYMMDD_HHMMSS.bag`
- **Metadata**: Session information and parameters
- **Checksums**: Verification data for integrity

### File Structure
```
~/rtabmap_datasets/
├── 20240315/
│   ├── session_20240315_143022.bag
│   ├── session_20240315_150130.bag
│   ├── metadata.txt
│   └── calibration_info.yaml
└── 20240316/
    └── ...
```

## Data Playback and Analysis

### Basic Playback
```bash
# Play back recorded data
rosbag play session_20240315_143022.bag

# Play with simulation time
rosbag play --clock session_20240315_143022.bag
```

### Analysis with RTAB-Map
```bash
# Use recorded data with any RTAB-Map demo
rosbag play --clock your_session.bag &
roslaunch rtabmap_demos demo_robot_mapping.launch
```

### Data Inspection
```bash
# Check bag file contents
rosbag info session_20240315_143022.bag

# Extract specific topics
rosbag filter input.bag output.bag "topic == '/camera/rgb/image_raw'"

# Convert images to files
rosrun image_view extract_images _sec_per_frame:=0.1 image:=/camera/rgb/image_raw
```

## Best Practices

### Recording Guidelines
1. **Consistent motion**: Move smoothly to avoid motion blur
2. **Good lighting**: Ensure adequate illumination for cameras
3. **Complete loops**: Return to starting position for loop closure
4. **Varied viewpoints**: Capture environment from multiple angles
5. **Calibration data**: Include camera/sensor calibration information

### Quality Assurance
```bash
# Verify bag integrity
rosbag check session_file.bag

# Check for dropped frames
rostopic hz /camera/rgb/image_raw

# Monitor disk usage during recording
watch df -h
```

### Documentation
Always document your recordings:
- Environment description
- Sensor configuration
- Motion patterns
- Known issues or anomalies
- Calibration parameters used

## File Management

### Compression and Storage
```bash
# Compress existing bags
rosbag compress original.bag

# Decompress if needed
rosbag decompress compressed.bag

# Calculate storage requirements
du -sh *.bag
```

### Sharing Datasets
```bash
# Create shareable dataset
tar -czf rtabmap_dataset_office.tar.gz session_*.bag metadata.txt

# Upload to cloud storage or share with community
# Consider privacy and data protection policies
```

## Troubleshooting

### Common Issues

1. **Disk space exhaustion**:
   ```bash
   # Monitor disk usage
   df -h
   
   # Enable compression
   rosbag record --lz4 [topics]
   ```

2. **Dropped messages**:
   ```bash
   # Check message rates
   rostopic hz /camera/rgb/image_raw
   
   # Reduce recording frequency if needed
   ```

3. **Large file sizes**:
   - Use compressed image topics
   - Reduce image resolution
   - Limit recording duration
   - Split into multiple files

4. **Synchronization issues**:
   - Ensure all sensors publish timestamps
   - Use header stamps consistently
   - Check TF tree completeness

### Performance Optimization
- Use fast storage (SSD) for recording
- Record to separate disk from system
- Monitor system resources during recording
- Adjust buffer sizes for high-frequency topics

## Integration with RTAB-Map Workflow

### Development Cycle
1. **Record**: Capture sensor data in target environment
2. **Develop**: Test SLAM parameters with recorded data
3. **Iterate**: Refine parameters and re-test
4. **Deploy**: Use optimized parameters on live robot

### Dataset Sharing
- Contribute to RTAB-Map community datasets
- Share challenging scenarios for development
- Provide ground truth data when available

## Related Documentation
- [rosbag Documentation](http://wiki.ros.org/rosbag)
- [RTAB-Map Data Formats](https://github.com/introlab/rtabmap/wiki)
- [Sensor Calibration](http://wiki.ros.org/camera_calibration)