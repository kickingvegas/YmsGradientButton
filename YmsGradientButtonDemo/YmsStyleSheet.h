//
//  YmsStyleSheet.h
//  onmytab
//
//  Created by Charles Y. Choi on 1/9/12.
//  Copyright (c) 2012 Yummy Melon Software LLC. All rights reserved.
//

#ifndef onmytab_YmsStyleSheet_h
#define onmytab_YmsStyleSheet_h


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green: g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green: g/255.0 blue:b/255.0 alpha:a]
#define RGBCSS(rgb) RGB((double)(rgb >> 16 & 0xff), (double)(rgb >> 8 & 0xff), (double)(rgb & 0xff))


#endif
