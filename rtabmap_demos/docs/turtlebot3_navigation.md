# TurtleBot3 Navigation Demo

## Overview
This demo demonstrates autonomous navigation using TurtleBot3 with RTAB-Map for SLAM and localization. It integrates RTAB-Map's mapping capabilities with ROS navigation stack to enable autonomous goal-directed movement in both known and unknown environments.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- TurtleBot3 packages:
  - `turtlebot3_bringup`
  - `turtlebot3_navigation`
  - `turtlebot3_gazebo` (for simulation)
- ROS Navigation Stack
  - `move_base`
  - `amcl` (for localization-only mode)

### Hardware Requirements
- **Physical Robot**: TurtleBot3 (Burger, Waffle, or Waffle Pi) with LiDAR
- **Simulation**: Gazebo-compatible computer for TurtleBot3 simulation

### Installation
```bash
# Install TurtleBot3 packages (ROS Noetic example)
sudo apt-get install ros-noetic-turtlebot3-bringup ros-noetic-turtlebot3-navigation ros-noetic-turtlebot3-gazebo

# Install RTAB-Map
sudo apt-get install ros-noetic-rtabmap-ros

# Set TurtleBot3 model environment variable
echo 'export TURTLEBOT3_MODEL=waffle' >> ~/.bashrc
source ~/.bashrc
```

## Setup Instructions

### Option 1: Physical TurtleBot3

#### 1. Prepare the TurtleBot3
```bash
# On the TurtleBot3 (or via SSH)
roslaunch turtlebot3_bringup turtlebot3_robot.launch
```

#### 2. Launch Navigation Demo
```bash
# On the remote PC
roslaunch rtabmap_demos demo_turtlebot3_navigation.launch
```

### Option 2: Gazebo Simulation

#### 1. Start Gazebo Simulation
```bash
# Set the TurtleBot3 model (if not set in bashrc)
export TURTLEBOT3_MODEL=waffle

# Launch Gazebo world
roslaunch turtlebot3_gazebo turtlebot3_world.launch
```

#### 2. Launch Navigation with Simulation Parameters
```bash
roslaunch rtabmap_demos demo_turtlebot3_navigation.launch simulation:=true
```

## Usage Instructions

### Basic Navigation Workflow

#### Phase 1: Mapping (First Run)
1. **Start the demo** in mapping mode (default)
2. **Move the robot** to explore the environment:
   ```bash
   # Use keyboard teleop to explore
   roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch
   ```
3. **Build the map** by visiting all areas of interest
4. **Save the map** when exploration is complete

#### Phase 2: Navigation (Subsequent Runs)
1. **Launch in localization mode**:
   ```bash
   roslaunch rtabmap_demos demo_turtlebot3_navigation.launch localization:=true
   ```
2. **Set navigation goals** using RViz or command line
3. **Monitor autonomous navigation** performance

### Setting Navigation Goals

#### Using RViz
1. Open RViz visualization
2. Use the "2D Nav Goal" tool
3. Click and drag to set goal position and orientation

#### Using Command Line
```bash
# Send a navigation goal
rostopic pub /move_base_simple/goal geometry_msgs/PoseStamped "
header:
  frame_id: 'map'
pose:
  position:
    x: 2.0
    y: 1.0
    z: 0.0
  orientation:
    w: 1.0"
```

#### Using Action Interface
```bash
# Send goal with action client
rosrun actionlib axclient.py /move_base
```

## Configuration Parameters

### Key Launch Arguments
- `localization` (default: false): Enable localization-only mode
- `simulation` (default: false): Optimize for Gazebo simulation
- `database_path` (default: "rtabmap.db"): Path to map database
- `rviz` (default: true): Launch RViz visualization

### RTAB-Map Navigation Parameters
- `use_action_for_goal`: true (use actionlib with move_base)
- `RGBD/ProximityBySpace`: true (spatial loop closure)
- `RGBD/OptimizeFromGraphEnd`: false (map correction for navigation)
- `Reg/Force3DoF`: true (2D navigation)

### Navigation Stack Parameters
The demo configures move_base with:
- **Global planner**: NavfnROS or DijkstraROS
- **Local planner**: DWAPlannerROS or TebLocalPlannerROS
- **Costmaps**: Static map layer + obstacle layer + inflation layer

## Expected Output

### Topics and Services
- `/map`: Static map for navigation
- `/move_base/goal`: Navigation goal input
- `/move_base/status`: Current navigation status
- `/cmd_vel`: Velocity commands to robot
- `/rtabmap/goal`: RTAB-Map goal interface

### Visualization
- **Global map**: Complete mapped environment
- **Local costmap**: Real-time obstacle detection
- **Robot trajectory**: Path planning and execution
- **Goal markers**: Current navigation targets

### Navigation Status
```bash
# Monitor navigation status
rostopic echo /move_base/status

# Watch robot commands
rostopic echo /cmd_vel
```

## Advanced Features

### Multi-Goal Navigation
Send sequential goals for patrol or coverage:
```bash
# Create a simple patrol script
#!/bin/bash
goals=("x: 2.0, y: 1.0" "x: -1.0, y: 2.0" "x: 0.0, y: 0.0")
for goal in "${goals[@]}"; do
    # Send goal and wait for completion
done
```

### Dynamic Reconfigure
Adjust parameters during runtime:
```bash
# Launch reconfigure GUI
rosrun rqt_reconfigure rqt_reconfigure

# Adjust parameters like:
# - Planning horizon
# - Robot speed limits  
# - Obstacle inflation radius
```

### Recovery Behaviors
The navigation stack includes automatic recovery:
- **Clear costmaps**: Remove stale obstacle information
- **Rotate recovery**: Spin to clear immediate obstacles  
- **Move base flex**: Advanced recovery behaviors

## Troubleshooting

### Common Issues

1. **Robot not localizing**:
   ```bash
   # Check if initial pose is set correctly
   rostopic echo /initialpose
   
   # Manually set initial pose in RViz
   # Use "2D Pose Estimate" tool
   ```

2. **Navigation failing**:
   ```bash
   # Check costmap configuration
   rostopic echo /move_base/global_costmap/costmap
   
   # Verify map quality
   rostopic echo /map
   ```

3. **Path planning issues**:
   ```bash
   # Check if goal is reachable
   rosservice call /move_base/make_plan "start: {position: {x: 0, y: 0, z: 0}} goal: {position: {x: 2, y: 1, z: 0}}"
   
   # Adjust inflation radius if needed
   ```

4. **Localization drift**:
   - Ensure adequate loop closures during mapping
   - Use higher quality visual/laser features
   - Consider re-mapping with better coverage

### Performance Optimization
- **Map quality**: Ensure dense mapping with good loop closures
- **Sensor calibration**: Verify LiDAR and camera calibration
- **Parameter tuning**: Adjust navigation parameters for your environment
- **Computational resources**: Monitor CPU usage during navigation

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_turtlebot3_navigation.launch`
- **Config files**: TurtleBot3 navigation configuration files
- **Database**: `rtabmap.db` containing the mapped environment

## Integration with TurtleBot3 Ecosystem

### Compatible with TurtleBot3 Navigation
This demo can work alongside:
- `turtlebot3_slam` (gmapping alternative)
- `turtlebot3_navigation` (standard navigation)
- `turtlebot3_autorace` (racing applications)

### Model Compatibility
Supports all TurtleBot3 models:
- **Burger**: Basic model with 360° LiDAR
- **Waffle**: Enhanced model with camera
- **Waffle Pi**: Raspberry Pi variant

## Related Documentation
- [TurtleBot3 Navigation Tutorial](https://emanual.robotis.com/docs/en/platform/turtlebot3/navigation/)
- [ROS Navigation Stack](http://wiki.ros.org/navigation)
- [RTAB-Map Navigation Integration](https://github.com/introlab/rtabmap/wiki/Navigation)