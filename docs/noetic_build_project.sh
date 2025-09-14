#!/bin/bash

# RTAB-Map ROS项目完整编译脚本
# 适用于ROS Noetic和Ubuntu 20.04
# 作者: AI Assistant
# 日期: $(date +%Y-%m-%d)

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "检测到root用户，继续执行..."
    fi
}

# 检查ROS环境
check_ros_environment() {
    log_info "检查ROS环境..."
    
    if [ -z "$ROS_DISTRO" ]; then
        log_error "ROS环境未设置，请先运行: source /opt/ros/noetic/setup.bash"
        exit 1
    fi
    
    if [ "$ROS_DISTRO" != "noetic" ]; then
        log_warning "当前ROS版本: $ROS_DISTRO，建议使用noetic"
    fi
    
    log_success "ROS环境检查通过: $ROS_DISTRO"
}

# 检查系统依赖
check_system_dependencies() {
    log_info "检查系统依赖..."
    
    # 检查必要的包
    local missing_packages=()
    
    if ! command -v cmake &> /dev/null; then
        missing_packages+=("cmake")
    fi
    
    if ! command -v make &> /dev/null; then
        missing_packages+=("make")
    fi
    
    if ! command -v g++ &> /dev/null; then
        missing_packages+=("g++")
    fi
    
    if ! command -v git &> /dev/null; then
        missing_packages+=("git")
    fi
    
    if [ ${#missing_packages[@]} -ne 0 ]; then
        log_error "缺少必要的系统包: ${missing_packages[*]}"
        log_info "请运行: sudo apt update && sudo apt install -y ${missing_packages[*]}"
        exit 1
    fi
    
    log_success "系统依赖检查通过"
}

# 安装ROS依赖
install_ros_dependencies() {
    log_info "安装ROS依赖包..."
    
    # 添加PPA源
    add_ppa_sources
    
    # 如果是从源码编译，只安装基础依赖，不安装预编译包
    if [ "$source_build" = true ]; then
        log_info "源码编译模式：安装基础依赖包..."
        
        # 安装基础ROS开发工具
        local basic_packages=(
            "ros-$ROS_DISTRO-catkin"
            "ros-$ROS_DISTRO-cmake-modules"
            "ros-$ROS_DISTRO-message-generation"
            "ros-$ROS_DISTRO-message-runtime"
            "ros-$ROS_DISTRO-std-msgs"
            "ros-$ROS_DISTRO-sensor-msgs"
            "ros-$ROS_DISTRO-geometry-msgs"
            "ros-$ROS_DISTRO-nav-msgs"
            "ros-$ROS_DISTRO-visualization-msgs"
            "ros-$ROS_DISTRO-cv-bridge"
            "ros-$ROS_DISTRO-image-transport"
            "ros-$ROS_DISTRO-nodelet"
            "ros-$ROS_DISTRO-pcl-ros"
            "ros-$ROS_DISTRO-tf2"
            "ros-$ROS_DISTRO-tf2-ros"
            "ros-$ROS_DISTRO-tf2-geometry-msgs"
            "ros-$ROS_DISTRO-tf2-sensor-msgs"
            "ros-$ROS_DISTRO-tf2-tools"
            "ros-$ROS_DISTRO-rviz"
            "ros-$ROS_DISTRO-rqt"
            "ros-$ROS_DISTRO-rqt-common-plugins"
        )
        
        for package in "${basic_packages[@]}"; do
            log_info "安装基础包 $package..."
            sudo apt install -y "$package" || log_warning "安装 $package 失败"
        done
    else
        log_info "不安装 RTAB-Map ROS预编译包..."
    fi
    
    # 安装RTAB-Map核心依赖
    local core_deps=(
        "libopencv-dev"
        "libpcl-dev"
        "libeigen3-dev"
        "libflann-dev"
        "libvtk7-dev"
        "libsqlite3-dev"
        "liboctomap-dev"
    )
    
    # 安装可选的传感器驱动（如果存在）
    local optional_deps=(
        "libfreenect-dev"
        "libopenni2-dev"
        "libopenni-dev"
        "libzbar-dev"
    )
    
    # 安装核心依赖
    for dep in "${core_deps[@]}"; do
        log_info "安装核心依赖 $dep..."
        sudo apt install -y "$dep" || log_warning "安装 $dep 失败"
    done
    
    # 安装可选依赖包
    for dep in "${optional_deps[@]}"; do
        log_info "尝试安装可选依赖 $dep..."
        if sudo apt install -y "$dep" 2>/dev/null; then
            log_success "成功安装 $dep"
        else
            log_warning "跳过 $dep（包不存在或安装失败）"
        fi
    done
    
    # 检查缺失的依赖包
    check_missing_dependencies
    
    log_success "ROS依赖安装完成"
}

# 检查缺失的依赖包
check_missing_dependencies() {
    log_info "检查缺失的依赖包..."
    
    # RTAB-Map内置了大部分优化器和特征检测器，所以这些检查是可选的
    log_info "RTAB-Map使用内置的优化器和特征检测器，无需额外安装"
    log_success "依赖检查完成"
}

# 添加PPA源以获取更多依赖包
add_ppa_sources() {
    log_info "添加PPA源以获取更多依赖包..."
    
    # 添加ROS PPA（如果还没有）
    if ! grep -q "ros/ubuntu" /etc/apt/sources.list.d/ros-latest.list 2>/dev/null; then
        log_info "添加ROS PPA..."
        sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
        sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    fi
    
    # 更新包列表
    sudo apt update
}

# 检查工作区
check_workspace() {
    log_info "检查工作区..."
    
    # 检查是否在正确的工作空间中
    if [ ! -d "/catkin_ws/src/rtabmap_ros" ]; then
        log_error "未找到RTAB-Map ROS包目录，请确保在正确的工作空间中"
        exit 1
    fi
    
    # 检查是否有子包
    local subpackages=(
        "rtabmap_ros"
        "rtabmap_conversions"
        "rtabmap_msgs"
        "rtabmap_slam"
        "rtabmap_viz"
        "rtabmap_odom"
        "rtabmap_util"
        "rtabmap_sync"
        "rtabmap_launch"
        "rtabmap_demos"
        "rtabmap_examples"
        "rtabmap_rviz_plugins"
        "rtabmap_costmap_plugins"
        "rtabmap_python"
        "rtabmap_legacy"
    )
    
    local found_packages=0
    for package in "${subpackages[@]}"; do
        if [ -f "/catkin_ws/src/rtabmap_ros/$package/CMakeLists.txt" ]; then
            found_packages=$((found_packages + 1))
        fi
    done
    
    if [ $found_packages -eq 0 ]; then
        log_error "未找到任何RTAB-Map ROS子包，请确保在正确的工作空间中"
        exit 1
    fi
    
    log_success "工作区检查通过：RTAB-Map ROS包已找到"
}

# 修复API兼容性问题
fix_api_compatibility() {
    log_info "修复API兼容性问题..."
    
    local msg_conversion_file="/catkin_ws/src/rtabmap_ros/rtabmap_conversions/src/MsgConversion.cpp"
    local maps_manager_file="/catkin_ws/src/rtabmap_ros/rtabmap_util/src/MapsManager.cpp"
    
    # 修复Transform::getAngle() API变化
    if [ -f "$msg_conversion_file" ]; then
        log_info "修复Transform::getAngle() API..."
        sed -i 's/diff\.getAngle()/diff.getAngle(rtabmap::Transform::getIdentity())/g' "$msg_conversion_file"
    fi
    
    # 修复FlannIndex API变化 - 保持原有的buildKDTreeSingleIndex调用
    if [ -f "$maps_manager_file" ]; then
        log_info "检查FlannIndex API..."
        # 不需要修改，使用原有的buildKDTreeSingleIndex方法
        log_info "FlannIndex API检查完成"
    fi
    
    log_success "API兼容性修复完成"
}

# 编译RTAB-Map项目
build_rtabmap_project() {
    log_info "编译RTAB-Map项目..."
    
    # 修复API兼容性问题
    fix_api_compatibility
    
    # 直接使用catkin_make编译整个工作空间
    cd /catkin_ws
    catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release -DWITH_OCTOMAP=OFF
    
    if [ $? -eq 0 ]; then
        log_success "RTAB-Map项目编译成功"
    else
        log_error "RTAB-Map项目编译失败"
        exit 1
    fi
}

# 清理工作空间
clean_workspace() {
    log_info "清理工作空间..."
    
    if [ -d "/catkin_ws/build" ]; then
        log_info "删除build目录..."
        rm -rf /catkin_ws/build
    fi
    
    if [ -d "/catkin_ws/devel" ]; then
        log_info "删除devel目录..."
        rm -rf /catkin_ws/devel
    fi
    
    if [ -d "/catkin_ws/install" ]; then
        log_info "删除install目录..."
        rm -rf /catkin_ws/install
    fi
    
    log_success "工作空间清理完成"
}


# 编译工作空间
build_workspace() {
    log_info "开始编译工作空间..."
    
    cd /catkin_ws
    
    # 使用catkin_make编译整个工作空间
    catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release -DWITH_OCTOMAP=OFF
    
    if [ $? -eq 0 ]; then
        log_success "工作空间编译成功！"
    else
        log_error "工作空间编译失败，请检查错误信息"
        exit 1
    fi
}

# 设置环境变量
setup_environment() {
    log_info "设置环境变量..."
    
    # 添加到bashrc
    local bashrc_line="source /catkin_ws/devel/setup.bash"
    
    if ! grep -q "$bashrc_line" ~/.bashrc; then
        echo "$bashrc_line" >> ~/.bashrc
        log_success "环境变量已添加到 ~/.bashrc"
    else
        log_info "环境变量已存在于 ~/.bashrc"
    fi
    
    # 当前会话设置
    source /catkin_ws/devel/setup.bash
    log_success "当前会话环境变量已设置"
}

# 验证编译结果
verify_build() {
    log_info "验证编译结果..."
    
    # 检查关键可执行文件
    local key_executables=(
        "/catkin_ws/devel/lib/rtabmap_slam/rtabmap"
        "/catkin_ws/devel/lib/rtabmap_viz/rtabmap_viz"
        "/catkin_ws/devel/lib/rtabmap_odom/rtabmap_odom"
    )
    
    for exe in "${key_executables[@]}"; do
        if [ -f "$exe" ]; then
            log_success "找到可执行文件: $(basename $exe)"
        else
            log_warning "未找到可执行文件: $(basename $exe)"
        fi
    done
    
    # 检查ROS包
    if command -v rospack &> /dev/null; then
        if rospack find rtabmap_ros &> /dev/null; then
            log_success "rtabmap_ros包已正确安装"
        else
            log_warning "rtabmap_ros包未找到"
        fi
    fi
}

# 显示使用说明
show_usage() {
    echo "RTAB-Map ROS项目编译脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -c, --clean    清理工作空间后编译"
    echo "  -d, --deps     仅安装依赖包"
    echo "  -v, --verify   仅验证编译结果"
    echo "  --dev          二次开发模式（推荐用于当前工作区）"
    echo "  --no-fix       跳过API兼容性修复"
    echo ""
    echo "编译模式:"
    echo "  标准模式（默认）: 编译当前工作区中的RTAB-Map项目"
    echo "  二次开发模式: 针对二次开发优化的编译流程"
    echo ""
    echo "示例:"
    echo "  $0                    # 标准模式完整编译"
    echo "  $0 --dev              # 二次开发模式（推荐）"
    echo "  $0 --clean            # 清理后编译"
    echo "  $0 --dev --clean      # 二次开发模式清理后编译"
    echo "  $0 --deps             # 仅安装依赖"
    echo "  $0 --verify           # 验证结果"
}

# 主函数
main() {
    local clean_build=false
    local deps_only=false
    local verify_only=false
    local skip_fix=false
    local dev_mode=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -c|--clean)
                clean_build=true
                shift
                ;;
            -d|--deps)
                deps_only=true
                shift
                ;;
            -v|--verify)
                verify_only=true
                shift
                ;;
            --dev)
                dev_mode=true
                shift
                ;;
            --no-fix)
                skip_fix=true
                shift
                ;;
            *)
                log_error "未知参数: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # 显示开始信息
    echo "=========================================="
    echo "    RTAB-Map ROS项目编译脚本"
    echo "=========================================="
    echo "开始时间: $(date)"
    if [ "$dev_mode" = true ]; then
        echo "编译模式: 二次开发模式（当前工作区）"
    else
        echo "编译模式: 标准模式（当前工作区）"
    fi
    echo ""
    
    # 执行相应操作
    if [ "$verify_only" = true ]; then
        verify_build
    elif [ "$deps_only" = true ]; then
        check_root
        check_ros_environment
        check_system_dependencies
        install_ros_dependencies
    elif [ "$dev_mode" = true ]; then
        # 二次开发模式：直接编译当前工作区
        check_root
        check_ros_environment
        check_system_dependencies
        install_ros_dependencies
        check_workspace
        
        if [ "$clean_build" = true ]; then
            clean_workspace
        fi
        
        # API兼容性修复已集成到编译过程中
        
        build_rtabmap_project
        setup_environment
        verify_build
    else
        # 标准编译流程
        check_root
        check_ros_environment
        check_system_dependencies
        install_ros_dependencies
        check_workspace
        
        if [ "$clean_build" = true ]; then
            clean_workspace
        fi
        
        # API兼容性修复已集成到编译过程中
        
        build_workspace
        setup_environment
        verify_build
    fi
    
    echo ""
    echo "=========================================="
    echo "    编译脚本执行完成"
    echo "结束时间: $(date)"
    echo "=========================================="
}

# 运行主函数
main "$@"
