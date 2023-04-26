
# About

This guide helps your setup the Eurokey 2.0 project development environmetn on your PC (Windows, MAC)
> Make sure to have Java JRE & JDK installed.

# 1. Flutter Install

This section shows how to install FLutter + Dart on your computer.
\
For more information visit the [Official Flutter site](https://docs.flutter.dev/get-started/install).

## For Windows

1. Download [Flutter SDK](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.7.12-stable.zip).

2. Store ZIP content anywhere on your computer.

> ❗ Your path must not contain any special characters or spaces.
> \
> ❗ Your path must not require elevated privileges.

3. Add flutter to your path by going to **Edit environment variables** -> **Enviromental variables** -> **PATH** -> **add** path to flutter/bin as a new variable.
![windows_edit_path](img/01_windows_edit_path.png)

\
4. Run `flutter doctor` in console to verify installation.

## For MAC

1. Make sure you xCode installed.

2. Run `xcode-select --install` in the terminal to install command line tools.

3. Make sure you have [Homebrew](https://brew.sh/) installed. This is the easiest way to install flutter on MacOS.

4. Run `brew install --cask flutter` in the terminal to install flutter and add it to the PATH.

---

# 2. Android Studio Install

This section explains how to prepare an IDE for flutter development.

## For Windows & MAC

1. Download & install the latest [Android Studio](https://developer.android.com/studio).

2. When Android Studio asks you, make sure to install **Android SDK**.

> ❗ If it fails to ask, go to **Settings -> Appearance & Behaviour -> System Settings -> Android SDK** and install Android 13 there.

3. **(MAC ONLY)**
\
To register Android SDK in the system run `cd $HOME`, then `nano .zshrc` in the terminal.
\
Now write `export ANDROID_HOME=$Android SDK Location$` and press **CONTROL+X** then hit **Y** and lastly press **ENTER**.
\
Now restart the terminal and type in `echo $ANDROID_HOME` to check if Android SDK has been registered successfully.

> ❗ Android SDK location can be found in Android Studio **Settings -> Appearance & Behaviour -> System Settings -> Android SDK**.

4. In Android Studio, go to **Settings -> Appearance & Behaviour -> System Settings -> Android SDK**, here, select tab **SDK Tools** and make sure that **Android SDK Command-line Tools (latest)** is installed.
![command_line_tools_install](img/02_command_line_tools_download.jpg)

5. Run `flutter doctor --android-licenses` in console and accept all licenses with `y`.

> ❗ if the error 'JAVA_HOME is set to an invalid directory' shows up, make sure you have a system variable in **Edit environment variables** -> **Enviromental variables** JAVA_HOME set to the path of your JDK.

6. (MAC Only)
\
If flutter doctor says CocoaPods is not installed, open the terminal and run `brew install cocoapods`.

7. In Android Studio go to **settings -> plugins** and make sure you have the **FLutter** and **Dart** packages on their latest versions.

# 3. Project Setup

This section explains how to get the project onto the device.

## For Windows & MAC

1. Clone the [EuroKey 2.0 Repository](https://github.com/ondrej66/RPR1) from GitHub onto your computer.

> ❗ The team uses [GitHub Desktop](https://desktop.github.com/), but you are free to use what you like (Git, Android Studio built-in source control).

2. For the most up-to-date project version, make sure to switch branch to **develop**.

3. Open project in Android Studio.

4. In project's console run `pub get` to update all dependencies for your machine.

>❗ Alternatively you can open pubspec.yaml from project root and click "pub get" on the top right.

# 4. Run on a real device

This section explains how to test the project on a real device.

## For Android

1. Enable [Developer options](https://developer.android.com/studio/debug/dev-options).

2. Enable USB debugging.

3. Connect device to the computer, wait until Android Studio recongnizes device, hit "Run" to start the app on your device.

> ❗ If the error "The supplied javaHome seems to be invalid. I cannot find the java executable" shows up, delete **%Path to Android studio%/jre** folder and restart Android Studio.

# 5. Run on an emulator

This section explains how to test the project on a simulated device.

## For Android

1. In Android Studio open the **Device Manager** (Right side of the screen or View -> Tool Windows -> Device Manager).

2. Under tab **Virtual** hit **Create Device**.

3. Select the device model you want. It is better if it has Play Store support, so Google maps can work properly.
![virtual_device_creation](img/03_virtual_device_creation.jpg)

4. Select OS for the device. Download it with the download icon.
![virtual_device_os](img/04_virtual_device_os.jpg)

5. Name your device and finish setup. It will now show up in the device manager.

6. Hit Play on the device in the Device Manager. This will start up the emulator. The emulated device will now be detected as a device the app can run on.

## For iOS

1. Open Simulator.app.
2. The default iOS device boots when the simulator starts. Android studio should now detect the device for running the app.
