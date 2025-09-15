# Hector Mapping Demo

## Overview
This demo integrates RTAB-Map with Hector SLAM, combining Hector's scan-matching capabilities with RTAB-Map's loop closure detection and map management. It's particularly useful for environments where wheel odometry is unreliable or unavailable.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- hector_slam package for scan-matching odometry
- Optional: libpointmatcher for advanced ICP
- rosbag for dataset playback

### Dataset Requirements
- **demo_mapping_no_odom.bag**: Modified bag file without wheel odometry
- Contains laser scan data, camera feeds, and TF (without odom frame)

### Creating the Dataset
If you have the original `demo_mapping.bag`, create the no-odometry version:
```bash
# Remove odometry TF from bag file
rosbag filter demo_mapping.bag demo_mapping_no_odom.bag \
  'topic != "/tf" or topic == "/tf" and m.transforms[0].header.frame_id != "/odom"'
```

### Installation
```bash
# Install required packages
sudo apt-get install ros-noetic-rtabmap-ros ros-noetic-hector-slam

# Optional: libpointmatcher for advanced ICP
sudo apt-get install ros-noetic-libpointmatcher-ros
```

## Setup Instructions

### Option 1: Hector SLAM Odometry (Default)
```bash
# Launch with Hector for scan-matching odometry
roslaunch rtabmap_demos demo_hector_mapping.launch hector:=true
```

### Option 2: ICP Odometry
```bash
# Use ICP odometry instead of Hector
roslaunch rtabmap_demos demo_hector_mapping.launch hector:=false
```

### Option 3: ICP with Wheel Odometry Guess
```bash
# Use wheel odometry as initial guess for ICP (requires original bag with odom)
roslaunch rtabmap_demos demo_hector_mapping.launch hector:=false odom_guess:=true
```

### Dataset Playback
```bash
# Play the bag file with simulation time
rosbag play --clock demo_mapping_no_odom.bag
```

## Configuration Options

### Key Launch Arguments
- `rviz` (default: true): Enable RViz visualization
- `rtabmap_viz` (default: false): Enable RTAB-Map visualization
- `hector` (default: true): Use Hector SLAM for odometry
- `odom_guess` (default: false): Use wheel odometry as ICP guess
- `camera` (default: true): Include camera data
- `max_range` (default: 0): Limit LiDAR range (when hector:=false)
- `p2n` (default: true): Point-to-plane ICP (when hector:=false)
- `pm` (default: true): Use libpointmatcher (when hector:=false)

### Sensor Configuration
The demo expects these topics:
- `/jn0/base_scan`: Laser scan data
- `/data_throttled_image`: RGB image (compressed)
- `/data_throttled_image_depth`: Depth image (compressed)
- `/data_throttled_camera_info`: Camera calibration

## Usage Instructions

### Basic Operation with Hector
1. **Launch the demo**:
   ```bash
   roslaunch rtabmap_demos demo_hector_mapping.launch
   ```

2. **Start bag playback**:
   ```bash
   rosbag play --clock demo_mapping_no_odom.bag
   ```

3. **Monitor the process**:
   - Watch RViz for map building
   - Observe loop closure detections
   - Check Hector scan-matching performance

### Advanced ICP Operation
1. **Launch with ICP odometry**:
   ```bash
   roslaunch rtabmap_demos demo_hector_mapping.launch hector:=false pm:=true
   ```

2. **Tune ICP parameters**:
   ```bash
   # Adjust maximum range for better performance
   roslaunch rtabmap_demos demo_hector_mapping.launch hector:=false max_range:=30.0
   
   # Use point-to-plane ICP
   roslaunch rtabmap_demos demo_hector_mapping.launch hector:=false p2n:=true
   ```

## Understanding the Integration

### Hector SLAM Mode
When `hector:=true`:
- **Odometry source**: Hector's scan-matching
- **Frame setup**: `/scanmatcher_frame` → `/base_footprint`
- **Advantages**: No wheel odometry required
- **Best for**: Environments with good laser scan features

### ICP Odometry Mode
When `hector:=false`:
- **Odometry source**: RTAB-Map's ICP odometry
- **Frame setup**: Direct laser-based pose estimation
- **Advantages**: More robust in challenging environments
- **Best for**: Environments where Hector might fail

### RTAB-Map Integration
Both modes provide:
- **Loop closure detection**: Visual and/or geometric
- **Global map optimization**: Consistent mapping
- **Long-term memory**: Persistent map storage

## Configuration Parameters

### Hector SLAM Parameters
Key Hector settings (when hector:=true):
- Scan matching resolution and accuracy
- Map update rates and thresholds
- Transform publication settings

### ICP Parameters (when hector:=false)
- `Icp/PM`: Use libpointmatcher vs. PCL
- `Icp/PointToPlane`: Point-to-plane vs. point-to-point
- `Icp/MaxCorrespondenceDistance`: Correspondence threshold
- `Icp/VoxelSize`: Point cloud downsampling

### RTAB-Map Parameters
- `Reg/Strategy`: 1 (ICP) for laser-based loop closure
- `Grid/FromDepth`: false (use laser for occupancy grid)
- `RGBD/ProximityBySpace`: true (spatial loop closure)

## Expected Output

### Successful Processing
```
[ INFO]: hector_mapping: Hector SLAM scan matcher initialized
[ INFO]: rtabmap: Odometry received from Hector
[ INFO]: rtabmap: Loop closure detected!
[ INFO]: rtabmap: Map optimized successfully
```

### Visualization Features
- **Real-time mapping**: Progressive map building
- **Scan matching**: Hector's alignment visualization
- **Loop closures**: Visual indicators of loop detection
- **Trajectory correction**: Map optimization effects

### Performance Indicators
- **Scan matching rate**: Should match laser frequency
- **Loop closure frequency**: Depends on environment revisiting
- **Map consistency**: Smooth trajectory after optimization

## Troubleshooting

### Common Issues

1. **Hector scan matching failing**:
   ```bash
   # Check laser scan quality
   rostopic echo /jn0/base_scan
   
   # Verify scan frequency
   rostopic hz /jn0/base_scan
   
   # Ensure adequate features in environment
   ```

2. **No odometry from Hector**:
   ```bash
   # Check TF tree
   rosrun tf tf_monitor
   
   # Verify frame relationships
   rosrun tf view_frames
   ```

3. **ICP odometry performance**:
   ```bash
   # Check if libpointmatcher is available
   rospack find libpointmatcher_ros
   
   # Monitor ICP statistics
   rostopic echo /rtabmap/odom_info
   ```

4. **Poor loop closure detection**:
   - Ensure camera data is available and synchronized
   - Check for adequate visual features
   - Verify laser scan consistency

### Performance Optimization

#### For Hector Mode
- Ensure high-quality laser scans
- Provide environments with good geometric features
- Avoid areas with repetitive patterns

#### For ICP Mode
- Tune correspondence distance thresholds
- Adjust voxel grid size for performance
- Use appropriate point-to-plane settings

## Comparison: Hector vs ICP Odometry

### Hector SLAM Advantages
- **No calibration required**: Works out-of-the-box
- **Real-time performance**: Optimized for speed
- **Robust initialization**: Good starting performance

### ICP Odometry Advantages
- **Higher accuracy**: More precise pose estimation
- **Better robustness**: Handles challenging environments
- **Configurability**: Extensive parameter tuning options

### When to Use Each
- **Hector**: Good laser features, need quick setup
- **ICP**: Demanding accuracy requirements, challenging environments

## Integration Patterns

### Hybrid Approaches
```bash
# Use Hector initially, switch to ICP for refinement
# Start with hector:=true for initial mapping
# Use hector:=false for precision mapping phases
```

### Multi-session Usage
```bash
# Continue mapping across sessions
roslaunch rtabmap_demos demo_hector_mapping.launch localization:=true
```

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_hector_mapping.launch`
- **Dataset**: `demo_mapping_no_odom.bag` (user-provided)
- **Dependencies**: hector_slam, optional libpointmatcher

## Real-world Applications

### Suitable Scenarios
- **Indoor robots**: Where wheel odometry is unreliable
- **Handheld mapping**: Manual SLAM data collection
- **Legacy systems**: Upgrading existing Hector setups
- **Research**: Comparing odometry approaches

### Environment Requirements
- **Structured environments**: Walls, corridors, furniture
- **Good laser features**: Avoid featureless areas
- **Stable lighting**: For camera-based loop closure

## Related Documentation
- [Hector SLAM Documentation](http://wiki.ros.org/hector_slam)
- [libpointmatcher](https://github.com/ethz-asl/libpointmatcher)
- [RTAB-Map ICP Parameters](https://github.com/introlab/rtabmap/wiki/ICP-parameters)
- [Scan Matching Techniques](https://github.com/introlab/rtabmap/wiki/Scan-matching)