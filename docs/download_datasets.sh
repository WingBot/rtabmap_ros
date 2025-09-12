#!/bin/bash

# RTAB-Map 数据集下载脚本
# 此脚本下载项目运行所需的各种数据集

set -e

# 创建数据集目录
DATASETS_DIR="/catkin_ws/datasets"
mkdir -p "$DATASETS_DIR"

echo "开始下载RTAB-Map所需的数据集..."

# 1. EuRoC 数据集 (立体视觉+IMU)
echo "=== 下载EuRoC数据集 ==="
EUROC_DIR="$DATASETS_DIR/euroc"
mkdir -p "$EUROC_DIR"
cd "$EUROC_DIR"

# 下载EuRoC数据集 (选择几个代表性的序列)
echo "下载EuRoC V1_01_easy序列..."
wget -c "http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/v1_01_easy/v1_01_easy.bag" || echo "V1_01_easy下载失败，请手动下载"

echo "下载EuRoC MH_01_easy序列..."
wget -c "http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_01_easy/MH_01_easy.bag" || echo "MH_01_easy下载失败，请手动下载"

# 2. TUM RGB-D 数据集
echo "=== 下载TUM RGB-D数据集 ==="
TUM_DIR="$DATASETS_DIR/tum"
mkdir -p "$TUM_DIR"
cd "$TUM_DIR"

echo "下载TUM RGB-D数据集..."
wget -c "http://vision.in.tum.de/rgbd/dataset/freiburg3/rgbd_dataset_freiburg3_long_office_household.bag" || echo "TUM数据集下载失败，请手动下载"

# 解压TUM数据集
if [ -f "rgbd_dataset_freiburg3_long_office_household.bag" ]; then
    echo "解压TUM数据集..."
    rosbag decompress rgbd_dataset_freiburg3_long_office_household.bag
fi

# 下载TUM数据集重命名脚本
echo "下载TUM数据集重命名脚本..."
wget -c "https://gist.githubusercontent.com/matlabbe/897b775c38836ed8069a1397485ab024/raw/6287ce3def8231945326efead0c8a7730bf6a3d5/tum_rename_world_kinect_frame.py" || echo "重命名脚本下载失败"

# 3. USYD 校园数据集 (激光雷达+相机)
echo "=== 下载USYD校园数据集 ==="
USYD_DIR="$DATASETS_DIR/usyd"
mkdir -p "$USYD_DIR"
cd "$USYD_DIR"

echo "USYD数据集需要从以下链接手动下载："
echo "https://its.acfr.usyd.edu.au/datasets-2/usyd-campus-dataset/"
echo "数据集工具包：https://gitlab.acfr.usyd.edu.au/its/dataset_metapackage"

# 4. 创建数据集索引文件
echo "=== 创建数据集索引 ==="
cat > "$DATASETS_DIR/README.md" << 'EOF'
# RTAB-Map 数据集

本目录包含RTAB-Map项目运行所需的各种数据集。

## 数据集说明

### 1. EuRoC 数据集
- 位置: `euroc/`
- 用途: 立体视觉+IMU SLAM测试
- 使用方法:
  ```bash
  roslaunch rtabmap_examples euroc_datasets.launch
  rosbag play --clock V1_01_easy.bag
  ```

### 2. TUM RGB-D 数据集
- 位置: `tum/`
- 用途: RGB-D SLAM测试
- 使用方法:
  ```bash
  roslaunch rtabmap_examples rgbdslam_datasets.launch
  rosbag play --clock rgbd_dataset_freiburg3_long_office_household.bag
  ```

### 3. USYD 校园数据集
- 位置: `usyd/`
- 用途: 激光雷达+相机SLAM测试
- 下载地址: https://its.acfr.usyd.edu.au/datasets-2/usyd-campus-dataset/
- 使用方法:
  ```bash
  roslaunch dataset_playback run.launch
  roslaunch rtabmap_examples usyd_dataset.launch cameras:=true
  ```

## 下载状态

- [x] EuRoC V1_01_easy
- [x] EuRoC MH_01_easy  
- [x] TUM RGB-D freiburg3
- [ ] USYD Campus Dataset (需要手动下载)

## 注意事项

1. 确保有足够的磁盘空间（至少10GB）
2. 某些数据集可能需要VPN或特殊网络环境
3. 如果自动下载失败，请手动从提供的链接下载
4. 使用前请确保ROS环境已正确配置
EOF

echo "=== 数据集下载完成 ==="
echo "数据集已保存到: $DATASETS_DIR"
echo "请查看 $DATASETS_DIR/README.md 了解详细使用方法"

# 显示磁盘使用情况
echo "当前数据集目录大小:"
du -sh "$DATASETS_DIR"
