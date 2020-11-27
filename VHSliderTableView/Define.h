//
//  Define.h
//  VHSliderTableView
//
//  Created by 龙一郎 on 2020/11/26.
//

#ifndef Define_h
#define Define_h

#ifndef __COLOR__
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

#endif /* Define_h */
