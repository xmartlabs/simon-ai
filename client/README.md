# SimonSays AI

The **SimonSays AI Game** is a modern twist on the classic **Simon Says** game. In the original Simon Says, players must follow a sequence of instructions, like "Simon says touch your nose," but only if the command is prefixed with "Simon says." If players perform an action without the prefix, they lose. Another popular variant uses colors and sound sequences, where players replicate increasingly complex color patterns displayed by the game.

<div align="center">
  <img src="docs/assets/game_demo.gif" alt="Game demo">
  <p><em>Figure 1: A small demo of the SimonSays AI game showcasing the hand gesture recognition and gameplay mechanics.</em></p>
</div>

#### **How This Version is Different:**
In our version, instead of colors or spoken commands, the game uses **hand gestures** that players must replicate using a camera. Here's how it works:

- **Gestures as Commands:** Instead of colored buttons, the game displays a sequence of hand gestures represented as emojis.
- **Player Input:** The player must replicate the sequence of gestures in the correct order using their hand in front of the camera.
- **On device Recognition:** The game uses machine learning models to recognize and evaluate the player’s gestures on device in real time.
- **Progression:** Just like in the original Simon Says, each round adds a new gesture to the sequence, making it progressively more challenging.

This modern version retains the core challenge of memory and coordination from the original **Simon Says**, but adds a layer of interactivity with **gesture-based input**, creating a more immersive and engaging gameplay experience.

## Project Overview

This project is based on the [Xmartlabs Flutter Template][flutter_template_link]. You can check it out for more details and to understand the foundational structure of this project.

## Solving the Gesture Recognition Problem

When developing the **Simon Says Game**, we explored two main approaches to solve the problem of real-time hand gesture recognition:

1. [Direct Integration with TensorFlow Lite:](#integrating-tflite-models-with-flutter-plugin) This method involves using multiple TensorFlow Lite models within Flutter via the official **tflite plugin**. This approach provides flexibility, allowing us to run custom ML models directly within Flutter. However, it presented challenges related to performance, particularly with image preprocessing tasks.

2. [MediaPipe Integration:](#mediapipe-integration) The alternative approach leverages **MediaPipe**, a framework known for its efficiency in real-time ML processing, particularly for gesture recognition. While MediaPipe offers optimized performance, it lacks a native Flutter integration at the moment, requiring us to use native implementations and method channels for communication between Flutter and platform-specific code.

The following sections will outline how we implemented both approaches, the challenges faced, and the performance comparisons between them.

## **Integrating TFLite models with Flutter plugin**

The [Gesture Classifier][gesture_classifier] is responsible for real-time hand gesture recognition in the Simon Says game, using four [TensorFlow Lite][tf_lite] models integrated using the [TFLite Flutter][tflite_flutter] library. Each model performs a specific task, with the output of one model serving as the input for the next, ensuring accurate sequential processing.

<div align="center">
  <img src="docs/assets/model_sequence.png" alt="Model sequence">
  <p><em>Figure 2: Sequence of models used in the Gesture Classifier.</em></p>
</div>

- **Model 1: Hand Bounding Box Detection**

  - Detects the hand's bounding box from the camera feed.
  - Focuses on the area where the hand is located, cropping the image to improve subsequent model performance.

- **Model 2: Hand Landmarks Detection**

  - Processes the cropped hand image from **Model 1**.
  - Detects 21 key landmarks (joints and finger positions) on the hand, providing a detailed structure for gesture recognition.

- **Model 3: Landmarks to Embedding**

  - Analyzes the landmarks detected by **Model 2**.
  - Returns the embedding corresponding to the landmarks received as input.

- **Model 4: Gesture recognizer**

  - Evaluates the embedding from **Model 3** in the context of the models.
  - Returns the gesture label corresponding to the gesture recognized from the image given at the begining in the **Model 1** which can be one of these: unrecognized, closed, open, pointing_up, thumbs_down, thumbs_up, victory, love.

## **MediaPipe Integration**

Apart from integrating directly **TFLite models** for gesture recognition we also use [MediaPipe][mediapipe] as an alternative approach. **MediaPipe** is a powerful framework for building multimodal machine learning pipelines, developed by Google. It provides pre-trained models for hand gesture recognition and other ML tasks, offering high performance for real-time applications.

### **Why Use MediaPipe?**
While **MediaPipe** offers robust gesture recognition models, the current lack of a dedicated Flutter library for fully integrating its solutions required us to implement it using **native code**. This allowed us to take advantage of MediaPipe’s performance, but the integration process was more complex.

### **Integration with Flutter Using Method Channels**
To integrate **MediaPipe** with our Flutter application, we utilized **method channels**, which allow communication between the Flutter app (Dart code) and platform-specific native code (Android and iOS). Here’s how we approached it:

- **Native Implementation:** MediaPipe was set up natively on both Android and iOS platforms using Java/Kotlin for Android and Swift for iOS.
- **Method Channels:** We used Flutter’s method channels to send and receive data between the native MediaPipe code and the Flutter app. This allowed us to pass the camera feed to the native side, where MediaPipe processed the gestures.
- **Gesture Recognition:** Once the gestures were processed by MediaPipe, the results were sent back to Flutter via method channels, where they were used to update the game logic in real-time.

### **Limitations and Benefits**
- **Benefit:** MediaPipe provides highly efficient gesture recognition and improved performance over the previous solution.
- **Limitation:** The integration is limited to using MediaPipe’s pre-trained models, and currently, there’s no direct Flutter library for easily customizing models.


## **Isolate-Based Model Execution**

To maintain a responsive UI and prevent blocking the main thread, the **Gesture Classifier** runs all TensorFlow Lite models on a separate **isolate**. In Flutter, isolates allow tasks to run in parallel, ensuring that computationally heavy operations, such as gesture recognition, do not interfere with the app's UI performance.


## **Game Manager**

The [Game Manager][game_manager] handles the core logic of the game, evaluating user gestures to determine if they match the expected sequence. It interacts with the gesture recognition pipeline and ensures smooth gameplay.

### **Key Responsibilities:**

- **Gesture Handling:**

  - Receives classified gestures from the recognition models running in an isolate.
  - Compares each incoming gesture to the current expected gesture in the sequence, updating the game state accordingly.

- **Sequence Matching:**

  - Maintains an index of the correct gesture sequence.
  - If a gesture matches the expected one, the game advances to the next gesture; if it doesn't, the round ends or resets.

- **Gesture Validation Window:**
  - Implements a **400ms delay** between gesture evaluations to avoid false positives or negatives caused by incomplete transitions or accidental inputs.

---

Made with ❤️ by [Xmartlabs][xmartlabs].

## Contribute
👉 If you want to contribute please feel free to submit pull requests.

👉 If you have a feature request please [open an issue][open_issue].

👉 If you found a bug or [need help][need_help] please let us know.

👉 If you enjoy using Fluttips we would love to hear about it! Drop us a line on [X][xmartlabs_x].

## License

```

Copyright (c) 2024 Xmartlabs SRL

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```


[design_system]: https://github.com/xmartlabs/simon-ai/tree/main/design_system
[app_router]: https://github.com/xmartlabs/simon-ai/blob/main/lib/ui/app_router.dart
[bloc]: https://bloclibrary.dev
[auto_route]: https://pub.dev/packages/auto_route
[models]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/model
[repository_folder]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/repository
[data_source_folder]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/source
[get_it]: https://pub.dev/packages/get_it
[scripts]: https://github.com/xmartlabs/simon-ai/tree/main/scripts
[flutter_template_link]: https://github.com/xmartlabs/flutter-template
[game_manager]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/repository/game_manager.dart
[gesture_classifier]: https://github.com/xmartlabs/simon-ai/tree/main/lib/core/hand_models/hand_gesture_classifier/hand_classifier.dart
[mediapipe]: https://ai.google.dev/edge/mediapipe/solutions/guide
[isolates]: https://docs.flutter.dev/perf/isolates
[tf_lite]: https://ai.google.dev/edge/litert
[xmartlabs]: https://xmartlabs.com/
[open_issue]: https://github.com/xmartlabs/simon-ai/issues/new
[need_help]: https://github.com/xmartlabs/simon-ai/issues/new
[xmartlabs_x]: https://x.com/xmartlabs
[tflite_flutter]: https://pub.dev/packages/tflite_flutter