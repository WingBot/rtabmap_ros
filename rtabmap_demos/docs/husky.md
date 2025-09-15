# Husky Robot Demo

## Overview
This demo demonstrates RTAB-Map integration with Clearpath Husky UGV (Unmanned Ground Vehicle) featuring multiple sensor configurations including 2D/3D LiDAR and RGB-D cameras. It showcases advanced outdoor robotics SLAM with both 6DoF and 3DoF (2D) mapping capabilities.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- Husky packages:
  - `husky_gazebo` for simulation
  - `husky_navigation` for navigation
  - `husky_viz` for visualization
- Sensor packages:
  - `realsense2_camera` (for RealSense RGB-D)
  - `velodyne_pointcloud` (for Velodyne 3D LiDAR)
  - `sick_tim` or similar (for 2D LiDAR)

### Hardware/Simulation Requirements
- **Physical Robot**: Clearpath Husky with configured sensors
- **Simulation**: Gazebo with Husky simulation environment

### Optional Advanced Features
- libpointmatcher (for ICP odometry examples)
- GPU acceleration for 3D LiDAR processing

### Installation
```bash
# Install Husky packages
sudo apt-get install ros-noetic-husky-simulator ros-noetic-husky-navigation

# Install sensor packages
sudo apt-get install ros-noetic-realsense2-camera ros-noetic-velodyne

# Install RTAB-Map with advanced features
sudo apt-get install ros-noetic-rtabmap-ros
```

## Sensor Configuration

### Environment Variables Setup
Configure Husky sensors before launching:

```bash
# Basic setup with 2D LiDAR and RealSense
export HUSKY_UST10_ENABLED=1                    # Enable 2D LiDAR
export HUSKY_REALSENSE_ENABLED=1                # Enable RGB-D camera
export HUSKY_REALSENSE_XYZ="0.2206 0 0.1"      # Camera position

# Advanced setup with Velodyne 3D LiDAR
export HUSKY_URDF_EXTRAS=$(rospack find rtabmap_demos)/launch/config/husky_velodyne_gpu_extra.urdf.xacro
```

### Gazebo Simulation Setup
```bash
# Launch Husky in Gazebo
roslaunch husky_gazebo husky_playpen.launch

# Optional: View robot model
roslaunch husky_viz view_robot.launch
```

## Demo Configurations

### 1. 6DoF Mapping with 3D LiDAR
```bash
roslaunch rtabmap_demos demo_husky.launch lidar3d:=true slam2d:=false
```
- Uses Velodyne 3D LiDAR for full 6-degree-of-freedom SLAM
- Suitable for complex outdoor environments with elevation changes

### 2. 6DoF Mapping with 3D LiDAR + RGB-D Camera
```bash
roslaunch rtabmap_demos demo_husky.launch lidar3d:=true slam2d:=false camera:=true
```
- Combines 3D LiDAR and RealSense camera data
- Enhanced loop closure detection with visual features

### 3. 6DoF Mapping with ICP Odometry
```bash
roslaunch rtabmap_demos demo_husky.launch lidar3d:=true slam2d:=false camera:=true icp_odometry:=true
```
- Adds ICP-based odometry for improved pose estimation
- Uses wheel odometry as initial guess

### 4. 3DoF (2D) Mapping with 3D LiDAR
```bash
roslaunch rtabmap_demos demo_husky.launch lidar3d:=true slam2d:=true
```
- Constrains SLAM to 2D plane despite using 3D sensor
- Suitable for flat outdoor environments

### 5. 3DoF Mapping with 3D LiDAR + RGB-D
```bash
roslaunch rtabmap_demos demo_husky.launch lidar3d:=true slam2d:=true camera:=true
```
- 2D SLAM with multi-sensor fusion
- Robust loop closure detection

### 6. 3DoF Mapping with 2D LiDAR
```bash
roslaunch rtabmap_demos demo_husky.launch lidar2d:=true slam2d:=true
```
- Traditional 2D SLAM using planar LiDAR
- Lightweight processing requirements

### 7. 2D LiDAR + RGB-D Camera
```bash
roslaunch rtabmap_demos demo_husky.launch lidar2d:=true slam2d:=true camera:=true
```
- Combines 2D laser with visual features
- Enhanced loop closure in visually rich environments

## Configuration Parameters

### Key Launch Arguments
- `lidar3d` (default: false): Enable 3D LiDAR processing
- `lidar2d` (default: false): Enable 2D LiDAR processing
- `slam2d` (default: false): Constrain SLAM to 2D plane
- `camera` (default: false): Include RGB-D camera data
- `icp_odometry` (default: false): Enable ICP-based odometry

### Sensor-specific Parameters
#### 3D LiDAR Configuration
- Point cloud processing and filtering
- Voxel grid downsampling for performance
- Range and field-of-view limitations

#### RGB-D Camera Configuration
- Depth image processing
- Visual feature extraction parameters
- Camera-LiDAR synchronization

### RTAB-Map Parameters
Key parameters optimized for outdoor environments:
- `Grid/CellSize`: Occupancy grid resolution
- `Grid/RangeMax`: Maximum sensor range
- `RGBD/ProximityBySpace`: Spatial loop closure
- `Icp/PM`: Use libpointmatcher for ICP

## Expected Output

### Mapping Results
- **3D point cloud map**: Dense environmental reconstruction
- **2D occupancy grid**: Navigation-ready map format
- **Loop closures**: Detected revisited areas
- **Trajectory**: Robot path through environment

### Performance Metrics
```
Processing rate: X.X Hz
Point cloud size: XXXXX points
Loop closures: X detected
Map size: XX MB
```

### Visualization Options
- RViz: Standard ROS visualization
- RTAB-Map viz: Native 3D visualization
- Point cloud viewers: Detailed sensor data inspection

## Advanced Features

### ICP Odometry
When enabled, provides:
- Improved pose estimation accuracy
- Robustness to wheel slip
- Enhanced performance in challenging terrain

### Multi-sensor Fusion
Combines:
- Wheel odometry (base estimation)
- LiDAR odometry (ICP-based correction)
- Visual odometry (RGB-D features)
- IMU data (if available)

### GPU Acceleration
For 3D LiDAR processing:
- Accelerated point cloud operations
- Real-time performance with dense data
- Requires CUDA-capable hardware

## Troubleshooting

### Common Issues

1. **Missing sensor data**:
   ```bash
   # Check sensor topics
   rostopic list | grep -E "(velodyne|realsense|sick)"
   
   # Verify environment variables
   env | grep HUSKY
   ```

2. **Poor ICP performance**:
   ```bash
   # Ensure libpointmatcher is installed
   rospack find libpointmatcher_ros
   
   # Check point cloud quality
   rostopic echo /velodyne_points
   ```

3. **Simulation performance**:
   - Reduce sensor resolution/frequency
   - Disable unnecessary Gazebo plugins
   - Use headless mode for pure SLAM testing

4. **Real robot connectivity**:
   ```bash
   # Check robot connection
   ping husky-cpr
   
   # Verify ROS_MASTER_URI
   echo $ROS_MASTER_URI
   ```

### Performance Optimization
- **3D LiDAR**: Adjust point cloud downsampling
- **GPU usage**: Monitor GPU memory and utilization
- **Network**: Optimize data transmission for remote operation
- **Processing**: Balance accuracy vs. computational requirements

## Real-World Applications

### Suitable Environments
- **Outdoor facilities**: Industrial sites, farms, construction
- **Large indoor spaces**: Warehouses, factories
- **Mixed terrain**: Both structured and unstructured environments
- **Long-range operations**: Extended autonomous missions

### Use Cases
- **Autonomous navigation**: Outdoor mobile robotics
- **Inspection tasks**: Infrastructure monitoring
- **Mapping missions**: Site surveying and documentation
- **Research platforms**: Algorithm development and testing

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_husky.launch`
- **URDF extras**: `rtabmap_demos/launch/config/husky_velodyne_gpu_extra.urdf.xacro`
- **Husky configurations**: Environment variable setups

## Integration with Husky Ecosystem

### Compatible Packages
- `husky_navigation`: Autonomous navigation
- `husky_cartographer`: Alternative SLAM solution
- `husky_control`: Low-level robot control
- `husky_msgs`: Husky-specific message types

### Sensor Integration
- Easy addition of new sensors via URDF extras
- Flexible configuration through environment variables
- Support for multiple sensor combinations

## Related Documentation
- [Clearpath Husky Documentation](https://clearpathrobotics.com/assets/guides/melodic/husky/)
- [Velodyne ROS Driver](http://wiki.ros.org/velodyne)
- [RealSense ROS Wrapper](https://github.com/IntelRealSense/realsense-ros)
- [libpointmatcher](https://github.com/ethz-asl/libpointmatcher)