//
//  AppDelegate.swift
//  Music
//
//  Created by ruixue on 12/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MusicViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
}

