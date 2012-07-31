//
//  YmsCAGradientLayerButton.h
//  YmsGradientButtonDemo
//
//  Created by Charles Y. Choi on 1/11/12.
//  Copyright (c) 2012 Yummy Melon Software LLC. All rights reserved.
//

#import "YmsGradientButton.h"

@interface YmsCAGradientLayerButton : YmsGradientButton

- (CAGradientLayer *)configureGradientForState:(UIControlState)aState withConfig:(NSDictionary *)buttonConfig;

@end
