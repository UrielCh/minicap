FROM --platform=linux/amd64 ubuntu:22.04

# Set up environment
ENV ANDROID_SDK_ROOT=/opt/android
ENV ANDROID_NDK_HOME=/opt/android/ndk-bundle
ENV PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_NDK_HOME

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends     build-essential git unzip rsync wget automake libtool nasm cmake &&     rm -rf /var/lib/apt/lists/*

# Install Android NDK
RUN mkdir -p /opt/android && \
    cd /opt/android && \
    wget --no-check-certificate https://dl.google.com/android/repository/android-ndk-r25b-linux.zip && \
    unzip android-ndk-r25b-linux.zip && \
    rm android-ndk-r25b-linux.zip && \
    mv android-ndk-r25b ndk-bundle

# Copy project files


# Install libjpeg-turbo 3.1.1
RUN cd /opt &&     wget --no-check-certificate https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/3.1.1.tar.gz -O libjpeg-turbo-3.1.1.tar.gz &&     tar xzf libjpeg-turbo-3.1.1.tar.gz &&     rm libjpeg-turbo-3.1.1.tar.gz
RUN ls -F /opt/libjpeg-turbo-3.1.1/

WORKDIR /opt/libjpeg-turbo-3.1.1
RUN cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=OFF -DENABLE_STATIC=ON .
RUN make && make install

# Copy project files after libjpeg-turbo is installed
COPY . /opt/minicap
COPY .git ./.git
COPY .gitmodules ./.gitmodules
RUN git config --global http.sslVerify false
RUN git submodule sync && git submodule update --init

# Copy the built libjpeg.a to the minicap project's vendor directory
RUN cp /usr/lib/x86_64-linux-gnu/libjpeg.a /opt/minicap/jni/vendor/libjpeg-turbo/libjpeg.a

WORKDIR /opt/minicap


RUN mkdir -p jni/vendor/libjpeg-turbo/include
RUN cp /usr/include/turbojpeg.h /opt/minicap/jni/vendor/libjpeg-turbo/include/turbojpeg.h
RUN ls -l /opt/minicap/jni/vendor/libjpeg-turbo/include/turbojpeg.h

RUN ls -l jni/minicap-shared/aosp/include/Minicap.hpp

# Build the project
# RUN make prebuilt
# RUN ls -l libs/armeabi-v7a/
# RUN ls -R prebuilt