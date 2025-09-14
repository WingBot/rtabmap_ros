# RTAB-Map ROS项目架构文档

## 项目概述

RTAB-Map (Real-Time Appearance-Based Mapping) 是一个基于RGB-D、立体视觉和激光雷达的实时SLAM解决方案。本项目是RTAB-Map的ROS(Robot Operating System)集成包，提供了完整的SLAM功能，包括建图、定位、路径规划等。

## 文档结构

- [整体架构](./overall-architecture.md) - 项目总体架构和模块关系
- [模块详细说明](./modules/) - 各个模块的详细文档
  - [rtabmap_slam](./modules/rtabmap_slam.md) - 核心SLAM功能模块
  - [rtabmap_odom](./modules/rtabmap_odom.md) - 里程计计算模块
  - [rtabmap_sync](./modules/rtabmap_sync.md) - 传感器数据同步模块
  - [rtabmap_msgs](./modules/rtabmap_msgs.md) - 消息定义模块
  - [rtabmap_util](./modules/rtabmap_util.md) - 实用工具模块
  - [rtabmap_viz](./modules/rtabmap_viz.md) - 可视化模块
  - [rtabmap_rviz_plugins](./modules/rtabmap_rviz_plugins.md) - RViz插件模块
  - [其他支持模块](./modules/supporting-modules.md)
- [工作流程](./workflows/) - 关键工作流程的序列图
  - [SLAM建图流程](./workflows/slam-mapping.md)
  - [定位流程](./workflows/localization.md)
  - [数据同步流程](./workflows/data-synchronization.md)
- [部署和配置](./deployment/) - 部署模式和配置说明
  - [标准部署模式](./deployment/standard-deployment.md)
  - [分布式部署模式](./deployment/distributed-deployment.md)
  - [配置参数说明](./deployment/configuration.md)

## 快速导航

### 核心概念
- **SLAM**: 同时定位与建图
- **里程计**: 机器人运动估计
- **闭环检测**: 识别已访问位置以修正累积误差
- **图优化**: 优化全局地图的一致性

### 主要功能模块
1. **rtabmap_slam**: 核心SLAM算法实现
2. **rtabmap_odom**: 视觉/激光里程计
3. **rtabmap_sync**: 多传感器数据同步
4. **rtabmap_viz**: 实时可视化
5. **rtabmap_util**: 工具和实用程序

### 支持的传感器
- RGB-D相机 (Kinect, RealSense等)
- 立体相机
- 激光雷达 (2D/3D)
- IMU (惯性测量单元)

## 技术特点

- **实时性能**: 优化的算法确保实时SLAM性能
- **多传感器融合**: 支持多种传感器组合
- **大规模建图**: 支持大型环境的长期建图
- **闭环检测**: 基于外观的闭环检测算法
- **跨平台**: 支持多种操作系统和ROS版本

## 依赖关系

本项目依赖于:
- ROS Melodic/Noetic/Humble/Iron/Jazzy
- RTAB-Map核心库
- OpenCV
- PCL (点云库)
- g2o (图优化)
- GTSAM (几何SLAM工具箱)

## 许可证

BSD 3-Clause License