cmake_minimum_required(VERSION 3.10)
project(DMGRepro)

set(CMAKE_OSX_ARCHITECTURES "x86_64")
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0")

# Use main.tpp instead of main.cpp
add_executable(${PROJECT_NAME} MACOSX_BUNDLE main.tpp)

set_target_properties(${PROJECT_NAME} PROPERTIES
  MACOSX_BUNDLE_INFO_PLIST ${CMAKE_SOURCE_DIR}/Info.plist.in
)

# Install the bundle so CPack can pick it up
install(TARGETS ${PROJECT_NAME} BUNDLE DESTINATION .)

# CPack configuration for creating a DMG
include(InstallRequiredSystemLibraries)
set(CPACK_GENERATOR "DragNDrop")
set(CPACK_PACKAGE_NAME "DMGRepro")
set(CPACK_PACKAGE_VERSION "1.0.0")
set(CPACK_BUNDLE_NAME "DMGRepro")
set(CPACK_BUNDLE_STARTUP_COMMAND "DMGRepro.app/Contents/MacOS/DMGRepro")

include(CPack)
