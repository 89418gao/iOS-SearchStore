//
//  AppDelegate.h
//  StoreSearch
//
//  Created by Shuyan Guo on 6/2/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SearchViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SearchViewController *searchViewController;
@property (strong, nonatomic) UISplitViewController *splitViewController;

-(void)customizeAppearance;

@end

