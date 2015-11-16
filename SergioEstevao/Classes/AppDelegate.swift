import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearance()
        window = UIWindow()
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func setupAppearance() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIView.appearanceWhenContainedInInstancesOfClasses([ContentViewController.self]).backgroundColor = UIColor(colorLiteralRed:  0xf5/255, green: 0xf5/255, blue: 0xf5/255, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        let menuGreen = UIColor(colorLiteralRed:  0x55/255, green: 0xd7/255, blue: 0x37/255, alpha: 1)
        UINavigationBar.appearance().tintColor = menuGreen
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: menuGreen]
        UITabBar.appearance().tintColor = menuGreen
        UITabBar.appearance().barTintColor = UIColor.blackColor()
    }

}

