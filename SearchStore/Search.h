//
//  Search.h
//  StoreSearch
//
//  Created by Shuyan Guo on 6/8/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

@property (nonatomic, assign) BOOL isLoading;
@property (readonly, nonatomic, strong) NSMutableArray *searchResults;

-(void)performSearchForText:(NSString *)text category:(NSInteger)category completion:(void (^)(BOOL success))completion;

@end
