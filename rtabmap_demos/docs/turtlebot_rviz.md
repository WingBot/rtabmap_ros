# TurtleBot RViz Demo

## Overview
This demo provides a pre-configured RViz visualization setup specifically designed for TurtleBot mapping sessions with RTAB-Map. It displays all relevant information for monitoring SLAM performance and robot status during mapping operations.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RViz for visualization
- RTAB-Map packages
- TurtleBot packages (for proper frame definitions)

### Usage Context
This demo is typically used alongside:
- `demo_turtlebot_mapping.launch` for SLAM
- Physical or simulated TurtleBot

## Setup Instructions

### Basic Usage
```bash
# Launch TurtleBot mapping in one terminal
roslaunch rtabmap_demos demo_turtlebot_mapping.launch

# Launch RViz visualization in another terminal
roslaunch rtabmap_demos demo_turtlebot_rviz.launch
```

### Integrated Usage
```bash
# The TurtleBot mapping demo can automatically launch RViz
roslaunch rtabmap_demos demo_turtlebot_mapping.launch rviz:=true
```

## Visualization Features

### Display Elements
The RViz configuration includes:

#### Robot Visualization
- **Robot model**: TurtleBot URDF visualization
- **TF tree**: Complete transform relationships
- **Robot pose**: Current position and orientation

#### Sensor Data
- **Laser scan**: Real-time LiDAR data visualization
- **Camera feed**: RGB camera image overlay
- **Depth data**: Depth sensor visualization (if available)

#### SLAM Information
- **Occupancy grid**: 2D map being built
- **Robot trajectory**: Path taken during mapping
- **Point cloud**: 3D map data (if enabled)
- **Loop closures**: Visual indicators of detected loops

#### Navigation (if applicable)
- **Global costmap**: Static map layer
- **Local costmap**: Dynamic obstacle detection
- **Path planning**: Planned and executed paths
- **Goal markers**: Navigation targets

## Configuration Details

### Key RViz Displays
1. **Grid**: Reference coordinate grid
2. **Robot Model**: Visual robot representation
3. **TF**: Transform tree visualization
4. **LaserScan**: LiDAR data points
5. **Map**: Occupancy grid from SLAM
6. **Path**: Robot trajectory
7. **Image**: Camera feed (optional)

### Frame Configuration
- **Fixed frame**: Usually `map` or `odom`
- **Target frame**: Typically `base_link` or `base_footprint`
- **Update rate**: Optimized for real-time visualization

### Topic Mappings
The configuration subscribes to standard TurtleBot topics:
```
/map                    # Occupancy grid
/tf                     # Transform tree
/scan                   # Laser scan data
/robot_description      # URDF model
/move_base/TrajectoryPlannerROS/global_plan  # Navigation path
```

## Usage Instructions

### Basic Operation
1. **Launch the demo**: Start both mapping and RViz
2. **Move the robot**: Use teleop or navigation goals
3. **Monitor progress**: Watch map building in real-time
4. **Adjust views**: Use RViz controls to change perspectives

### Interactive Features
- **Goal setting**: Use "2D Nav Goal" tool for navigation
- **Pose estimation**: Use "2D Pose Estimate" for localization
- **View controls**: Pan, zoom, and rotate the visualization
- **Display toggles**: Show/hide different elements

### Customization
```bash
# Save custom RViz configuration
# File -> Save Config As... in RViz

# Load custom configuration
rosrun rviz rviz -d /path/to/your/config.rviz
```

## Expected Output

### Visual Elements
- Real-time 2D map building
- Robot position and orientation updates
- Laser scan rays showing sensor readings
- Trajectory trail showing robot path
- Loop closure indicators (when detected)

### Performance Indicators
- **Frame rate**: Smooth visualization updates
- **Map quality**: Consistent and accurate mapping
- **Localization**: Stable robot pose estimation

## Troubleshooting

### Common Issues

1. **Missing robot model**:
   ```bash
   # Ensure robot_description is published
   rostopic echo /robot_description
   
   # Check if TurtleBot packages are installed
   rospack find turtlebot_description
   ```

2. **TF errors**:
   ```bash
   # Check transform tree
   rosrun tf view_frames
   
   # Monitor TF warnings
   rosrun tf tf_monitor
   ```

3. **No map display**:
   ```bash
   # Verify map topic
   rostopic echo /map
   
   # Check RTAB-Map is running
   rosnode list | grep rtabmap
   ```

4. **Poor visualization performance**:
   - Reduce point cloud density
   - Disable unnecessary displays
   - Adjust update rates
   - Check system resources

### Optimization Tips
- Disable CPU-intensive displays if not needed
- Adjust point cloud decimation
- Use appropriate frame rates for your system
- Consider hardware acceleration

## Customization Options

### Adding Custom Displays
```xml
<!-- Add custom displays to the RViz config -->
<display>
  <class_id>rviz/MarkerArray</class_id>
  <name>Custom Markers</name>
  <topic>/custom_markers</topic>
</display>
```

### Modifying Views
- Save different camera positions
- Create custom view configurations
- Set up multiple view panels

### Theme and Appearance
- Adjust colors and transparency
- Modify grid and background settings
- Customize robot model appearance

## Integration with Other Demos

### Compatible Launches
This RViz configuration works well with:
- `demo_turtlebot_mapping.launch`
- `demo_turtlebot3_navigation.launch`
- Custom TurtleBot SLAM configurations

### Switching Between Visualizations
```bash
# Use RViz instead of rtabmap_viz
roslaunch rtabmap_demos demo_turtlebot_mapping.launch rtabmap_viz:=false rviz:=true

# Use both visualizations
roslaunch rtabmap_demos demo_turtlebot_mapping.launch rtabmap_viz:=true rviz:=true
```

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_turtlebot_rviz.launch`
- **Config file**: `rtabmap_demos/launch/config/turtlebot_rviz.rviz` (likely location)

## Advanced Features

### Multi-robot Visualization
Configure for multiple TurtleBot visualization by:
- Using different namespaces
- Adjusting topic remapping
- Color-coding different robots

### Recording and Playback
```bash
# Record RViz session
rosbag record /tf /map /scan /robot_description

# Playback with visualization
rosbag play session.bag &
roslaunch rtabmap_demos demo_turtlebot_rviz.launch
```

## Related Documentation
- [RViz User Guide](http://wiki.ros.org/rviz/UserGuide)
- [TurtleBot Documentation](http://wiki.ros.org/Robots/TurtleBot)
- [RTAB-Map Visualization](https://github.com/introlab/rtabmap/wiki/Visualization)