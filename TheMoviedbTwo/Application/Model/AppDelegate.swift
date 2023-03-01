//
//  AppDelegate.swift
//  TheMoviedbTwo
//
//  Created by Aleksandr Bolotov on 01.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let appFactory: AppFactory = Di()
    private var appCoordinator: Coordinator?
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        runUI()
        return true
    }
    
    private func runUI() {
        let (window, coordinator) = appFactory.makeKeyWindowWithCoordinator()
        self.window = window
        self.appCoordinator = coordinator
        window.makeKeyAndVisible()
        coordinator.start()
    }

}

