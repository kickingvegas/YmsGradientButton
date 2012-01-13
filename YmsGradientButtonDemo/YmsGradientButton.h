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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YmsStyleSheet.h"


@interface YmsGradientButton : UIButton

@property (nonatomic, strong) NSString *resourceName;


- (void)genGradientForState:(UIControlState)aState withConfig:(NSDictionary *)buttonConfig;

- (void)configureShadow:(NSDictionary *)buttonConfig;

- (BOOL)validateConfiguration:(NSDictionary *)buttonConfig;

- (void)renderGradients;

- (void)renderGradientsWithResourceName:(NSString *)name;

/*
 * This method can be overridden if you want to implement your own gradient styling, 
 * provided you maintain compliance with the plist specification.
 */

- (void)gradientImplementationForState:(UIControlState)aState 
                            withConfig:(NSDictionary *)buttonConfig 
                            forContext:(CGContextRef)context;


- (void)addGraphicsForState:(UIControlState)aState 
                 forContext:(CGContextRef)context
                 withOffset:(CGFloat)offset;


@end
