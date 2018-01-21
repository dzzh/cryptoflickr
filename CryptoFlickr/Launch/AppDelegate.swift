//
//  AppDelegate.swift
//  CryptoFlickr
//
//  Created by Zmicier Zaleznicenka on 20/1/18.
//  Copyright © 2018 Zmicier Zaleznicenka. All rights reserved.
//

import CryptoCore
import os.log
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let serviceLocator = ServiceLocator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }
}

private extension AppDelegate {

    func setup() {
        // Clearly, this is quite a lousy way to start the app. For a more complicated application with multiple screens
        // it would make sense to introduce a layer of coordinators to manage navigation and build the modules.
        // However, this seems an overkill for such a simple project, that's why this shortcut.
        //
        // If you want to see my app that uses the coordinators to orchestrate navigation within and between the flows,
        // have a look at https://github.com/dzzh/parkerly. The architecture there can still be improved
        // (e.g. by extracting dedicated routers and builders), but I'm in general happy with how coordinators work there.

        window = UIWindow(frame: UIScreen.main.bounds)

        guard let flickrService: ImageDownloadServiceType = serviceLocator.getOptional() else {
            os_log("Couldn't create Flickr service")
            window?.rootViewController = UIViewController()
            window?.makeKeyAndVisible()
            return
        }

        let imageBrowserViewModel = ImageBrowserViewModel(imageDownloadService: flickrService)
        window?.rootViewController = ImageBrowserViewController(viewModel: imageBrowserViewModel)
        window?.makeKeyAndVisible()
    }
}

