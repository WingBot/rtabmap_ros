# Robot Mapping Demo

## Overview
This demo demonstrates RTAB-Map's capabilities using pre-recorded robot sensor data from a ROS bag file. It's designed to work with the `demo_mapping.bag` dataset and showcases SLAM with RGB-D camera and laser scan data from a real robot platform.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- rosbag for data playback
- RViz for visualization (optional)

### Dataset Requirements
- **Required bag file**: `demo_mapping.bag`
- **Topics in bag**:
  - `/data_throttled_image` (RGB image, compressed)
  - `/data_throttled_image_depth` (Depth image, compressed)
  - `/data_throttled_camera_info` (Camera calibration)
  - `/jn0/base_scan` (Laser scan data)
  - `/az3/base_controller/odom` (Odometry)
  - `/tf` (Transform tree)

### Installation
```bash
# Install RTAB-Map packages
sudo apt-get install ros-noetic-rtabmap-ros

# Download the demo bag file (if not already available)
# Note: The specific download location should be provided by the RTAB-Map team
```

## Dataset Information

### Bag File Contents
The `demo_mapping.bag` contains sensor data from a robot equipped with:
- RGB-D camera (providing color and depth images)
- 2D laser scanner
- Wheel encoders for odometry
- Complete TF tree for sensor transforms

### Data Characteristics
- **Compressed format**: RGB images use JPEG compression, depth uses specialized compression
- **Coordinate frames**:
  - `base_footprint`: Robot base frame
  - `odom`: Odometry frame
  - Camera and laser frames as defined in TF

## Setup Instructions

### 1. Prepare the Environment
```bash
# Set ROS to use simulation time
export ROS_PARAM_USE_SIM_TIME=true

# Or the parameter will be set automatically by the launch file
```

### 2. Launch the Mapping Demo
```bash
# Start RTAB-Map with robot mapping configuration
roslaunch rtabmap_demos demo_robot_mapping.launch
```

### 3. Play the Bag File
```bash
# In a new terminal, play the bag with clock simulation
rosbag play --clock demo_mapping.bag
```

### Optional: Launch Visualization
```bash
# For RViz visualization
roslaunch rtabmap_demos demo_robot_mapping.launch rviz:=true rtabmap_viz:=false

# For RTAB-Map native visualization (default)
roslaunch rtabmap_demos demo_robot_mapping.launch rtabmap_viz:=true rviz:=false
```

## Usage Instructions

### Basic Operation
1. **Start the demo**: Launch the mapping demo first
2. **Begin playback**: Start the bag file with `--clock` option
3. **Monitor progress**: Watch the visualization as the map builds
4. **Complete processing**: Let the bag file play to completion

### Playback Control
```bash
# Play at different speeds
rosbag play --clock -r 0.5 demo_mapping.bag  # Half speed
rosbag play --clock -r 2.0 demo_mapping.bag  # Double speed

# Start from specific time
rosbag play --clock -s 30 demo_mapping.bag   # Skip first 30 seconds

# Loop playback
rosbag play --clock -l demo_mapping.bag      # Loop continuously
```

### Localization Mode
To test localization after mapping:
```bash
# First, complete a mapping session and save the database
# Then restart in localization mode
roslaunch rtabmap_demos demo_robot_mapping.launch localization:=true

# Play the bag again - the robot should localize in the existing map
rosbag play --clock demo_mapping.bag
```

## Configuration Parameters

### Key Launch Arguments
- `rviz` (default: false): Enable RViz visualization
- `rtabmap_viz` (default: true): Enable RTAB-Map visualization
- `localization` (default: false): Enable localization-only mode

### RTAB-Map Parameters (Key Settings)
- `Reg/Strategy`: "1" (ICP registration for laser-based loop closure)
- `RGBD/NeighborLinkRefining`: "true" (odometry correction with laser scans)
- `RGBD/ProximityBySpace`: "true" (spatial loop closure detection)
- `Grid/FromDepth`: "false" (create occupancy grid from laser, not depth)
- `Reg/Force3DoF`: "true" (2D SLAM mode)

### Topic Remapping
The launch file automatically handles topic remapping:
- Camera topics: `/data_throttled_*`
- Laser topic: `/jn0/base_scan`
- Odometry: `/az3/base_controller/odom`

## Expected Output

### Console Output
```
[ INFO]: rtabmap: Update rate=X.XX Hz, Limit=X.XX s, RTAB-Map=X.XX s
[ INFO]: rtabmap: Features extracted = XXX
[ INFO]: rtabmap: Loop closure detected! (ID=X->Y)
[ INFO]: rtabmap: Updating map...
```

### Visualization Features
- **3D map**: Point cloud reconstruction from RGB-D data
- **2D occupancy grid**: Generated from laser scan data
- **Loop closures**: Visual indicators of detected loops
- **Robot trajectory**: Path taken through the environment

### Database Output
- **File**: `rtabmap.db` (default location)
- **Content**: Complete map data, images, and loop closure information
- **Usage**: Can be loaded for localization or map analysis

## Understanding the Results

### Map Quality Indicators
- **Loop closures**: More loop closures generally indicate better map consistency
- **Trajectory smoothness**: Should show correction when loops are closed
- **Occupancy grid**: Should be coherent and match the environment structure

### Performance Metrics
- **Processing rate**: Should keep up with bag playback rate
- **Memory usage**: Monitor Working Memory (WM) and Short-Term Memory (STM) sizes
- **Detection statistics**: Feature counts and matching success rates

## Troubleshooting

### Common Issues
1. **Clock synchronization problems**:
   ```bash
   # Ensure --clock is used with rosbag play
   # Check that use_sim_time is true
   rosparam get /use_sim_time
   ```

2. **Missing topics**:
   ```bash
   # Verify bag file contents
   rosbag info demo_mapping.bag
   
   # Check active topics during playback
   rostopic list
   ```

3. **Slow processing**:
   - Reduce playback rate: `rosbag play --clock -r 0.5 demo_mapping.bag`
   - Check system resources (CPU, memory)
   - Verify RTAB-Map parameters are appropriate

### Performance Tips
- Use SSD storage for faster bag file access
- Ensure adequate RAM for map storage
- Monitor system resources during processing
- Consider reducing image resolution for faster processing

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_robot_mapping.launch`
- **RViz config**: `rtabmap_demos/launch/config/demo_robot_mapping.rviz`
- **RTAB-Map config**: `rtabmap_demos/launch/config/rgbd_gui.ini`

## Advanced Usage

### Custom Bag Files
To use your own bag file:
1. Ensure it contains the required topics (or modify topic remapping)
2. Update frame IDs if different from the demo
3. Adjust RTAB-Map parameters for your sensor configuration

### Parameter Tuning
Key parameters to adjust for different datasets:
- `Icp/CorrespondenceRatio`: Laser scan overlap threshold
- `RGBD/OptimizeMaxError`: Maximum error for loop closure acceptance
- `Mem/STMSize`: Short-term memory size for recent locations

## Related Documentation
- [RTAB-Map ROS Integration](http://wiki.ros.org/rtabmap_ros)
- [Working with Bag Files](http://wiki.ros.org/rosbag/Tutorials)
- [RTAB-Map Parameters Guide](https://github.com/introlab/rtabmap/wiki/Parameters)