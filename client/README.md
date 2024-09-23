# SimonSays AI

## Arch Overview

The project is divided into two main folders:

- The UI contains all app screens.
- The Core contains the models and the data layer.

The design system is located on a package called [design_system][design_system].

### UI section

[Flutter Bloc][bloc] is used for state management, specifically, we use Cubit to manage the screen state.
Each app section is added in a project folder which contains three components, the Screen (a `StatelessWidget`, the UI), the Cubit and the state.

The `MainScreen` is the Widget that contains all screens. It defines the `MaterialApp` and provides the app router.
The router has two subgraphs, the `UnauthenticatedRouter` used for unauthenticated users and the `AuthenticatedRouter` used for authenticated users.

The [app router][app_router] is provided by [auto_route][auto_route], and contains the previous sections with some nested screens.

### Core section

The models are defined in the [models folder][models].

The repository pattern is used to manage the data layer.
A [repository][repository_folder] uses different [data sources][data_source_folder] (for example a local cache or a REST API).
These components are injected in the Cubits using [get_it][get_it].

### **How Gesture Classifier Works**

The **Gesture Classifier** is responsible for real-time hand gesture recognition in the Simon Says game, using four TensorFlow Lite models. Each model performs a specific task, with the output of one model serving as the input for the next, ensuring accurate sequential processing.

#### **Model 1: Hand Bounding Box Detection**

- Detects the hand's bounding box from the camera feed.
- Focuses on the area where the hand is located, cropping the image to improve subsequent model performance.

#### **Model 2: Hand Landmarks Detection**

- Processes the cropped hand image from **Model 1**.
- Detects 21 key landmarks (joints and finger positions) on the hand, providing a detailed structure for gesture recognition.

#### **Model 3: Landmarks to Embedding**

- Analyzes the landmarks detected by **Model 2**.
- Returns the embedding corresponding to the landmarks received as input.

#### **Model 4: Gesture recognizer**

- Evaluates the embedding from **Model 3** in the context of the models.
- Returns the gesture label corresponding to the gesture recognized from the image given at the begining in the **Model 1** which can be one of these: unrecognized, closed, open, pointing_up, thumbs_down, thumbs_up, victory, love.


### **Isolate-Based Model Execution**

To maintain a responsive UI and prevent blocking the main thread, the **Gesture Classifier** runs all TensorFlow Lite models on a separate **isolate**. In Flutter, isolates allow tasks to run in parallel, ensuring that computationally heavy operations, such as gesture recognition, do not interfere with the app's UI performance.

#### **HandClasifierIsolateData**
This is the class that defines the data passed to the isolate, including the image, the interpreters where have been loaded the models and the sendPort where the result will be later retured.


### **Game Manager**

The **Game Manager** handles the core logic of the game, evaluating user gestures to determine if they match the expected sequence. It interacts with the gesture recognition pipeline and ensures smooth gameplay.

#### **Key Responsibilities:**

- **Gesture Handling:**

  - Receives classified gestures from the recognition models running in an isolate.
  - Compares each incoming gesture to the current expected gesture in the sequence, updating the game state accordingly.

- **Sequence Matching:**

  - Maintains an index of the correct gesture sequence.
  - If a gesture matches the expected one, the game advances to the next gesture; if it doesn't, the round ends or resets.

- **Gesture Validation Window:**
  - Implements a **400ms delay** between gesture evaluations to avoid false positives or negatives caused by incomplete transitions or accidental inputs.

## Project Overview

### Assets

The [`/assets/`](./assets) folder contains the assets used by the application, such as images, fonts, and other files.

### Environments

The environment variables are defined in the `default.env` file located in [`/environments/`](./environments) folder.
You can read more information about the environment variables in the [README.md](./environments/README.md) file.

## Project Setup

The project setup is based on some plugins which generate the required native code.

You can use [project_setup.sh](scripts/project_setup.sh) to reload all project setups.

### Flavor setup: Project name, properties BundleId & Application id

This information is set using [flavorizr], a flutter utility to easily create flavors in your flutter application.
To change it go to `flavorizr` section in the [pubspec] file.

For example, to add a new flavour, you can do something like:

```yaml
flavorizr:
  flavors:
    qa:
      app:
        name: "My Project - QA"
      android:
        applicationId: "com.xmartlabs.myproject.qa"
      ios:
        bundleId: "com.xmartlabs.myproject.qa"
```

After a change is made, you need to regenerate your native files.
You can do that by executing `flutter pub run flutter_flavorizr`.

More information in [flavorizr] page.

### App icons

Icons are generated using [flutter_launcher_icons] plugin.
To change it go to `flutter_icons` section in the [pubspec] file.

After a change is made, you need to regenerate your native files.
You can do that by executing `flutter pub run flutter_launcher_icons:main`.

### Splash screen

Splash screen is generated using [flutter_native_splash].
To change it go to `flutter_native_splash` section in the [pubspec] file.

After a change is made, you need to regenerate your native files.
You can do that by executing `flutter pub run flutter_native_splash:create`.

Although you can setup a bunch of features in this library, it doesn't provide a way to display animations.
If you need a more personalized splash screen, you can edit the native code or just remove this library.

### Code generation

Code generation is created using `build_runner` package.\
To configure this package edit the `build.yaml`\
To add new files to watch for code generation add the following lines:

```
targets:
  $default:
    builders:
      # Previous configured builders
      ...
      builder_package_name:
        generate_for:
          # Example glob for only the Dart files under `lib/models`
          - lib/models/*.dart
```

To create generated code run `clean_up.sh` under [scripts] folder or the following command: `flutter pub run build_runner build --delete-conflicting-outputs`

### Pre Push config

In order to setup pre-push hook you need to go to the root of the project and run `git config core.hooksPath .github/hooks`

[design_system]: https://github.com/xmartlabs/simon-ai/tree/main/design_system
[flavorizr]: https://pub.dev/packages/flutter_flavorizr
[flutter_launcher_icons]: https://pub.dev/packages/flutter_launcher_icons
[flutter_native_splash]: https://pub.dev/packages/flutter_native_splash
[pubspec]: ./pubspec.yaml
[app_router]: https://github.com/xmartlabs/simon-ai/blob/main/lib/ui/app_router.dart
[bloc]: https://bloclibrary.dev
[auto_route]: https://pub.dev/packages/auto_route
[flutter_screenutil]: https://pub.dev/packages/flutter_screenutil
[models]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/model
[repository_folder]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/repository
[data_source_folder]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/source
[get_it]: https://pub.dev/packages/get_it
[scripts]: https://github.com/xmartlabs/simon-ai/tree/main/scripts
