//
//  YmsCAGradientLayerButton.m
//  YmsGradientButtonDemo
//
//  Created by Charles Y. Choi on 1/11/12.
//  Copyright (c) 2012 Yummy Melon Software LLC. All rights reserved.
//

#import "YmsCAGradientLayerButton.h"

@implementation YmsCAGradientLayerButton



- (void)gradientImplementationForState:(UIControlState)aState 
                            withConfig:(NSDictionary *)buttonConfig 
                            forContext:(CGContextRef)context {
    
    CAGradientLayer *gradientLayer = [self configureGradientForState:aState withConfig:buttonConfig];
    [gradientLayer renderInContext:context];
    
}



- (CAGradientLayer *)configureGradientForState:(UIControlState)aState withConfig:(NSDictionary *)buttonConfig {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    [gradientLayer setBounds:[self bounds]];
    [gradientLayer setPosition:CGPointMake([self bounds].size.width/2,
                                           [self bounds].size.height/2)];
    
    NSString *stateName;
    
    if (aState == UIControlStateNormal) {
        stateName = @"normal";
    }
    
    else if (aState == UIControlStateHighlighted) {
        stateName = @"highlighted";
    }
    
    else if (aState == UIControlStateDisabled) {
        stateName = @"disabled";
    }
    
    NSArray *colorArray = (NSArray *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"colors"];
    NSArray *locations = (NSArray *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"locations"];
    NSArray *startPointArray = (NSArray *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"startPoint"];
    NSArray *endPointArray = (NSArray *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"endPoint"];

    NSNumber *textColor = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"textColor"];
    NSNumber *cornerRadius = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"cornerRadius"];
    NSNumber *borderColor = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"borderColor"];
    int borderColorValue = [borderColor integerValue];
    NSNumber *borderWidth = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"borderWidth"];
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (NSNumber *num in colorArray) {
        int n = [num integerValue];
        [colors addObject:(id)[RGBCSS(n) CGColor]];
    }
    
    [gradientLayer setColors:colors];
    
    if ([locations count] > 0)
        [gradientLayer setLocations:locations];
    
    int n = [textColor integerValue];
    [self setTitleColor:RGBCSS(n) forState:aState];
    gradientLayer.cornerRadius = [cornerRadius integerValue];
    gradientLayer.masksToBounds = YES;
    gradientLayer.borderColor = [RGBCSS(borderColorValue) CGColor];
    gradientLayer.borderWidth = [borderWidth floatValue];

    float startPointNormalizeX = [(NSNumber *)[startPointArray objectAtIndex:0] floatValue];
    float startPointNormalizeY = [(NSNumber *)[startPointArray objectAtIndex:1] floatValue];
    float endPointNormalizeX = [(NSNumber *)[endPointArray objectAtIndex:0] floatValue];
    float endPointNormalizeY = [(NSNumber *)[endPointArray objectAtIndex:1] floatValue];
    
    gradientLayer.startPoint = CGPointMake(startPointNormalizeX, startPointNormalizeY);
    gradientLayer.endPoint = CGPointMake(endPointNormalizeX, endPointNormalizeY);
    
    return gradientLayer;
}
 
 



@end
