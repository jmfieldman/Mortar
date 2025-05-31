//
//  AppDelegate.swift
//  Copyright © 2025 Jason Fieldman.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = MainMenuViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
