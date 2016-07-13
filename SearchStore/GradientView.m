//
//  GradientView.m
//  StoreSearch
//
//  Created by Shuyan Guo on 6/6/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    // 1
    const CGFloat components[8] = { 0.0f, 0.0f, 0.0f, 0.3f,
        0.0f, 0.0f, 0.0f, 0.7f };
    const CGFloat locations[2] = { 0.0f, 1.0f };
    // 2
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(
                                                                 space, components, locations, 2);
    CGColorSpaceRelease(space);
    // 3
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    CGPoint point = CGPointMake(x, y);
    CGFloat radius = MAX(x, y);
    
    // 4
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient, point, 0,
                                point, radius, kCGGradientDrawsAfterEndLocation);
    // 5
    CGGradientRelease(gradient);
}

@end
