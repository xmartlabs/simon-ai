import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let gestureService: GestureRecognizerService? = GestureRecognizerService.stillImageGestureRecognizerService(
        modelPath: InferenceConfigurationManager.sharedInstance.modelPath,
        minHandDetectionConfidence: InferenceConfigurationManager.sharedInstance.minHandDetectionConfidence,
        minHandPresenceConfidence: InferenceConfigurationManager.sharedInstance.minHandPresenceConfidence,
        minTrackingConfidence: InferenceConfigurationManager.sharedInstance.minTrackingConfidence,
        delegate: InferenceConfigurationManager.sharedInstance.delegate)
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let gestureChannel = FlutterMethodChannel(name: "com.xmartlabs.simonai/gesture",
                                                binaryMessenger: controller.binaryMessenger)
      
      gestureChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "recognizeGesture" {
              guard let args = call.arguments as? [String: Any],
                    let imageData = args["image"] as? FlutterStandardTypedData else {
                  result(FlutterError(code: "INVALID_ARGUMENT", message: "Image data is missing or invalid", details: nil))
                  return
              }
              
              DispatchQueue.global(qos: .background).async {
                  guard let image = UIImage(data: imageData.data) else {
                      DispatchQueue.main.async {
                          result(FlutterError(code: "IMAGE_CONVERSION_FAILED", message: "Failed to convert image data to UIImage", details: nil))
                      }
                      return
                  }
                  
                  let gesture = gestureService?.recognize(image: image) as? ResultBundle
                  
                  if let gesture = gesture, let gestureRecognizerResult = gesture.gestureRecognizerResults[0], let category = gestureRecognizerResult.gestures.first?.first  {
                      DispatchQueue.main.async {
                          result(category.categoryName)
                      }
                  } else {
                      DispatchQueue.main.async {
                          result("falló")
                      }
                  }
              }
          } else {
              result(FlutterMethodNotImplemented)
          }
      })
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
}
