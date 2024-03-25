FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# apt packages
RUN apt-get update \
 && apt-get install -y libgoogle-glog-dev \
 && rm -rf /var/lib/apt/lists/*

# ROS packages
RUN  mkdir -p /catkin_ws/src
RUN git clone --recurse-submodules \
      https://github.com/Livox-SDK/livox_ros_driver \
      /catkin_ws/src/livox_ros_driver

# code repository
RUN git clone --recurse-submodules \
      https://github.com/RobotResearchRepos/zijiechenrobotics_ig_lio \
      /catkin_ws/src/ig_lio

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && cd /catkin_ws \
 && catkin_make -j1

RUN sed --in-place --expression \
      '$isource "/catkin_ws/devel/setup.bash"' \
      /ros_entrypoint.sh
