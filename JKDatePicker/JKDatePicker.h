//
//  JKDatePicker.h
//  JKDatePicker
//
//  Created by jackyjiao on 3/7/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKDatePicker : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSDate  *maximumDate;//限制最大时间（没有设置默认2049）
@property (nonatomic, strong) NSDate  *minimumDate;//限制最小时间（没有设置默认1900）
@property (nonatomic, strong) UIColor *darkTextColor;//日期不可选时的文本颜色
@property (nonatomic, strong) UIColor *normalTextColor;//日期可选时的文本颜色
@property (nonatomic, strong) NSDate  *date;//选择器的时间

@end
