//
//  AppDelegate.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-14.
//

import UIKit
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        let dataStore = DataStore()
        defaultContainer.register(DataStore.self) { _ in dataStore }
        defaultContainer.register(ChooseCityViewModel.self) { r in
            ChooseCityViewModel(dataStore: r.resolve(DataStore.self)!)
        }
        defaultContainer.register(CityTimeViewModel.self) { r in
            CityTimeViewModel(dataStore: r.resolve(DataStore.self)!)
        }
        defaultContainer.storyboardInitCompleted(CityTimeViewController.self) { r, c in
            c.cityTimeViewModel = r.resolve(CityTimeViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(ChooseCityViewController.self) { r, c in
            c.chooseCityViewModel = r.resolve(ChooseCityViewModel.self)
        }
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
}
