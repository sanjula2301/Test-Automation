FROM ubuntu:18.04

ENV ANDROID_HOME /opt/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Copy the script files
COPY start-android25-emulator.sh /opt/
COPY start-android28-emulator.sh /opt/
COPY start-android29-emulator.sh /opt/

RUN mkdir /opt/android

RUN apt update && apt install openjdk-8-jdk wget unzip git -y
RUN chmod a+x /opt/start-android25-emulator.sh \
  && chmod a+x /opt/start-android28-emulator.sh \
  && chmod a+x /opt/start-android29-emulator.sh
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -qO android-sdk.zip \
  && unzip android-sdk.zip -d /opt/android \
  && rm android-sdk.zip
RUN echo "y" | sdkmanager "tools" \
  && echo "y" | sdkmanager "platform-tools" \
  && echo "y" | sdkmanager "build-tools;29.0.2" \
  && echo "y" | sdkmanager "extras;android;m2repository" \
  && echo "y" | sdkmanager "extras;google;m2repository" \
  && echo "y" | sdkmanager "emulator" \
  && echo "y" | sdkmanager "platforms;android-25" \
  && echo "y" | sdkmanager "system-images;android-25;google_apis;x86" \
  && echo "y" | sdkmanager --update \
  && echo "no" | avdmanager create avd -n android25_emulator -k "system-images;android-25;google_apis;x86" -d 17
RUN echo "y" | sdkmanager "platforms;android-28" \
  && echo "y" | sdkmanager "system-images;android-28;google_apis;x86" \
  && echo "y" | sdkmanager --update \
  && echo "no" | avdmanager create avd -n android28_emulator -k "system-images;android-28;google_apis;x86" -d 17
RUN echo "y" | sdkmanager "platforms;android-29" \
  && echo "y" | sdkmanager "system-images;android-29;google_apis;x86" \
  && echo "y" | sdkmanager --update \
  && echo "no" | avdmanager create avd -n android29_emulator -k "system-images;android-29;google_apis;x86" -d 17
RUN apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install libc++1 \
    curl ca-certificates qemu-kvm libvirt-daemon-system bridge-utils virtinst cpu-checker && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -qqy install nodejs
RUN npm install -g appium@latest --unsafe-perm=true --allow-root
RUN appium driver install uiautomator2
RUN apt-get -qqy install maven


# Expose the ports for Appium server
EXPOSE 5555
EXPOSE 5556
EXPOSE 4723











