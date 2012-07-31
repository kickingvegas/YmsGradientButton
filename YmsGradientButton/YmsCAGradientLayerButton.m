//
//  YmsCAGradientLayerButton.m
//  YmsGradientButtonDemo
//
//  Created by Charles Y. Choi on 1/11/12.
//  Copyright (c) 2012 Yummy Melon Software LLC. All rights reserved.
//

#import "YmsCAGradientLayerButton.h"

@implementation YmsCAGradientLayerButton


- (void)gradientsImplementationForState:(UIControlState)aState
                             withConfig:(NSDictionary *)buttonConfig
                             forContext:(CGContextRef)context {
    
    NSArray *gradientLayers = [self configureGradientsForState:aState
                                                    withConfig:buttonConfig];
    
    for (CAGradientLayer *gradientLayer in gradientLayers) {
        [gradientLayer renderInContext:context];
    }
    
}



- (NSArray *)configureGradientsForState:(UIControlState)aState
                             withConfig:(NSDictionary *)buttonConfig {
    
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
    
    else if (aState == UIControlStateSelected) {
        stateName = @"selected";
    }
    
    NSDictionary *stateDict = (NSDictionary *)[buttonConfig objectForKey:stateName];
    NSArray *gradients = (NSArray *)[stateDict objectForKey:@"gradients"];
    
    NSMutableArray *gradientLayers = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (NSDictionary *gradient in gradients) {
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        
        [gradientLayer setBounds:[self bounds]];
        [gradientLayer setPosition:CGPointMake([self bounds].size.width/2,
                                               [self bounds].size.height/2)];
        
        NSArray *colorArray = (NSArray *)[gradient objectForKey:@"colors"];
        NSArray *locations = (NSArray *)[gradient objectForKey:@"locations"];
        NSArray *startPointArray = (NSArray *)[gradient objectForKey:@"startPoint"];
        NSArray *endPointArray = (NSArray *)[gradient objectForKey:@"endPoint"];
        
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        
        for (NSNumber *num in colorArray) {
            int n = [num integerValue];
            [colors addObject:(id)[RGBCSS(n) CGColor]];
        }
        
        [gradientLayer setColors:colors];
        
        if ([locations count] > 0) {
            [gradientLayer setLocations:locations];
        }
        
        float startPointNormalizeX = [(NSNumber *)[startPointArray objectAtIndex:0] floatValue];
        float startPointNormalizeY = [(NSNumber *)[startPointArray objectAtIndex:1] floatValue];
        float endPointNormalizeX = [(NSNumber *)[endPointArray objectAtIndex:0] floatValue];
        float endPointNormalizeY = [(NSNumber *)[endPointArray objectAtIndex:1] floatValue];
        
        gradientLayer.startPoint = CGPointMake(startPointNormalizeX, startPointNormalizeY);
        gradientLayer.endPoint = CGPointMake(endPointNormalizeX, endPointNormalizeY);
        
        [gradientLayers addObject:gradientLayer];

    }
    
    CAGradientLayer *lastGradientLayer = [gradientLayers lastObject];
         
  
    NSNumber *textColor = (NSNumber *)[stateDict objectForKey:@"textColor"];
    NSNumber *cornerRadius = (NSNumber *)[stateDict objectForKey:@"cornerRadius"];
    NSNumber *borderColor = (NSNumber *)[stateDict objectForKey:@"borderColor"];
    int borderColorValue = [borderColor integerValue];
    NSNumber *borderWidth = (NSNumber *)[stateDict objectForKey:@"borderWidth"];
    
    int n = [textColor integerValue];

    [self setTitleColor:ARGBCSS(n) forState:aState];
    lastGradientLayer.cornerRadius = [cornerRadius integerValue];
    lastGradientLayer.masksToBounds = YES;
    lastGradientLayer.borderColor = [ARGBCSS(borderColorValue) CGColor];
    lastGradientLayer.borderWidth = [borderWidth floatValue];
    
    return [NSArray arrayWithArray:gradientLayers];
}
 
 



@end
