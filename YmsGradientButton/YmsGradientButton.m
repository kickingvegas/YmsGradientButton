// 
// Copyright 2012 Yummy Melon Software LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Author: Charles Y. Choi <charles.choi@yummymelon.com>
//

#import "YmsGradientButton.h"


@implementation YmsGradientButton
@synthesize resourceName;


- (void)awakeFromNib {
    [super awakeFromNib];
    [self renderGradients];
}

- (void)renderGradients {
    self.layer.masksToBounds = NO;
    
    if (self.resourceName == nil) {
        self.resourceName = NSStringFromClass([self class]);
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.resourceName ofType:@"plist"];
    
    if (path == nil) {
        NSLog(@"WARNING: resource %@.plist does not exist. Using default resource YmsGradientButton.plist.", self.resourceName);
        self.resourceName = @"YmsGradientButton";
        path = [[NSBundle mainBundle] pathForResource:self.resourceName ofType:@"plist"];
    }
    
    NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    if ([self validateConfiguration:buttonConfig]) {
        [self configureShadow:buttonConfig];
        [self genGradientsForState:UIControlStateNormal withConfig:buttonConfig];
        
        if ([buttonConfig objectForKey:@"highlighted"]) {
            [self genGradientsForState:UIControlStateHighlighted withConfig:buttonConfig];
        }
            
        if ([buttonConfig objectForKey:@"selected"]) {
            [self genGradientsForState:UIControlStateSelected withConfig:buttonConfig];
        }

        [self genGradientsForState:UIControlStateDisabled withConfig:buttonConfig];
        
        [self.layer setNeedsDisplay];
    }
    else {
        [NSException raise:@"Invalid YmsGradientButton Configuration" 
                    format:@"Please correct '%@.plist' to resume operation.", self.resourceName];
    }
}


- (void)renderGradientsWithResourceName:(NSString *)name {
    self.resourceName = name;
    [self renderGradients];
}


- (void)genGradientsForState:(UIControlState)aState
                  withConfig:(NSDictionary *)buttonConfig {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 2.0); 
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self gradientsImplementationForState:aState
                               withConfig:buttonConfig forContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    [self setBackgroundImage:image forState:aState];
}



- (void)gradientsImplementationForState:(UIControlState)aState
                             withConfig:(NSDictionary *)buttonConfig
                             forContext:(CGContextRef)context {
    
    /*
     * This method can be overridden if you want to implement your own gradient styling, 
     * provided you maintain compliance with the plist specification.
     */
    
    NSString *stateName;
    
    if (aState == UIControlStateNormal) {
        stateName = @"normal";
    }
	
    else if (aState == UIControlStateHighlighted) {
        stateName = @"highlighted";
    }
	
    else if (aState == UIControlStateSelected) {
        stateName = @"selected";
    }
    
    else if (aState == UIControlStateDisabled) {
        stateName = @"disabled";
    }

    NSNumber *textColor = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"textColor"];
    NSNumber *cornerRadius = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"cornerRadius"];
    NSNumber *borderColor = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"borderColor"];
    NSNumber *borderWidth = (NSNumber *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"borderWidth"];

    // Configure Text Color
    int textColorValue = [textColor integerValue];
    [self setTitleColor:ARGBCSS(textColorValue) forState:aState];

    float cornerRadiusValue = [cornerRadius floatValue];
    int borderColorValue = [borderColor integerValue];
    float borderWidthValue = [borderWidth floatValue];
    
    float roundBorderMargin = cornerRadiusValue > 0 ? 1.0 : 0.0;

    // Render path and set clipping region
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(roundBorderMargin,
                                                                             roundBorderMargin,
                                                                             self.bounds.size.width - (roundBorderMargin * 2),
                                                                             self.bounds.size.height - (roundBorderMargin * 2))
                                                     cornerRadius:cornerRadiusValue];
    
    [ARGBCSS(borderColorValue) setStroke];
    [[UIColor clearColor] setFill];
    bPath.lineWidth = borderWidthValue;
    [bPath fill];
    [bPath stroke];
    
    CGContextAddPath(context, bPath.CGPath);
    CGContextClip(context);
    
    
    // Render Gradient
    NSArray *gradients = (NSArray *)[(NSDictionary *)[buttonConfig objectForKey:stateName] objectForKey:@"gradients"];
    CGColorSpaceRef rgbColorSpace;
    rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    for (NSDictionary *gradient in gradients) {
        NSArray *colorsArray = (NSArray *)[gradient objectForKey:@"colors"];
        NSArray *locationsArray = (NSArray *)[gradient objectForKey:@"locations"];
        NSArray *startPointArray = (NSArray *)[gradient objectForKey:@"startPoint"];
        NSArray *endPointArray = (NSArray *)[gradient objectForKey:@"endPoint"];
        [self contextDrawGradient:context
                       colorSpace:rgbColorSpace
                           colors:colorsArray
                        locations:locationsArray
                       startPoint:startPointArray
                         endPoint:endPointArray];
    }

        
    CGColorSpaceRelease(rgbColorSpace);
    
    [self addGraphicsForState:aState forContext:context withOffset:cornerRadiusValue];
}


- (void)contextDrawGradient:(CGContextRef)context
                 colorSpace:(CGColorSpaceRef)rgbColorSpace
                     colors:(NSArray *)colorsArray
                  locations:(NSArray *)locationsArray
                 startPoint:(NSArray *)startPointArray
                   endPoint:(NSArray *)endPointArray {
    
    CGGradientRef stateGradient;
    
    CGFloat *locations = malloc(sizeof(CGFloat) * locationsArray.count);
    
    for (int i = 0; i < locationsArray.count; i++) {
        NSNumber *e = (NSNumber *)[locationsArray objectAtIndex:i];
        
        CGFloat val = [e floatValue];
        
        locations[i] = val;
    }
    
    size_t numLocations = locationsArray.count;
    
    CGFloat *components = malloc(sizeof(CGFloat) * colorsArray.count * 4);
    
    for (int i=0;  i < colorsArray.count; i++) {
        NSNumber *e = (NSNumber *)[colorsArray objectAtIndex:i];
        int rgb = [e integerValue];
        
        double r = (rgb >> 16 & 0xFF)/255.0;
        double g = (rgb >> 8 & 0xFF)/255.0;
        double b = (rgb & 0xFF)/255.0;
        double a = (rgb >> 24 & 0xFF)/255.0;
        
        components[i * 4] = r;
        components[(i * 4) + 1] = g;
        components[(i * 4) + 2] = b;
        components[(i * 4) + 3] = a;
    }
    
    
    stateGradient = CGGradientCreateWithColorComponents(rgbColorSpace, components, locations, numLocations);
    
    CGRect currentBounds = self.bounds;
    
    float startPointNormalizeX = [(NSNumber *)[startPointArray objectAtIndex:0] floatValue];
    float startPointNormalizeY = [(NSNumber *)[startPointArray objectAtIndex:1] floatValue];
    float endPointNormalizeX = [(NSNumber *)[endPointArray objectAtIndex:0] floatValue];
    float endPointNormalizeY = [(NSNumber *)[endPointArray objectAtIndex:1] floatValue];
    
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(currentBounds) * startPointNormalizeX, CGRectGetMaxY(currentBounds) * startPointNormalizeY);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(currentBounds) * endPointNormalizeX, CGRectGetMaxY(currentBounds) * endPointNormalizeY);
    
    CGContextDrawLinearGradient(context, stateGradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    
    CGGradientRelease(stateGradient);
    
    free(locations);
    free(components);
}


- (void)addGraphicsForState:(UIControlState)aState forContext:(CGContextRef)context withOffset:(CGFloat)offset {
    // Override this method to add more Core Graphics Elements
}



- (BOOL)validateConfiguration:(NSDictionary *)buttonConfig {
    BOOL result = YES;
    
    NSMutableArray *states = [[NSMutableArray alloc] initWithObjects:@"normal"
                              , @"disabled"
                              , nil];
    
    
    for (NSString *key in [NSArray arrayWithObjects:@"highlighted"
                           , @"selected"
                           , nil]) {
        if ([buttonConfig objectForKey:key] != nil) {
            [states addObject:key];
        }
    }
    
    
    NSArray *gradientKeys = [NSArray arrayWithObjects:@"colors"
                             , @"locations"
                             , @"startPoint"
                             , @"endPoint"
                             , nil];

    NSArray *stateKeys = [NSArray arrayWithObjects:@"borderColor"
                          , @"borderWidth"
                          , @"cornerRadius"
                          , @"textColor"
                          , @"gradients"
                          , nil];
    
    for (NSString *stateName in states) {
        NSDictionary *stateDict = (NSDictionary *)[buttonConfig objectForKey:stateName];
        
        for (NSString *stateKey in stateKeys) {
            id obj = [stateDict objectForKey:stateKey];
            
            if (obj == nil) {
                NSLog(@"[ERROR: %@.plist]: %@ is not defined in the %@ section", self.resourceName, stateKey, stateName);
                result = result & NO;
            }
            else {
                if ([stateKey isEqualToString:@"gradients"]) {
                    NSArray *gradients = (NSArray *)obj;
                    if (gradients.count == 0) {
                        result = result & NO;
                    }
                    else {
                        // iterate through gradients
                        NSUInteger index = 0;
                        for (NSDictionary *gradient in gradients) {
                            // Processing each gradient defined in the plist
                            
                            for (NSString *gradientKey in gradientKeys) {
                                id gv = [gradient objectForKey:gradientKey];
                                
                                if (gv == nil) {
                                    NSLog(@"[ERROR: %@.plist]: %@.%@[%d].%@ is not defined.", self.resourceName, stateName, stateKey, index, gradientKey);
                                    result = result & NO;
                                }
                                
                                else {
                                    if ([gradientKey isEqualToString:@"startPoint"] ||
                                        [gradientKey isEqualToString:@"endPoint"]) {
                                        NSArray *pointArray = (NSArray *)gv;
                                        if (pointArray.count < 2) {
                                            NSLog(@"[ERROR: %@.plist]: %@.%@[%d].%@ must have 2 elements.", self.resourceName, stateName, stateKey, index, gradientKey);
                                        }
                                    }

                                }
                            }
                            

                            NSArray *colorArray = (NSArray *)[gradient objectForKey:@"colors"];
                            NSArray *locations = (NSArray *)[gradient objectForKey:@"locations"];
                            
                            if (colorArray.count != locations.count) {
                                NSLog(@"[ERROR: %@.plist]: %@.%@[%d].colors.count != locations.count.", self.resourceName, stateName, stateKey, index);
                                result = result & NO;
                            }
                            
                            index++;
                        }
                    }
                }
            }
        }
    }
    
    
    NSArray *shadowKeys = [NSArray arrayWithObjects:@"enable"
                           , @"shadowOffset"
                           , @"anchorPoint"
                           , @"shadowOpacity"
                           , @"shadowColor"
                           , @"shadowRadius"
                           , nil];
    
   
    NSDictionary *shadow = (NSDictionary *)[buttonConfig objectForKey:@"shadow"];

    if (shadow != nil) {
        for (NSString *shadowKey in shadowKeys) {
            id obj = [shadow objectForKey:shadowKey];
            
            if (obj == nil) {
                NSLog(@"[ERROR: %@.plist]: shadow.%@ is not defined.", self.resourceName, shadowKey);
                result = result & NO;
            }
            else {
                if ([shadowKey isEqualToString:@"anchorPoint"] ||
                    [shadowKey isEqualToString:@"shadowOffset"]) {
                    NSArray *pointArray = (NSArray *)obj;
                    
                    if (pointArray.count < 2) {
                        NSLog(@"[ERROR: %@.plist]: shadow.%@.count must equal 2.", self.resourceName, shadowKey);
                        result = result & NO;
                    }
                }
            }
                      
        }
      
    }
    return result;
}


- (void)configureShadow:(NSDictionary *)buttonConfig {
    // Note that self.layer.masksToBounds should be set NO in order for the shadow to render.
    
    NSDictionary *shadow = (NSDictionary *)[buttonConfig objectForKey:@"shadow"];
    
    if (shadow != nil) {
        NSNumber *enable = (NSNumber *)[shadow objectForKey:@"enable"];
        
        if ([enable boolValue]) {
            NSArray *shadowOffset = (NSArray *)[shadow objectForKey:@"shadowOffset"];
            NSArray *anchorPoint = (NSArray *)[shadow objectForKey:@"anchorPoint"];
            NSNumber *shadowOpacity = (NSNumber *)[shadow objectForKey:@"shadowOpacity"];
            NSNumber *shadowColor = (NSNumber *)[shadow objectForKey:@"shadowColor"];
            NSNumber *shadowRadius = (NSNumber *)[shadow objectForKey:@"shadowRadius"];
            
            
            float x, y;
            int c = [shadowColor integerValue];
            
            x = [(NSNumber *)[shadowOffset objectAtIndex:0] floatValue];
            y = [(NSNumber *)[shadowOffset objectAtIndex:1] floatValue];
            self.layer.shadowOffset = CGSizeMake(x, y);
            
            x = [(NSNumber *)[anchorPoint objectAtIndex:0] floatValue];
            y = [(NSNumber *)[anchorPoint objectAtIndex:1] floatValue];
            self.layer.anchorPoint = CGPointMake(x, y);
            
            self.layer.shadowOpacity = [shadowOpacity floatValue];
            self.layer.shadowRadius = [shadowRadius floatValue];
            self.layer.shadowColor = [ARGBCSS(c) CGColor];
        }
    }
}



@end