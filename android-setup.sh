# make more room in the environment
sudo rm -rf ~/.rbenv ~/.phpbrew

# install the necesarry base components
wget https://gist.githubusercontent.com/dekky/dba9c573ac69634e414d5634f92a117d/raw/9644ee625f8b72cc486323f5aaf51aca27b77192/android-sdk-semaphore-v2.sh && source android-sdk-semaphore-v2.sh

# setup Android system image 
(while sleep 3; do echo "y"; done) | sdkmanager "build-tools;26.0.1" "platforms;android-24" "extras;google;m2repository" "extras;android;m2repository" "platform-tools" "emulator" "system-images;android-24;google_apis;armeabi-v7a"

# create an AVD
echo -ne '\n' | avdmanager -v create avd -n semaphore-android-dev -k "system-images;android-24;google_apis;armeabi-v7a" --tag "google_apis" --abi "armeabi-v7a"
