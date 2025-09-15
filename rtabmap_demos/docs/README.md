# RTAB-Map Demos Documentation

This directory contains comprehensive documentation for all RTAB-Map demonstration examples included in the `rtabmap_demos` package.

## Overview

The `rtabmap_demos` package provides 17 different demonstration examples showcasing various capabilities of RTAB-Map, including SLAM, localization, navigation, and object detection across different robot platforms and sensor configurations.

## Demo Categories

### Basic Mapping Demos
- [Appearance-based Mapping](./appearance_mapping.md) - Visual SLAM without depth information
- [Robot Mapping](./robot_mapping.md) - SLAM with recorded robot data
- [TurtleBot Mapping](./turtlebot_mapping.md) - Complete TurtleBot SLAM example

### Advanced Mapping
- [Stereo Outdoor Mapping](./stereo_outdoor.md) - Outdoor stereo vision SLAM
- [Stereo PR2 Mapping](./stereo_pr2.md) - PR2 robot stereo SLAM
- [Multi-session Mapping](./multi_session_mapping.md) - Mapping across multiple sessions
- [Hector Mapping](./hector_mapping.md) - Integration with Hector SLAM

### Navigation Demos
- [TurtleBot3 Navigation](./turtlebot3_navigation.md) - Autonomous navigation with TurtleBot3
- [Isaac Carter Navigation](./isaac_carter_navigation.md) - NVIDIA Isaac navigation example

### Object Detection
- [Find Object Demo](./find_object.md) - Object detection and tracking integration

### Hardware-specific Demos
- [Husky Robot](./husky.md) - Clearpath Husky robot integration
- [Unitree Quadruped](./unitree_quadruped.md) - Quadruped robot SLAM
- [Two Kinects](./two_kinects.md) - Dual Kinect sensor setup

### Utilities
- [Data Recorder](./data_recorder.md) - Recording sensor data for replay
- [TurtleBot RViz](./turtlebot_rviz.md) - Visualization configuration
- [TurtleBot Tango](./turtlebot_tango.md) - Google Tango integration
- [CAT Vehicle](./catvehicle_mapping.md) - Autonomous vehicle mapping

## Quick Start

1. **Prerequisites**: Ensure you have RTAB-Map and its ROS dependencies installed
2. **Choose a demo**: Select the appropriate demo for your use case
3. **Follow the specific guide**: Each demo has detailed setup and run instructions
4. **Visualization**: Most demos support both RViz and rtabmap_viz for visualization

## General Requirements

All demos require:
- ROS (Noetic, Humble, Iron, Jazzy, or Rolling)
- RTAB-Map core library
- rtabmap_ros package and dependencies

Specific hardware or simulation requirements are listed in each demo's documentation.

## Common Usage Patterns

### Database Management
Most demos include `--delete_db_on_start` argument to start fresh. Remove this for continuous mapping.

### Localization Mode
Add `localization:=true` argument to switch from mapping to localization mode.

### Visualization Options
- Use `rviz:=true` for RViz visualization
- Use `rtabmap_viz:=true` for RTAB-Map's native visualization

## Contributing

When adding new demos, please:
1. Create a corresponding documentation file in this directory
2. Update this README with the new demo
3. Follow the established documentation template
4. Include all necessary prerequisites and setup steps