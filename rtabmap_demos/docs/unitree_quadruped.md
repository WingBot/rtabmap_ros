# Unitree Quadruped Robot Demo

## Overview
This demo showcases RTAB-Map integration with Unitree quadruped robots (such as A1, Go1, or similar models). It demonstrates SLAM capabilities for legged robots, which present unique challenges due to dynamic locomotion, varying viewpoints, and complex terrain navigation.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- Unitree robot SDK and ROS packages
- Sensor drivers (camera, LiDAR, IMU)

### Hardware Requirements
- **Unitree quadruped robot** (A1, Go1, or compatible model)
- **Onboard sensors**: RGB-D camera, LiDAR, IMU
- **Computing platform**: Onboard computer (Xavier NX, etc.)
- **Network connectivity**: Wi-Fi or Ethernet for remote monitoring

### Installation
```bash
# Install RTAB-Map packages
sudo apt-get install ros-noetic-rtabmap-ros

# Install Unitree SDK (follow Unitree's official documentation)
# This typically involves:
# 1. Clone Unitree SDK from GitHub
# 2. Build and install according to robot model
# 3. Configure robot-specific parameters
```

## Robot Setup

### Sensor Configuration
Typical Unitree robot sensor setup:
- **RGB-D Camera**: Front-mounted for visual SLAM
- **LiDAR**: 360-degree scanning for obstacle detection
- **IMU**: Onboard inertial measurement for orientation
- **Odometry**: Leg kinematics-based pose estimation

### Network Configuration
```bash
# Configure robot network (example)
export ROS_MASTER_URI=http://robot_ip:11311
export ROS_IP=your_computer_ip

# Verify connectivity
rostopic list
```

## Setup Instructions

### 1. Robot Initialization
```bash
# Start robot basic systems (on robot or via SSH)
roslaunch unitree_legged_real robot.launch

# Or for simulation
roslaunch unitree_gazebo normal.launch rname:=a1 wname:=earth
```

### 2. Launch RTAB-Map Demo
```bash
# Start the quadruped SLAM demo
roslaunch rtabmap_demos demo_unitree_quadruped_robot.launch
```

### 3. Robot Control
```bash
# Control robot movement (various methods)
# Option 1: Manual control
rosrun teleop_twist_keyboard teleop_twist_keyboard.py

# Option 2: Unitree-specific controller
roslaunch unitree_controller controller.launch

# Option 3: High-level navigation commands
rostopic pub /cmd_vel geometry_msgs/Twist "linear: {x: 0.3, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}"
```

## Configuration Parameters

### Key Launch Arguments
- `robot_model`: Specify Unitree robot model (a1, go1, etc.)
- `simulation`: Enable simulation mode vs. real robot
- `use_lidar`: Include LiDAR data in SLAM
- `use_camera`: Include RGB-D camera data
- `localization`: Enable localization-only mode

### Quadruped-specific Parameters
#### Motion Compensation
- Account for robot body movement during locomotion
- Compensate for leg-induced vibrations
- Handle dynamic height changes

#### Sensor Fusion
- Combine visual, LiDAR, and inertial data
- Weight different sensors based on motion state
- Adapt to changing robot posture

### RTAB-Map Parameters for Legged Robots
```bash
# Motion compensation parameters
RGBD/AngularUpdate: 0.05    # Smaller updates for dynamic motion
RGBD/LinearUpdate: 0.05     # Account for gait-induced movement

# IMU integration
Imu/Use: true               # Enable IMU data
Reg/Force3DoF: false        # Allow 6DoF for uneven terrain

# Robust feature tracking
Vis/MinInliers: 20          # Higher threshold for dynamic environments
RGBD/OptimizeFromGraphEnd: true  # Better handling of trajectory corrections
```

## Usage Instructions

### Basic SLAM Operation
1. **Initialize robot**: Ensure all systems are operational
2. **Start SLAM**: Launch the RTAB-Map demo
3. **Begin exploration**: Move robot through environment
4. **Monitor performance**: Watch for loop closures and map quality
5. **Save map**: Store map for future navigation

### Locomotion Considerations
#### Gait Planning
- **Trot gait**: Stable for mapping, moderate speed
- **Walk gait**: Slow but very stable, good for detailed mapping
- **Bound gait**: Fast but may cause tracking issues

#### Terrain Adaptation
- **Flat surfaces**: Standard SLAM parameters work well
- **Stairs/slopes**: May need motion compensation tuning
- **Rough terrain**: Increase robustness parameters

### Multi-modal Sensing
#### Visual SLAM
- Primary for texture-rich environments
- Affected by lighting conditions
- Benefits from stable camera mounting

#### LiDAR SLAM
- Robust in various lighting
- Good for geometric features
- Less affected by robot motion

#### IMU Integration
- Provides orientation reference
- Helps with motion compensation
- Critical for uneven terrain

## Expected Output

### Mapping Performance
```
SLAM rate: X.X Hz (should accommodate robot motion)
Features: XXX visual + XXX geometric
Loop closures: X detected
Trajectory length: XX.X meters
```

### Robot-specific Metrics
- **Motion stability**: Tracking consistency during locomotion
- **Height adaptation**: Map quality across elevation changes
- **Gait compatibility**: Performance across different movement patterns

### Visualization
- **3D map**: Environment reconstruction from robot perspective
- **Robot trajectory**: Path accounting for quadruped locomotion
- **Sensor fusion**: Combined visual and geometric features
- **Terrain mapping**: Ground plane and obstacle detection

## Quadruped-specific Challenges

### Dynamic Motion Compensation
```bash
# Tune motion compensation for quadruped gait
rosparam set /rtabmap/rtabmap/RGBD/AngularUpdate 0.03
rosparam set /rtabmap/rtabmap/RGBD/LinearUpdate 0.03

# Increase tracking robustness
rosparam set /rtabmap/rtabmap/Vis/MinInliers 25
```

### Height Variation Handling
- Account for dynamic body height during locomotion
- Compensate for leg extension/compression
- Handle stairs and ramp navigation

### Vibration and Shake
- Filter high-frequency vibrations from leg impacts
- Use IMU for motion compensation
- Adjust feature tracking sensitivity

## Troubleshooting

### Common Issues

1. **Poor tracking during locomotion**:
   ```bash
   # Reduce motion thresholds
   rosparam set /rtabmap/rtabmap/RGBD/AngularUpdate 0.02
   
   # Increase feature tracking robustness
   rosparam set /rtabmap/rtabmap/Vis/InlierDistance 0.05
   ```

2. **IMU integration problems**:
   ```bash
   # Check IMU data
   rostopic echo /imu/data
   
   # Verify IMU calibration
   rostopic echo /imu/mag  # If magnetometer available
   ```

3. **Network connectivity issues**:
   ```bash
   # Check ROS connectivity
   rostopic list
   
   # Monitor network latency
   ping robot_ip
   ```

4. **Robot control problems**:
   - Verify robot SDK installation
   - Check joint states and robot health
   - Ensure proper robot initialization

### Performance Optimization
- **Sensor frequency**: Balance quality vs. computational load
- **Map resolution**: Adjust for available computing power
- **Gait selection**: Choose stable gaits for mapping phases
- **Environmental factors**: Consider lighting and terrain

## Advanced Features

### Autonomous Exploration
```bash
# Integrate with path planning for autonomous mapping
# Use frontier exploration algorithms
# Plan paths considering quadruped constraints
```

### Terrain Classification
```bash
# Classify terrain types from sensor data
# Adapt locomotion based on terrain
# Build semantic maps with traversability
```

### Multi-robot Coordination
```bash
# Coordinate multiple quadruped robots
# Share mapping information
# Distribute exploration tasks
```

## Applications

### Suitable Environments
- **Industrial inspection**: Factories, power plants, refineries
- **Search and rescue**: Disaster zones, collapsed buildings
- **Outdoor exploration**: Natural terrain, construction sites
- **Security patrols**: Large facilities, perimeter monitoring

### Use Cases
- **Autonomous inspection**: Regular facility monitoring
- **Mapping missions**: Site surveying and documentation
- **Research platforms**: Legged robotics algorithm development
- **Emergency response**: Dangerous environment exploration

## Integration with Unitree Ecosystem

### Compatible Packages
- `unitree_legged_sdk`: Low-level robot control
- `unitree_ros`: ROS integration packages
- `unitree_controller`: High-level motion control
- `unitree_gazebo`: Simulation environments

### Custom Development
- Robot-specific motion planners
- Terrain-aware navigation
- Task-specific behaviors
- Custom sensor integration

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_unitree_quadruped_robot.launch`
- **Robot configurations**: Unitree-specific parameter files
- **Sensor calibrations**: Camera and IMU calibration data

## Related Documentation
- [Unitree Robotics Official Documentation](https://www.unitree.com/)
- [Quadruped SLAM Techniques](https://github.com/introlab/rtabmap/wiki)
- [Legged Robot ROS Integration](http://wiki.ros.org/Robots)
- [IMU Integration in SLAM](https://github.com/introlab/rtabmap/wiki/IMU-integration)