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

#ifndef onmytab_YmsStyleSheet_h
#define onmytab_YmsStyleSheet_h


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green: g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green: g/255.0 blue:b/255.0 alpha:a/255.0]
#define RGBCSS(rgb) RGB((double)(rgb >> 16 & 0xff), (double)(rgb >> 8 & 0xff), (double)(rgb & 0xff))
#define ARGBCSS(argb) RGBA((double)(argb >> 16 & 0xff), (double)(argb >> 8 & 0xff), (double)(argb & 0xff), (double)(argb >> 24 & 0xff))

#endif
