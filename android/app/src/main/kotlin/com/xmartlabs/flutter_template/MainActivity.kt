package com.xmartlabs.simon_ai

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import android.widget.Toast
import com.google.mediapipe.examples.gesturerecognizer.GestureRecognizerHelper
import com.google.mediapipe.examples.gesturerecognizer.GestureRecognizerHelper.Companion.DELEGATE_GPU
import com.google.mediapipe.tasks.vision.core.RunningMode
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.xmartlabs.simonai.dev/gesture"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val gestureRecognizerHelper = GestureRecognizerHelper(context = this, minHandDetectionConfidence = 0.1F, minHandPresenceConfidence = 0.1F, minHandTrackingConfidence = 0.1F)


        // Set up the MethodChannel with the same name as defined in Dart
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "recognizeGesture") {
                // Perform platform-specific operations and obtain the result
                val arguments = call.arguments as Map<String, Any>
                val imageByteArray = arguments["image"] as ByteArray
                if (imageByteArray != null) {
                    val bitmap = convertToBitmap(imageByteArray)
                    print(bitmap.height)
//                     You can send back a success message or handle the bitmap as needed
                    gestureRecognizerHelper.recognizeImage(bitmap)
                        ?.let { resultBundle ->
                                // This will return an empty list if there are no gestures detected
                                if(resultBundle.results.first().gestures().isNotEmpty()) {
                                    val sortedCategories = resultBundle.results.first().gestures().first().sortedBy { it.score() }
                                    result.success(sortedCategories.first().categoryName())
                                } else {
                                    result.success("None")
                                }
                        } ?: run {
                        result.error("ERROR THROWN", "Error on classifier", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Image data is null", null)
                }

                // Send the result back to Flutter
//                result.success("data")
            } else {
//                result.notImplemented()
            }
        }
    }

    private fun getDataFromNative(): String {
        // Perform platform-specific operations to fetch the data
        return "Data from Native"
    }

    private fun convertToBitmap(byteArray: ByteArray): Bitmap {
        return BitmapFactory.decodeByteArray(byteArray, 0, byteArray.size)
    }
}
