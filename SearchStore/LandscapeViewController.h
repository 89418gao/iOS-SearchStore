//
//  LandscapeViewController.h
//  StoreSearch
//
//  Created by Shuyan Guo on 6/7/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"

@interface LandscapeViewController : UIViewController

@property (nonatomic,strong) Search *search;

-(void)presentInParentVC:(UIViewController *)parentVC;
-(void)dismissFromParentVC;
-(void)searchDone;


@end
