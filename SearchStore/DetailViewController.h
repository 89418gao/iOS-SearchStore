//
//  DetailViewController.h
//  StoreSearch
//
//  Created by Shuyan Guo on 6/6/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResult;

@interface DetailViewController : UIViewController <UIGestureRecognizerDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) SearchResult *searchResult;

-(void)presentInParentVC: (UIViewController *)parentVC;
-(void)dismissFromParentVC;
-(void)sendSupportEmail;

@end
