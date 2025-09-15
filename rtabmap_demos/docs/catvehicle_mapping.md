# CAT Vehicle Mapping Demo

## Overview
This demo demonstrates RTAB-Map integration with the CAT Vehicle (Cognitive and Autonomous Test Vehicle) simulation platform. It showcases SLAM capabilities for autonomous vehicle applications, including highway and urban driving scenarios.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- CAT Vehicle simulation packages
- Gazebo for 3D simulation
- Vehicle-specific sensor packages

### Simulation Requirements
- **CAT Vehicle packages**: Vehicle simulation and control
- **Gazebo worlds**: Road and urban environments
- **Sensor simulation**: Camera, LiDAR, GPS, IMU
- **Graphics capability**: For realistic visual simulation

### Installation
```bash
# Install CAT Vehicle simulation
sudo apt-get install ros-noetic-catvehicle

# Install RTAB-Map packages
sudo apt-get install ros-noetic-rtabmap-ros

# Install additional dependencies
sudo apt-get install ros-noetic-gazebo-ros-pkgs ros-noetic-velodyne-simulator
```

## Setup Instructions

### 1. Launch CAT Vehicle Simulation
```bash
# Start CAT Vehicle in Gazebo
roslaunch catvehicle catvehicle_empty.launch

# Or launch with specific world
roslaunch catvehicle catvehicle_skidpad.launch
```

### 2. Launch RTAB-Map Demo
```bash
# Start the vehicle mapping demo
roslaunch rtabmap_demos demo_catvehicle_mapping.launch
```

### 3. Vehicle Control
```bash
# Control vehicle movement
# Option 1: Manual control
rosrun teleop_twist_keyboard teleop_twist_keyboard.py

# Option 2: CAT Vehicle controller
roslaunch catvehicle catvehicle_control.launch

# Option 3: Autonomous waypoint following
rostopic pub /catvehicle/cmd_vel geometry_msgs/Twist "linear: {x: 5.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.5}"
```

## Configuration Parameters

### Key Launch Arguments
- `simulation`: Enable simulation mode optimizations
- `use_lidar`: Include LiDAR data in SLAM
- `use_camera`: Include camera data for visual features
- `localization`: Enable localization-only mode for navigation

### Vehicle-specific Parameters
#### High-speed Compensation
- Adjust for vehicle speeds (5-25 m/s typical)
- Handle rapid viewpoint changes
- Compensate for motion blur

#### Road Environment Adaptation
- Optimize for linear road structures
- Handle repetitive highway features
- Manage dynamic objects (other vehicles)

### RTAB-Map Parameters for Vehicles
```bash
# High-speed mapping parameters
RGBD/AngularUpdate: 0.2      # Larger updates for vehicle speeds
RGBD/LinearUpdate: 0.5       # Account for fast linear motion

# Road-specific features
Grid/CellSize: 0.1           # Fine resolution for road mapping
Grid/RangeMax: 50.0          # Extended range for vehicle sensing

# Robust tracking
Vis/MinInliers: 30           # Higher threshold for high-speed
RGBD/OptimizeFromGraphEnd: true  # Better trajectory handling
```

## Expected Output

### Vehicle Mapping Performance
```
Mapping rate: X.X Hz (adapted to vehicle speed)
Vehicle speed: XX.X m/s
Road features: XXX detected
Loop closures: X (at intersections/landmarks)
```

### Road Infrastructure Mapping
- **Lane detection**: Road boundaries and markings
- **Infrastructure mapping**: Signs, signals, barriers
- **Intersection handling**: Complex road junctions
- **Landmark identification**: Distinctive road features

### Autonomous Driving Integration
- **Localization**: Precise vehicle positioning
- **Path planning**: Route optimization using map
- **Obstacle detection**: Real-time environment sensing
- **Navigation**: GPS-free autonomous driving

## Vehicle-specific Challenges

### High-speed Motion
```bash
# Optimize for vehicle speeds
rosparam set /rtabmap/rtabmap/RGBD/LinearUpdate 1.0
rosparam set /rtabmap/rtabmap/RGBD/AngularUpdate 0.3

# Increase tracking robustness
rosparam set /rtabmap/rtabmap/Vis/FeatureType 6  # GFTT/BRIEF for speed
```

### Road Environment Features
- Handle repetitive road textures
- Detect unique landmarks for loop closure
- Manage dynamic traffic elements
- Cope with lighting variations

### GPS Integration
```bash
# Combine SLAM with GPS when available
# Use GPS for global reference
# Fall back to SLAM in GPS-denied areas
```

## Applications

### Autonomous Vehicle Development
- **HD mapping**: High-definition road maps
- **Localization**: GPS-free positioning
- **SLAM validation**: Testing autonomous algorithms
- **Sensor fusion**: Multi-modal perception

### Traffic Infrastructure
- **Road surveying**: Infrastructure documentation
- **Traffic analysis**: Vehicle flow patterns
- **Safety assessment**: Road condition monitoring
- **Planning support**: Urban development data

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_catvehicle_mapping.launch`
- **Vehicle configurations**: CAT Vehicle parameter files
- **Simulation worlds**: Gazebo road environments

## Related Documentation
- [CAT Vehicle Documentation](http://wiki.ros.org/catvehicle)
- [Autonomous Vehicle SLAM](https://github.com/introlab/rtabmap/wiki)
- [High-speed SLAM Techniques](https://github.com/introlab/rtabmap/wiki)