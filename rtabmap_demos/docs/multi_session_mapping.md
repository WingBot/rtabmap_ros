# Multi-session Mapping Demo

## Overview
This demo demonstrates RTAB-Map's capability to perform incremental mapping across multiple sessions. It allows you to continue building a map over time, adding new areas or refining existing ones without starting from scratch each time.

## Prerequisites

### Software Dependencies
- ROS (Noetic/Humble/Iron/Jazzy/Rolling)
- RTAB-Map core library and rtabmap_ros packages
- Robot drivers or sensor setup
- Existing RTAB-Map database from previous session

### Conceptual Requirements
- Understanding of RTAB-Map localization vs mapping modes
- Previous mapping session(s) to build upon
- Consistent sensor setup between sessions

## Setup Instructions

### Session 1: Initial Mapping
```bash
# Create initial map (first session)
roslaunch rtabmap_demos demo_multi-session_mapping.launch
# Move robot to explore and create initial map
# Database is saved automatically as rtabmap.db
```

### Session 2+: Incremental Mapping
```bash
# Continue mapping from previous session
# The database_path should point to existing database
roslaunch rtabmap_demos demo_multi-session_mapping.launch database_path:=~/.ros/rtabmap.db
```

### Session N: Localization Only
```bash
# Use for navigation without adding to map
roslaunch rtabmap_demos demo_multi-session_mapping.launch localization:=true
```

## Usage Instructions

### Multi-session Workflow

#### Phase 1: Create Base Map
1. **Start fresh mapping**:
   ```bash
   roslaunch rtabmap_demos demo_multi-session_mapping.launch
   ```
2. **Explore core areas**: Map the main environment thoroughly
3. **Ensure loop closures**: Return to starting areas for map consistency
4. **Save and exit**: Database is automatically saved

#### Phase 2: Extend the Map
1. **Load existing map**:
   ```bash
   roslaunch rtabmap_demos demo_multi-session_mapping.launch database_path:=/path/to/existing/rtabmap.db
   ```
2. **Start from known location**: Begin in an area already mapped
3. **Wait for localization**: Let RTAB-Map relocalize in the existing map
4. **Explore new areas**: Move to unmapped regions
5. **Connect back**: Return to known areas to link new sections

#### Phase 3: Map Refinement
1. **Revisit areas**: Return to previously mapped sections
2. **Add details**: Capture missed features or improve map quality
3. **Fix inconsistencies**: Resolve any mapping errors from previous sessions

### Advanced Multi-session Features

#### Selective Area Mapping
```bash
# Focus on specific areas without full exploration
# Use localization mode in known areas, mapping mode in new areas
```

#### Collaborative Mapping
```bash
# Multiple robots can contribute to the same map database
# Requires careful coordination and possibly map merging
```

## Configuration Parameters

### Key Launch Arguments
- `database_path`: Path to existing database for continuation
- `localization`: Enable localization-only mode
- `delete_db_on_start`: Control whether to start fresh (default: true for first session)

### Critical RTAB-Map Parameters
- `Mem/IncrementalMemory`: true for mapping, false for localization
- `Mem/InitWMWithAllNodes`: Load working memory from database for localization
- `RGBD/ProximityBySpace`: Essential for multi-session localization
- `Mem/MapLabelsAdded`: Track which sessions added which map areas

### Database Management
```bash
# Custom database locations
database_path:=/path/to/project/maps/office_map.db

# Backup databases between sessions
cp rtabmap.db rtabmap_backup_session2.db
```

## Expected Output

### Session Continuation Indicators
```
[ INFO]: rtabmap: Database loaded: X nodes loaded
[ INFO]: rtabmap: Loading working memory...
[ INFO]: rtabmap: Localization mode enabled
[ INFO]: rtabmap: Loop closure detected! Localized in previous map
```

### Progressive Map Building
- **Session 1**: Base environment mapped
- **Session 2**: Extended areas added seamlessly
- **Session N**: Comprehensive multi-area map

### Localization Success
- Robot position correctly estimated in known areas
- Smooth transition between old and new map sections
- Consistent global coordinate frame across sessions

## Understanding Multi-session SLAM

### Technical Concepts

#### Session Transitions
1. **Database loading**: Previous map data loaded into memory
2. **Localization phase**: Robot determines position in existing map
3. **Mapping continuation**: New areas seamlessly integrated
4. **Loop closure**: Connections between old and new areas

#### Memory Management
- **Working Memory (WM)**: Recently visited locations
- **Long-term Memory (LTM)**: Complete database storage
- **Rehearsal**: Process of maintaining map consistency

### Best Practices

#### Session Planning
1. **Overlap regions**: Ensure new sessions start in mapped areas
2. **Consistent sensors**: Use same sensor configuration
3. **Environmental consistency**: Avoid major environment changes
4. **Regular saves**: Backup database between sessions

#### Quality Assurance
```bash
# Verify database integrity between sessions
rtabmap-databaseViewer ~/.ros/rtabmap.db

# Check map consistency
rtabmap-export --poses ~/.ros/rtabmap.db
```

## Troubleshooting

### Common Issues

1. **Localization failure**:
   ```bash
   # Ensure starting position overlaps with existing map
   # Check that sensors are properly calibrated
   # Verify database path is correct
   rostopic echo /rtabmap/info | grep "Loop closure"
   ```

2. **Map inconsistency**:
   ```bash
   # Check for large odometry drift between sessions
   # Verify loop closures are detected
   # Consider graph optimization
   rtabmap-report ~/.ros/rtabmap.db
   ```

3. **Database corruption**:
   ```bash
   # Verify database integrity
   rtabmap-recovery ~/.ros/rtabmap.db
   
   # Restore from backup if needed
   cp rtabmap_backup.db rtabmap.db
   ```

4. **Session disconnection**:
   - Ensure adequate overlap between sessions
   - Check for environmental changes
   - Verify sensor consistency

### Performance Optimization
- **Database size**: Monitor growth over multiple sessions
- **Memory usage**: Limit working memory size for large maps
- **Processing speed**: Consider map optimization between sessions

## Advanced Features

### Map Optimization
```bash
# Optimize map between sessions
rtabmap-console
> open ~/.ros/rtabmap.db
> optimize
> close

# Or using command line
rtabmap-report ~/.ros/rtabmap.db --optimize
```

### Session Labels
```bash
# Add labels to track which session mapped which areas
# Useful for debugging and analysis
```

### Conditional Mapping
```bash
# Map only in specific conditions (lighting, time of day, etc.)
# Useful for maintaining map consistency
```

## Applications

### Suitable Scenarios
- **Long-term mapping**: Building maps over days/weeks/months
- **Large environments**: Areas too big for single session
- **Incremental exploration**: Gradually expanding mapped area
- **Maintenance mapping**: Updating maps as environment changes

### Use Cases
- **Office buildings**: Map different floors or wings separately
- **Outdoor areas**: Map campus or facility over multiple trips
- **Warehouses**: Map sections based on operational schedules
- **Research**: Long-term studies of environment changes

## Files Involved
- **Launch file**: `rtabmap_demos/launch/demo_multi-session_mapping.launch`
- **Database**: Persistent storage across sessions
- **Configuration**: Consistent parameters for all sessions

## Related Documentation
- [RTAB-Map Multi-session Tutorial](https://github.com/introlab/rtabmap/wiki/Multi-session-mapping)
- [Database Management](https://github.com/introlab/rtabmap/wiki/Database-management)
- [Long-term Mapping](https://github.com/introlab/rtabmap/wiki/Long-term-mapping)