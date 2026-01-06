import Flutter
import GoogleMaps
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDWYlvqIOJcK-hywoh9wk9sYea3VdP0wJs")

    // Ensure Firebase is configured early (requires GoogleService-Info.plist in Runner target).
    if FirebaseApp.app() == nil {
      let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
      print("GoogleService-Info.plist path: \(plistPath ?? "<nil>")")
      if plistPath != nil {
        FirebaseApp.configure()
      } else {
        print("Firebase not configured: missing GoogleService-Info.plist in app bundle")
      }
    }

    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    // Helpful for debugging in Xcode logs.
    print("FCM registration token: \(fcmToken ?? "<nil>")")
  }
}
