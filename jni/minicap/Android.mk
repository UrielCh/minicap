LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := jpeg
LOCAL_SRC_FILES := ../vendor/libjpeg-turbo/libjpeg.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := minicap-common
LOCAL_SRC_FILES := \
	JpgEncoder.cpp \
	SimpleServer.cpp \
	minicap.cpp
LOCAL_C_INCLUDES := /opt/minicap/jni/vendor/libjpeg-turbo/include \
	/opt/minicap/jni/minicap-shared/aosp/include
LOCAL_STATIC_LIBRARIES := jpeg
include $(BUILD_STATIC_LIBRARY)