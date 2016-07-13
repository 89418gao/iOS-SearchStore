//
//  AppDelegate.m
// StoreSearch
//
//  Created by Shuyan Guo on 6/2/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"
#import "DetailViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)customizeAppearance {
    UIColor *barTintColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:1.0f];
    [[UISearchBar appearance] setBarTintColor:barTintColor];
   
    self.window.tintColor = [UIColor colorWithRed:10/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:
                   [[UIScreen mainScreen] bounds]];
    
    [self customizeAppearance];
    self.searchViewController = [[SearchViewController alloc]
                                 initWithNibName:@"SearchViewController" bundle:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _splitViewController = [[UISplitViewController alloc] init];
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        
        UINavigationController *detailNavigationController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
        
        _splitViewController.delegate = detailViewController;
        _splitViewController.viewControllers = @[_searchViewController,detailNavigationController];
        self.window.rootViewController = _splitViewController;
        
        if(self.window.bounds.size.height > self.window.bounds.size.width){
            UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"❮ Search" style:UIBarButtonItemStylePlain target:_splitViewController.displayModeButtonItem.target action:_splitViewController.displayModeButtonItem.action];
            [detailViewController.navigationItem setLeftBarButtonItem:button];

        }
        _searchViewController.detailVC = detailViewController;
        
        
    } else {
        self.window.rootViewController = self.searchViewController;
    }
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
