//
//  YourButton.m
//  YmsGradientButtonDemo
//
//  Created by Charles Y. Choi on 1/11/12.
//  Copyright (c) 2012 Yummy Melon Software LLC. All rights reserved.
//

#import "YourButton.h"

@implementation YourButton

- (void)awakeFromNib {
    // Set resourceName to the filename prefix of the plist configuration file you wish to use for this button.
    self.resourceName = @"YourButton";

    [super awakeFromNib];
}

@end
