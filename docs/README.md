# RTAB-Map ROS项目架构文档

## 项目概述

RTAB-Map (Real-Time Appearance-Based Mapping) 是一个基于RGB-D、立体视觉和激光雷达的实时SLAM解决方案。本项目是RTAB-Map的ROS(Robot Operating System)集成包，提供了完整的SLAM功能，包括建图、定位、路径规划等。

## 文档结构

- [整体架构](./overall-architecture.md) - 项目总体架构和模块关系
- **[插件式架构设计](./plugin-architecture.md) - 插件系统详细设计与架构说明** ⭐
- [插件系统详细文档](#插件系统详细文档) - 各插件系统的深度技术分析
  - [Nodelet插件系统](./nodelet-plugin-system.md) - 高性能数据处理插件
  - [Costmap插件系统](./costmap-plugin-system.md) - 导航栈扩展插件
  - [RViz插件系统](./rviz-plugin-system.md) - 三维可视化插件
  - **[插件开发指南](./plugin-development-guide.md) - 插件扩展开发完整指南** ⭐
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

### 插件系统架构 ⭐ 新增
- **[插件式架构总览](./plugin-architecture.md)**: 完整的插件系统设计原理和架构
- **[Nodelet插件开发](./nodelet-plugin-system.md)**: 高性能数据处理插件详解
- **[Costmap插件开发](./costmap-plugin-system.md)**: 导航栈扩展插件实现
- **[RViz插件开发](./rviz-plugin-system.md)**: 三维可视化插件开发
- **[插件开发完整指南](./plugin-development-guide.md)**: 从零开始的插件开发教程

### 核心概念
- **SLAM**: 同时定位与建图
- **里程计**: 机器人运动估计
- **闭环检测**: 识别已访问位置以修正累积误差
- **图优化**: 优化全局地图的一致性
- **插件架构**: 模块化可扩展的软件设计模式

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

## 插件系统详细文档

RTAB-Map ROS采用了先进的插件式架构设计，通过三套独立但协调的插件系统实现了卓越的可扩展性：

### 🔧 Nodelet插件系统
基于ROS nodelet框架，实现高性能零拷贝数据处理：
- **里程计插件**: RGB-D、立体、ICP、混合里程计算法
- **同步插件**: 多传感器时间同步和数据对齐
- **工具插件**: 点云处理、数据转换、障碍物检测
- **SLAM插件**: 核心SLAM算法包装和接口适配

参见: [Nodelet插件系统详细设计](./nodelet-plugin-system.md)

### 🗺️ Costmap插件系统  
扩展ROS导航栈的代价地图功能：
- **静态层插件**: RTAB-Map生成的静态地图集成
- **体素层插件**: 3D点云数据的2D投影和障碍物检测
- **自定义层**: 支持开发特定应用的代价计算算法

参见: [Costmap插件系统详细设计](./costmap-plugin-system.md)

### 🎮 RViz插件系统
提供丰富的3D可视化组件：
- **地图显示插件**: 实时点云地图可视化和交互
- **图显示插件**: 位姿图、闭环约束的3D渲染
- **信息显示插件**: SLAM统计信息的叠加显示
- **视图控制插件**: 定制化的3D场景导航控制

参见: [RViz插件系统详细设计](./rviz-plugin-system.md)

### 📚 开发指南
想要开发自己的插件？查看完整开发指南：
- **环境搭建**: 开发环境配置和依赖安装
- **项目模板**: 自动化的插件项目生成工具
- **编码规范**: 代码质量标准和最佳实践
- **测试框架**: 自动化测试和持续集成
- **部署指南**: 插件打包、分发和版本管理

参见: [插件开发完整指南](./plugin-development-guide.md)

## 技术特点

- **实时性能**: 优化的算法确保实时SLAM性能
- **多传感器融合**: 支持多种传感器组合
- **大规模建图**: 支持大型环境的长期建图
- **闭环检测**: 基于外观的闭环检测算法
- **跨平台**: 支持多种操作系统和ROS版本
- **🔧 插件式架构**: 易于扩展的模块化设计，支持自定义传感器和算法**
  - **Nodelet插件系统**: 零拷贝高性能数据处理
  - **Costmap插件系统**: 灵活的导航环境建模
  - **RViz插件系统**: 丰富的三维可视化组件
  - **标准化接口**: 统一的插件开发框架

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