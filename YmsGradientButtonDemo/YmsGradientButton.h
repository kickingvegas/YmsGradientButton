//
//  YmsGradientButton.h
//
//  Created by Charles Choi on 3/22/11.
//  Copyright 2011 Yummy Melon Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YmsStyleSheet.h"


@interface YmsGradientButton : UIButton

@property (nonatomic, strong) NSString *resourceName;


- (void)genGradientForState:(UIControlState)aState withConfig:(NSDictionary *)buttonConfig;

- (CAGradientLayer *)configureGradientForState:(UIControlState)aState withConfig:(NSDictionary *)buttonConfig;

- (void)configureShadow:(NSDictionary *)buttonConfig;

- (BOOL)validateConfiguration:(NSDictionary *)buttonConfig;



@end
