//
//  JKDatePicker.m
//  JKDatePicker
//
//  Created by jackyjiao on 3/7/17.
//  Copyright © 2017 jackyjiao. All rights reserved.
//

#import "JKDatePicker.h"
#import "NSDate+Tencent.h"

#define DATEPICKER_MINDATE 1900
#define DATEPICKER_MAXDATE 2049

#define JKUIColorFromHex(hexValue)         [UIColor colorWithRed : ((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue : (float)((hexValue & 0xFF)) / 255.0 alpha : 1.0f]

#define DATE_DARK_COLOR    JKUIColorFromHex(0x888888)
#define DATE_NORMAL_COLOR  JKUIColorFromHex(0xffffff)

#define DATE_PICK_REPEAT   9
#define DATE_PICK_SHOW     5

@interface JKDatePicker ()

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger    yearIndex;
@property (nonatomic, assign) NSInteger    monthIndex;
@property (nonatomic, assign) NSInteger    dayIndex;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;

@end


@implementation JKDatePicker

- (void)dealloc {
    NSLog(@"========DMDatePicker dealloc");
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"========DMDatePicker init");
    }
    return self;
}

//初始化 call when view display after addSubview
- (void)drawRect:(CGRect)rect {
    [self reloadDataAndView];
}

#pragma mark - 参数配置
- (NSDate *)minimumDate {
    if (!_minimumDate) {
        NSCalendar       *gregorian  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:DATEPICKER_MINDATE];
        [components setMonth:1];
        [components setDay:1];
        NSDate *minDate = [gregorian dateFromComponents:components];
        _minimumDate = minDate;
    }
    return _minimumDate;
}

- (NSDate *)maximumDate {
    if (!_maximumDate) {
        _maximumDate = [NSDate date];
    }
    return _maximumDate;
}

- (NSDate *)date {
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (UIColor *)darkTextColor {
    if (!_darkTextColor) {
        _darkTextColor = DATE_DARK_COLOR;
    }
    return _darkTextColor;
}

- (UIColor *)normalTextColor {
    if (!_normalTextColor) {
        _normalTextColor = DATE_NORMAL_COLOR;
    }
    return _normalTextColor;
}

#pragma mark - 初始化以及刷新界面
- (void)reloadDataAndView {
    //  初始化数组
    _yearArray  = [self ishave:_yearArray];
    _monthArray = [self ishave:_monthArray];
    _dayArray   = [self ishave:_dayArray];
    
    //  进行数组的赋值
    for (int j = 0; j < DATE_PICK_REPEAT; j++) {
        for (int i = 0; i < 12; i++) {
            [_monthArray addObject:[NSString stringWithFormat:NSLocalizedString(@"DMDatePicker.%02d月", nil), i+1]];
        }
    }
    for (int i = DATEPICKER_MINDATE; i <= DATEPICKER_MAXDATE; i++) {
        [_yearArray addObject:[NSString stringWithFormat:NSLocalizedString(@"DMDatePicker.%d年", nil), i]];
    }
    
    if (_pickerView) {
        [_pickerView removeFromSuperview];
        self.pickerView = nil;
    }
    NSArray *indexArray = [self getIndexsFromDate:self.date];
    [self addSubview:self.pickerView];
    
    //设置当前日期
    for (int i = 0; i < indexArray.count; i++) {
        [self.pickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:NO];
    }
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView                         = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor         = [UIColor clearColor];
        _pickerView.delegate                = self;
        _pickerView.dataSource              = self;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) return (DATEPICKER_MAXDATE - DATEPICKER_MINDATE + 1);
    if (component == 1) return 12*DATE_PICK_REPEAT;
    if (component == 2) return [self daysForYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]]*DATE_PICK_REPEAT;
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) return 100*self.frame.size.width/320;
    if (component == 1) return 60*self.frame.size.width/320;
    if (component == 2) return 60*self.frame.size.width/320;
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)recycledLabel {
    UILabel *customLabel = recycledLabel;
    
    if (!customLabel) {
        customLabel               = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:22]];
    }
    UIColor *textColor = [UIColor blackColor];
    
    NSString *title;
    if (component == 0) {
        title     = _yearArray[row];
        textColor = [self returnYearColorRow:row];
    }
    if (component == 1) {
        title     = _monthArray[row];
        textColor = [self returnMonthColorRow:row];
    }
    if (component == 2) {
        title     = _dayArray[row];
        textColor = [self returnDayColorRow:row];
    }
    
    customLabel.text      = title;
    customLabel.textColor = textColor;
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger totalDay = _dayArray.count/DATE_PICK_REPEAT;
    if (component == 0) {
        _yearIndex = row;
    }
    if (component == 1) {
        _monthIndex = row;
        if (_monthIndex >= 12*DATE_PICK_SHOW || _monthIndex < 12*(DATE_PICK_SHOW-1)) {
            _monthIndex = (_monthIndex%12) + 12*(DATE_PICK_SHOW-1);
            [self.pickerView selectRow:_monthIndex inComponent:component animated:NO];
        }
    }
    if (component == 2) {
        _dayIndex = row;
        if (_dayIndex >= totalDay*DATE_PICK_SHOW || _dayIndex < totalDay*(DATE_PICK_SHOW-1)) {
            _dayIndex = (_dayIndex%totalDay) + totalDay*(DATE_PICK_SHOW-1);
            [self.pickerView selectRow:_dayIndex inComponent:component animated:NO];
        }
    }
    
    if (component == 0 || component == 1) {
        [self daysForYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
        NSInteger realDay = _dayIndex - totalDay*(DATE_PICK_SHOW-1);
        totalDay = _dayArray.count/DATE_PICK_REPEAT;
        if (totalDay - 1 < realDay) {
            realDay = totalDay - 1;
        }
        _dayIndex = realDay + totalDay*(DATE_PICK_SHOW-1);
        [self.pickerView selectRow:_dayIndex inComponent:2 animated:NO];
    }
    
    NSCalendar       *gregorian  = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:DATEPICKER_MINDATE + _yearIndex];
    [components setMonth:1 + _monthIndex - 12*(DATE_PICK_SHOW-1)];
    [components setDay:1 + _dayIndex - totalDay*(DATE_PICK_SHOW-1)];
    self.date = [gregorian dateFromComponents:components];
    if ([self.date compare:self.minimumDate] == NSOrderedAscending) {
        //超出最小时间范围，调整到最小时间
        NSArray *indexArray = [self getIndexsFromDate:self.minimumDate];
        for (int i = 0; i < indexArray.count; i++) {
            [self.pickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:YES];
        }
        self.date = self.minimumDate;
    } else if ([self.date compare:self.maximumDate] == NSOrderedDescending) {
        //超出最大时间范围，调整到最大时间
        NSArray *indexArray = [self getIndexsFromDate:self.maximumDate];
        for (int i = 0; i < indexArray.count; i++) {
            [self.pickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:YES];
        }
        self.date = self.maximumDate;
    }
    
    [pickerView reloadAllComponents];
}

#pragma mark - 计算每月各有多少天
- (NSInteger)daysForYear:(NSInteger)year andMonth:(NSInteger)month {
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4 == 0 ? (num_year%100 == 0 ? (num_year%400 == 0 ? YES : NO) : YES) : NO;
    
    switch (num_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12: {
            [self setdayArray:31];
            return 31;
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11: {
            [self setdayArray:30];
            return 30;
        }
            break;
        case 2: {
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            } else {
                [self setdayArray:28];
                return 28;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (void)setdayArray:(NSInteger)num {
    [_dayArray removeAllObjects];
    for (int j = 0; j < DATE_PICK_REPEAT; j++) {
        for (int i = 1; i <= num; i++) {
            [_dayArray addObject:[NSString stringWithFormat:NSLocalizedString(@"DMDatePicker.%02d日", nil), i]];
        }
    }
}

- (NSMutableArray *)ishave:(id)mutableArray {
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

//解析时间获取位置
- (NSArray *)getIndexsFromDate:(NSDate *)date {
    NSDate *dateShow;
    
    if (date) {
        dateShow = date;
    } else {
        dateShow = [NSDate date];
    }
    
    [self daysForYear:dateShow.tc_year andMonth:dateShow.tc_month];
    _yearIndex  = dateShow.tc_year - DATEPICKER_MINDATE;
    _monthIndex = dateShow.tc_month - 1 + 12*(DATE_PICK_SHOW-1);
    _dayIndex   = dateShow.tc_day - 1 + _dayArray.count/DATE_PICK_REPEAT*(DATE_PICK_SHOW-1);
    
    NSNumber *year  = [NSNumber numberWithInteger:_yearIndex];
    NSNumber *month = [NSNumber numberWithInteger:_monthIndex];
    NSNumber *day   = [NSNumber numberWithInteger:_dayIndex];
    
    return @[year, month, day];
}

#pragma mark - 返回颜色的数字
- (UIColor *)returnYearColorRow:(NSInteger)row {
    if ([_yearArray[row] intValue] < _minimumDate.tc_year || [_yearArray[row] intValue] > _maximumDate.tc_year) {
        return self.darkTextColor;
    } else {
        return self.normalTextColor;
    }
}

- (UIColor *)returnMonthColorRow:(NSInteger)row {
    if ([_yearArray[_yearIndex] intValue] < _minimumDate.tc_year || [_yearArray[_yearIndex] intValue] > _maximumDate.tc_year) {
        return self.darkTextColor;
    }
    if ([_yearArray[_yearIndex] intValue] > _minimumDate.tc_year && [_yearArray[_yearIndex] intValue] < _maximumDate.tc_year) {
        return self.normalTextColor;
    }
    if ([_yearArray[_yearIndex] intValue] == _maximumDate.tc_year) {
        if ([_monthArray[row] intValue] <= _maximumDate.tc_month) {
            return self.normalTextColor;
        } else {
            return self.darkTextColor;
        }
    }
    if ([_yearArray[_yearIndex] intValue] == _minimumDate.tc_year) {
        if ([_monthArray[row] intValue] >= _minimumDate.tc_month) {
            return self.normalTextColor;
        } else {
            return self.darkTextColor;
        }
    }
    return self.normalTextColor;
}

- (UIColor *)returnDayColorRow:(NSInteger)row {
    if ([_yearArray[_yearIndex] intValue] == _minimumDate.tc_year && [_monthArray[_monthIndex] intValue] == _minimumDate.tc_month) {
        if ([_dayArray[row] intValue] >= _minimumDate.tc_day) {
            return self.normalTextColor;
        } else {
            return self.darkTextColor;
        }
    }
    if ([_yearArray[_yearIndex] intValue] == _maximumDate.tc_year && [_monthArray[_monthIndex] intValue] == _maximumDate.tc_month) {
        if ([_dayArray[row] intValue] <= _maximumDate.tc_day) {
            return self.normalTextColor;
        } else {
            return self.darkTextColor;
        }
    }
    return self.normalTextColor;
}

@end

