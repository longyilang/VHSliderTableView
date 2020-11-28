//
//  SliderHeadView.h
//  VHSliderTableView
//
//  Created by 龙一郎 on 2020/11/28.
//

#import <UIKit/UIKit.h>

typedef void (^ActionForHandleBlock)(NSString *date);


NS_ASSUME_NONNULL_BEGIN

@interface SliderHeadView : UIView

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, copy) ActionForHandleBlock action_handle;

@end

NS_ASSUME_NONNULL_END
