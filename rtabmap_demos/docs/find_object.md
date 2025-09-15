# Find Object Demo

## Overview
This demo integrates RTAB-Map SLAM with the `find_object_2d` package for object detection and tracking. It demonstrates how to combine visual SLAM with object recognition to create maps that include identified objects as landmarks or points of interest.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- find_object_2d package for object detection
- SaveObjectsExample node (included in rtabmap_demos)

### Hardware Requirements
- RGB-D camera (Kinect, RealSense, etc.) or stereo camera
- Computer with adequate processing power for real-time SLAM + object detection

### Installation
```bash
# Install required packages
sudo apt-get install ros-noetic-rtabmap-ros ros-noetic-find-object-2d

# Verify find_object_2d is available
rospack find find_object_2d
```

## Setup Instructions

### 1. Prepare Object Database
Before running the demo, you need to train the object detector:

```bash
# Launch find_object_2d for training
rosrun find_object_2d find_object_2d
```

1. **Capture object images**: Use the GUI to capture multiple views of objects
2. **Train detection**: Let the system extract features from your objects
3. **Save database**: Save the object database for later use

### 2. Launch the Demo
```bash
# Start the complete demo
roslaunch rtabmap_demos demo_find_object.launch
```

### 3. Alternative Visualization
```bash
# Use RViz instead of RTAB-Map visualization
roslaunch rtabmap_demos demo_find_object.launch rviz:=true rtabmap_viz:=false

# Enable object saving as landmarks
roslaunch rtabmap_demos demo_find_object.launch save_objects_as_landmarks:=true
```

## Usage Instructions

### Basic Operation

#### Object Detection Workflow
1. **Training phase**: Capture and train object models using find_object_2d
2. **Detection phase**: Launch the demo to detect trained objects in the environment
3. **Mapping phase**: RTAB-Map builds a map while tracking detected objects
4. **Object integration**: Objects are saved with their 3D positions in the map

#### Interactive Object Training
```bash
# Launch find_object_2d training interface
rosrun find_object_2d find_object_2d

# Or launch with specific session
rosrun find_object_2d find_object_2d objects.xml
```

Training steps:
1. **Add objects**: Click "Add object from scene"
2. **Capture views**: Take multiple images of each object from different angles
3. **Extract features**: The system automatically extracts keypoints
4. **Save session**: Save the trained objects for detection

### Advanced Features

#### Object Saving Options
```bash
# Save detected objects to RTAB-Map database
roslaunch rtabmap_demos demo_find_object.launch save_objects:=true

# Save objects as AprilTag-style landmarks (requires apriltag_ros)
roslaunch rtabmap_demos demo_find_object.launch save_objects_as_landmarks:=true
```

#### Localization with Objects
```bash
# Use objects for relocalization in known maps
roslaunch rtabmap_demos demo_find_object.launch localization:=true
```

## Configuration Parameters

### Key Launch Arguments
- `rviz` (default: true): Enable RViz visualization
- `rtabmap_viz` (default: false): Enable RTAB-Map visualization
- `save_objects` (default: false): Save detected objects to database
- `localization` (default: false): Enable localization-only mode
- `save_objects_as_landmarks` (default: false): Save objects as landmarks

### Object Detection Parameters
The demo configures find_object_2d with:
- Real-time object detection
- Multi-object tracking
- 6DOF pose estimation for detected objects

### RTAB-Map Integration
Key parameters for object integration:
- Object data saved to `user_data_async` topic
- Objects stored with 3D positions and orientations
- Integration with loop closure detection

## Expected Output

### Topics Published
- `/objectsStamped`: Detected objects with poses
- `/objectsData`: Object data for RTAB-Map integration
- `/find_object_2d/detection`: Raw detection results
- `/rtabmap/objects`: Objects integrated into the map

### Visualization Features
- **Object bounding boxes**: Real-time detection overlays
- **3D object poses**: Object positions in the map
- **Object trajectories**: Tracking of moving objects
- **Map integration**: Objects shown as part of the environment map

### Database Integration
Detected objects are stored with:
- **Object ID**: Unique identifier from training
- **3D pose**: Position and orientation in map coordinates
- **Timestamps**: Detection time for temporal queries
- **Associated images**: Camera views containing the objects

## Understanding Object Detection

### Detection Quality Factors
Good object detection requires:
- **Rich textures**: Objects with distinctive visual features
- **Adequate lighting**: Consistent illumination
- **Multiple training views**: Diverse perspectives during training
- **Stable features**: Objects that maintain visual consistency

### 3D Pose Estimation
The system provides full 6DOF poses:
- **Position**: X, Y, Z coordinates in map frame
- **Orientation**: Roll, pitch, yaw angles
- **Accuracy**: Depends on camera calibration and object features

## Troubleshooting

### Common Issues

1. **No objects detected**:
   ```bash
   # Check if find_object_2d is running
   rostopic list | grep find_object
   
   # Verify object database is loaded
   rostopic echo /find_object_2d/info
   ```

2. **Poor detection accuracy**:
   - Improve lighting conditions
   - Retrain objects with more diverse views
   - Check camera calibration quality
   - Adjust detection thresholds

3. **Objects not saving to RTAB-Map**:
   ```bash
   # Verify object data topic
   rostopic echo /objectsData
   
   # Check RTAB-Map is subscribing
   rostopic info /rtabmap/user_data_async
   ```

4. **Performance issues**:
   - Reduce image resolution
   - Limit number of trained objects
   - Optimize find_object_2d parameters

### Performance Optimization
- Train only essential objects to reduce computation
- Use appropriate image resolution for your application
- Consider hardware acceleration for feature extraction
- Monitor CPU usage during combined SLAM + detection

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_find_object.launch`
- **Object saving node**: `rtabmap_demos/src/SaveObjectsExample.cpp`
- **Training interface**: find_object_2d GUI application

## Advanced Integration

### Custom Object Processing
The SaveObjectsExample node demonstrates:
```cpp
// Subscribe to object detections
ros::Subscriber objectsSub = nh.subscribe("/objectsStamped", 1, objectsDetectedCallback);

// Process objects and send to RTAB-Map
rtabmap_msgs::UserData userData;
// ... populate with object data
userDataPub.publish(userData);
```

### AprilTag Integration
When using save_objects_as_landmarks:
```bash
# Requires apriltag_ros package
sudo apt-get install ros-noetic-apriltag-ros

# Objects are treated as fiducial markers for precise localization
```

### Multi-Session Object Mapping
Objects can be used across mapping sessions:
- Load existing object database
- Continue detection in new environments
- Build object-annotated maps over time

## Applications

### Suitable Use Cases
- **Warehouse robotics**: Track inventory items
- **Service robots**: Locate and manipulate known objects  
- **Inspection**: Monitor industrial equipment
- **Assistance**: Help users find specific items

### Integration Examples
- Combine with navigation for object-directed movement
- Use for semantic mapping with known object categories
- Enable object-based query and retrieval systems

## Related Documentation
- [find_object_2d Documentation](http://wiki.ros.org/find_object_2d)
- [RTAB-Map Object Detection](https://github.com/introlab/rtabmap/wiki)
- [AprilTag Integration](http://wiki.ros.org/apriltag_ros)