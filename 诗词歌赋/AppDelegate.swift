//
//  AppDelegate.swift
//  诗词歌赋
//
//  Created by Beibin Li on 15/7/11.
//  Copyright © 2015年 Beibin Li. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
	
	
	
	/*
		这个 Function 是用来设置 SlideMenuController 的，详情去 Github 找源代码研究
	SlideMenuController(） 讲帮助我们创建三个 VC，以及一个 UINavigationController。（此 NavigationController 连接着 mainViewController，即 ViewController class）
	leftViewController 有一个 variable 叫做 navigationViewController，储存的是 SlideMenuController 中的 NavigationController ，用于 滑动segue
	如果 rightViewController 也需要 滑动 segue，那么它也许要加入这个变量（navigationViewController）
	
	
	
	值得注意的是， viewDidLoad 都是在 开 APP 的时候就 call 了。所以有什么需要改变的事项应该在 ViewDidAppear 里面设置：
		比如：第一次打开 APP 的时候，需要 load CoreData，这时 database 是空的，AllPoetTableVC 里面的 table 是空的，它需要在 ViewDidAppear 里面重新 load table（然而并没有什么卵用... 为什么）
	
	*/
	private func createMenuView() {
		
		// create viewController code...
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		
		// Remember to set the Storyboard ID for these ViewControllers in storyboard
		let mainViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
		let leftViewController = storyboard.instantiateViewControllerWithIdentifier("AllPoetTableVC") as! AllPoetTableVC
		let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
		
		let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
		leftViewController.navigationViewController = nvc
		
		
		
		
		let bar = nvc.navigationBar
		bar.alpha = 0.3
		bar.tintColor = .orangeColor() // 文字，logo 的颜色
		bar.backgroundColor = .redColor()
		bar.translucent = true
		
		// Load the Introduction in First Launch, on the top of NavigationController
		load_introduction(mainViewController)
		
		
		
		// The mainViewController is Navigation Controller, not the "ViewController"
		let slideMenuController = SlideMenuController(mainViewController:nvc, leftViewController, rightViewController)
		
		self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
		self.window?.rootViewController = slideMenuController
		self.window?.makeKeyAndVisible()
	}
	
	
	private func load_introduction( vc:UIViewController ) {
		
		
		// delete the random part
		let introduction = "introduction_0.1" // + String(arc4random())
		
		
		if( !NSUserDefaults.standardUserDefaults().boolForKey(introduction) ) {
			print("Loading data from .txt file ... ")
			
			let item1 = RMParallaxItem(image: UIImage(named: "img1")!, text: "随时感悟诗词歌赋")
			let item2 = RMParallaxItem(image: UIImage(named: "img2")!, text: "用心体会世间万物")
			let item3 = RMParallaxItem(image: UIImage(named: "img3")!, text: "让灵魂跟上肉体的步伐")
			let item4 = RMParallaxItem(image: UIImage(named: "img4")!, text: "让经典与您随影随行")
			
			let rmParallaxViewController = RMParallax(items: [item1, item2, item3, item4], motion: false)
			rmParallaxViewController.completionHandler = {
				UIView.animateWithDuration(0.4, animations: { () -> Void in
					rmParallaxViewController.view.alpha = 0.0
				})
			}
			
			// Adding parallax view controller.
			vc.addChildViewController(rmParallaxViewController)
			vc.view.addSubview(rmParallaxViewController.view)
			rmParallaxViewController.didMoveToParentViewController(vc)
			
			// Override the syntax
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: introduction)
			NSUserDefaults.standardUserDefaults().synchronize();
		}
		
	}
	
	
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
		
		
		// Load the databse before even launching the ViewController. Otherwise, the database would be empty
		load_db_in_frist_launch()
		
		createMenuView()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "U-of-M.cored" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        
        // PoetDM is the DataModel file for the database
        let modelURL = NSBundle.mainBundle().URLForResource("PoetDM", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    
}

