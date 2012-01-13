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

#import "YourButton.h"

@implementation YourButton


// This is an example of adding custom graphics over the gradient.
- (void)addGraphicsForState:(UIControlState)aState forContext:(CGContextRef)context withOffset:(CGFloat)offset {
    // Recalculate bounds based on offset
    CGFloat maxX = self.bounds.size.width - (2 * offset);
    CGFloat maxY = self.bounds.size.height - (2 * offset);
    // Translate to set 0,0 to offset
    CGContextTranslateCTM(context, offset, offset);
    
    // Draw an oval
    UIBezierPath *bPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, maxX, maxY)];
    
    [[UIColor brownColor] setStroke];
    [[UIColor colorWithRed:0.5 green:0.7 blue:0.5 alpha:0.5] setFill];
    bPath.lineWidth = 2;
    [bPath fill];
    [bPath stroke];
}


@end
