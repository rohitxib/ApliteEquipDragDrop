//
//  AppDelegate.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 17/04/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var myOrientation: UIInterfaceOrientationMask = .portrait

   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
/*
protocol Rotatable: AnyObject {
  func resetToPortrait()
}

extension Rotatable where Self: UIViewController {
  func resetToPortrait() {
    UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
  }
    
  func setToLandscape() {
    UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
  }
}
extension AppDelegate {
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    guard
      let _ = topViewController(for: window?.rootViewController) as? Rotatable
      else { return .portrait }
      
     // return .allButUpsideDown
      return .landscape

  }

  private func topViewController(for rootViewController: UIViewController!) -> UIViewController? {
    guard let rootVC = rootViewController else { return nil }

    if rootVC is UITabBarController {
      let rootTabBarVC = rootVC as! UITabBarController

      return topViewController(for: rootTabBarVC.selectedViewController)
    } else if rootVC is UINavigationController {
      let rootNavVC = rootVC as! UINavigationController

      return topViewController(for: rootNavVC.visibleViewController)
    } else if let rootPresentedVC = rootVC.presentedViewController {
      return topViewController(for: rootPresentedVC)
    }

    return rootViewController
  }
}
*/
