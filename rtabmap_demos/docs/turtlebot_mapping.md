# TurtleBot Mapping Demo

## Overview
This demo demonstrates complete SLAM (Simultaneous Localization and Mapping) functionality using a TurtleBot robot with RTAB-Map. It's designed as a one-to-one replacement for the gmapping demo in the TurtleBot navigation tutorials.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- TurtleBot packages:
  - `turtlebot_bringup`
  - `turtlebot_navigation`
  - `turtlebot_gazebo` (for simulation)
- Navigation stack (move_base)

### Hardware Requirements
- **Physical Robot**: TurtleBot with 3D sensor (Kinect/Asus Xtion/RealSense)
- **Simulation**: Gazebo-compatible computer for TurtleBot simulation

### Installation
```bash
# Install TurtleBot packages (ROS Noetic example)
sudo apt-get install ros-noetic-turtlebot-bringup ros-noetic-turtlebot-navigation ros-noetic-turtlebot-gazebo

# Install RTAB-Map
sudo apt-get install ros-noetic-rtabmap-ros
```

## Setup Instructions

### Option 1: Physical TurtleBot
1. **Prepare the TurtleBot**:
   ```bash
   # Connect to TurtleBot and start minimal bringup
   roslaunch turtlebot_bringup minimal.launch
   ```

2. **Launch the mapping demo**:
   ```bash
   # In a new terminal
   roslaunch rtabmap_demos demo_turtlebot_mapping.launch
   ```

3. **Start visualization**:
   ```bash
   # In another terminal
   roslaunch rtabmap_demos demo_turtlebot_rviz.launch
   ```

### Option 2: Gazebo Simulation
1. **Start Gazebo simulation**:
   ```bash
   roslaunch turtlebot_gazebo turtlebot_world.launch
   ```

2. **Launch mapping with simulation parameters**:
   ```bash
   roslaunch rtabmap_demos demo_turtlebot_mapping.launch simulation:=true
   ```

3. **Start visualization**:
   ```bash
   roslaunch rtabmap_demos demo_turtlebot_rviz.launch
   ```

## Usage Instructions

### Basic Operation
1. Once all nodes are running, the robot will start building a map as it moves
2. Use keyboard teleop or navigation goals to move the robot:
   ```bash
   # Install teleop if needed
   sudo apt-get install ros-noetic-turtlebot-teleop
   
   # Launch keyboard teleop
   roslaunch turtlebot_teleop keyboard_teleop.launch
   ```

3. The map will be displayed in RViz and saved to `rtabmap.db`

### Advanced Options

#### Localization Mode
To use the robot for localization in a previously mapped environment:
```bash
roslaunch rtabmap_demos demo_turtlebot_mapping.launch localization:=true
```

#### RGBD Odometry
To test with RGBD odometry instead of wheel odometry:
```bash
roslaunch rtabmap_demos demo_turtlebot_mapping.launch rgbd_odometry:=true
```

#### Custom Database Location
```bash
roslaunch rtabmap_demos demo_turtlebot_mapping.launch database_path:=/path/to/your/map.db
```

## Configuration Parameters

### Key Launch Arguments
- `database_path` (default: "rtabmap.db"): Path to RTAB-Map database
- `localization` (default: false): Enable localization-only mode
- `simulation` (default: false): Optimize for Gazebo simulation
- `rgbd_odometry` (default: false): Use RGBD odometry instead of wheel odometry
- `rtabmap_viz` (default: false): Launch RTAB-Map's native visualization

### Important RTAB-Map Parameters
- `RGBD/ProximityBySpace`: Enable local loop closure detection
- `RGBD/OptimizeFromGraphEnd`: Generate map correction between /map and /odom
- `Reg/Strategy`: Loop closure method (0=Visual, 1=ICP, 2=Visual+ICP)
- `RGBD/AngularUpdate`/`RGBD/LinearUpdate`: Movement thresholds for map updates

## Expected Output

### Topics Published
- `/map`: 2D occupancy grid map
- `/rtabmap/grid_map`: RTAB-Map grid map
- `/rtabmap/cloud_map`: 3D point cloud map
- `/rtabmap/info`: RTAB-Map statistics

### Visualization
- **RViz**: Shows 2D map, robot pose, laser scan, and camera feed
- **RTAB-Map Viz**: Shows 3D map, loop closures, and detailed statistics

## Troubleshooting

### Common Issues
1. **TF Warnings**: Increase robot_state_publisher frequency from 5 to 10 Hz in turtlebot_bringup
2. **High Covariance**: The demo automatically fixes odom covariance for simulation
3. **No Map Appearing**: Ensure the robot is moving and the camera/laser are working

### Performance Tips
- Ensure adequate lighting for visual features
- Move slowly for better map quality
- Close loops by returning to previously visited areas

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_turtlebot_mapping.launch`
- **Visualization**: `rtabmap_demos/launch/demo_turtlebot_rviz.launch`
- **Config**: `rtabmap_demos/launch/config/rgbd_gui.ini`

## Related Tutorials
- [TurtleBot Navigation Tutorial](http://wiki.ros.org/turtlebot_navigation/Tutorials/indigo/Build%20a%20map%20with%20SLAM)
- [Autonomous Navigation Tutorial](http://wiki.ros.org/turtlebot_navigation/Tutorials/Autonomously%20navigate%20in%20a%20known%20map)
- [RTAB-Map ROS Wiki](http://wiki.ros.org/rtabmap_ros)