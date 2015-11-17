//
//  SelectTypeView.m
//  LogisticBsusines
//
//  Created by hangzhang on 15/1/6.
//  Copyright (c) 2015 物流商户端. All rights reserved.
//


#import "SelectTypeView.h"



#define SELECT_PICKER_VIEW_DEFAULT_HEIGHT 216

@interface SelectTypeView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) UIButton *submitButton;

///提示的字符
@property (nonatomic, strong) UILabel *prompTitlelabel;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *titleIndexs;

@end

@implementation SelectTypeView {


    UIView *selectView;

    NSString *currentSelectString;

    NSArray *adressTypeWidths;

    BOOL _isTimeType;

    NSMutableArray *_sectionArray;

    NSMutableArray *_rowsArray;
    int _timeDay;
}

- (UIButton *)dismissButton {
    
    if (_dismissButton == nil) {
        
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.frame = CGRectMake(10, 5, 80, 40);
        [_dismissButton setTitle:@"取消" forState:UIControlStateNormal];
        _dismissButton.backgroundColor=[UIColor grayColor];
        _dismissButton.layer.masksToBounds=YES;
        _dismissButton.layer.cornerRadius=5;
        _dismissButton.tag = 0;
        [_dismissButton addTarget:self action:@selector(dismissButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(CGRectGetWidth(selectView.frame) - 90, 5, 80, 40);
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        _submitButton.backgroundColor=[UIColor grayColor];
        _submitButton.layer.masksToBounds=YES;
        _submitButton.layer.cornerRadius=5;
        _submitButton.tag = 1;
        [_submitButton addTarget:self action:@selector(dismissButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


- (UILabel *)prompTitlelabel
{
    if (!_prompTitlelabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.frame=CGRectMake(90, 5, CGRectGetWidth(self.frame)-180, 30);
        label.textColor=[UIColor grayColor];
        label.textAlignment=NSTextAlignmentCenter;
        
        _prompTitlelabel = label;
    }
    return _prompTitlelabel;
}
-(void)setPromptTitle:(NSString *)promptTitle{

    _promptTitle=promptTitle;
    
    self.prompTitlelabel.text=promptTitle;
}
- (void)setMaxSalaryNumber:(NSUInteger)maxSalaryNumber {

    maxSalaryNumber = 50;
    
    _maxSalaryNumber=maxSalaryNumber;
    
    NSString *title=@"面议";
    
    NSMutableArray *array=[NSMutableArray array];
    
    [array addObject:[SelectTypeView dictionaryWithTitle:title array:@[]]];
    
    NSUInteger minValue=1;
    
    for (NSUInteger i=1; i <= self.maxSalaryNumber; i++) {
        
        minValue = i+1;
        title=[NSString stringWithFormat:@"%ldk",(unsigned long)i];
        NSMutableArray *array1=[NSMutableArray array];
        
        for (NSUInteger j=minValue; j <= self.maxSalaryNumber * 2; j++) {
            [array1 addObject:[SelectTypeView dictionaryWithTitle:
                               [NSString stringWithFormat:@"%ldk",(unsigned long)j]
                                                            array:@[]]];
        }
        [array addObject:[SelectTypeView dictionaryWithTitle:title array:array1]];
    }
    self.dataDictionary=@{
                          DATA_MODEL_SECTIONS_KEY:@(2),
                          DATA_MODEL_ARRAY_KEY:array
                          
                          };
}

- (void)setIsSelectTimePassage:(BOOL)isSelectTimePassage {

    _isSelectTimePassage = isSelectTimePassage;
    
    if (isSelectTimePassage) {
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *year = [dateFormatter stringFromDate:nowDate];
        
        NSUInteger yearNumber = [year integerValue];
        
        NSMutableArray *array=[NSMutableArray array];
        
        NSString *title;
        
        for (NSUInteger i = yearNumber; i >= yearNumber - 100; i --) {
            
            title=[NSString stringWithFormat:@"%ld",(unsigned long)i];
            NSMutableArray *array1=[NSMutableArray array];
            
            for (NSUInteger j = yearNumber + 1; j >= i; j--) {
                if (j > yearNumber) {
                    title = @"至今";
                }else{
                    title = [NSString stringWithFormat:@"%ld",(unsigned long)j];
                }
                [array1 addObject:[SelectTypeView dictionaryWithTitle:title
                                   
                                                                array:@[]]];
            }
            [array addObject:[SelectTypeView dictionaryWithTitle:title array:array1]];
        }
        self.dataDictionary=@{
                              DATA_MODEL_SECTIONS_KEY:@(2),
                              DATA_MODEL_ARRAY_KEY:array
                              
                              };
        
    }

}

- (void)initParment {

    _sectionArray = [NSMutableArray array];

    _rowsArray = [NSMutableArray array];
}

- (instancetype)init {

    self = [super init];
    if (self) {
        
        [self initParment];

        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.41];

        self.frame = [UIApplication sharedApplication].keyWindow.bounds;


        selectView = [[UIView alloc] init];
        selectView.frame = CGRectMake(0,
                        CGRectGetHeight(self.frame) - SELECT_PICKER_VIEW_DEFAULT_HEIGHT - 42,
                            CGRectGetWidth(self.frame),SELECT_PICKER_VIEW_DEFAULT_HEIGHT + 42);

        selectView.backgroundColor = [UIColor colorWithRed:0.976f
                                                     green:0.976f
                                                      blue:0.976f
                                                     alpha:1.00f];

        [selectView addSubview:self.dismissButton];
        [selectView addSubview:self.prompTitlelabel];
        [selectView addSubview:self.submitButton];

        [selectView addSubview:self.pickerView];

        [self addSubview:selectView];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(hide)];

        [self addGestureRecognizer:tapGestureRecognizer];
        self.titleIndexs = [NSMutableArray array];


    }
    return self;
}

- (void)show:(UIView *)view {


    selectView.frame = CGRectMake(0, CGRectGetHeight(view.frame),CGRectGetWidth(view.frame), CGRectGetHeight(selectView.frame));
    [view addSubview:self];
    [UIView animateWithDuration:.3 animations:^{

        self->selectView.frame = CGRectMake(0,
                                CGRectGetHeight(view.frame)- CGRectGetHeight(self->selectView.frame),
                                CGRectGetHeight(view.frame), CGRectGetHeight(self->selectView.frame));


    }completion:^(BOOL complete) {
    

    }];


}

- (void)autoScroolViewToCurrentTime {

}


- (void)hide {

    [UIView animateWithDuration:0.3 animations:^{
        self->selectView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), SELECT_PICKER_VIEW_DEFAULT_HEIGHT);


    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];


}



- (void)dismissButtonClick:(UIButton *)button {



    [self hide];

    if (button.tag == 0) {
        return;
    }
    [self.titleIndexs removeAllObjects];
    NSMutableArray *stringArray=[NSMutableArray array];
    for (int i = 0; i < _sectionArray.count; ++i) {

        NSUInteger row = [self.pickerView selectedRowInComponent:i];
        [self.titleIndexs  addObject:@(row)];
        NSString *string=[self stringFromPickerView:self.pickerView titleForRow:row forComponent:i];

        if (string) {
            [stringArray addObject:string];

        }
    }
    
    if (self.delegate && [self.delegate
                          respondsToSelector:@selector(selectTypeViewDidSelectTitleArray:selectView:)]) {
        [self.delegate selectTypeViewDidSelectTitleArray:stringArray selectView:self];
    }

    

}


- (UIPickerView *)pickerView {

    if (_pickerView == nil) {

        _pickerView = [[UIPickerView alloc] init];

        _pickerView.frame = CGRectMake(0, 42, CGRectGetWidth(self.frame),
                                       SELECT_PICKER_VIEW_DEFAULT_HEIGHT);

        _pickerView.dataSource = self;

        _pickerView.delegate = self;

        _pickerView.showsSelectionIndicator = YES;

    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    int sections = [self.dataDictionary[DATA_MODEL_SECTIONS_KEY] intValue];


    return sections;


}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (_rowsArray.count > component) {

        NSArray *array = _rowsArray[component];

        return array.count;
    }

    return 0;


}


// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    int sections = [self.dataDictionary[DATA_MODEL_SECTIONS_KEY] intValue];

    if (adressTypeWidths.count == 3) {


        return [adressTypeWidths[component] floatValue];

    }


    return (CGFloat) (CGRectGetWidth(pickerView.frame) / sections);

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 44;

}


- (NSString *)stringFromPickerView:(UIPickerView *)pickerView
                       titleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {


    NSArray *array = _rowsArray[component];

    if (array.count > row) {

        NSDictionary *dictionary = array[row];

        return dictionary[DATA_MODEL_TITLE_KEY];

    } else {

        return nil;
    }


}

- (void)setDataDictionary:(NSDictionary *)dataDictionary {

    [_sectionArray removeAllObjects];
    [_rowsArray removeAllObjects];
    _dataDictionary = dataDictionary;

    int sections = [dataDictionary[DATA_MODEL_SECTIONS_KEY] intValue];
    for (int j = 0; j < sections; ++j) {

        [_sectionArray addObject:@(0)];

        [_rowsArray addObject:[self arrayWithIndex:j]];


    }


    NSString *string = @"";

    for (int i = 0; i < sections; ++i) {

        NSUInteger selectRow = [self.pickerView selectedRowInComponent:i];

        string = [NSString stringWithFormat:@"%@%@", string,
                [self stringFromPickerView:self.pickerView titleForRow:selectRow forComponent:i]];

    }

    currentSelectString = string;

    [self.pickerView reloadAllComponents];


}

- (NSArray *)arrayWithIndex:(NSInteger)index {


    NSArray *array = nil;

    if (_rowsArray.count > index - 1 && index - 1 >= 0) {

        NSArray *array1 = _rowsArray[index - 1];

        NSUInteger rowIndex = [_sectionArray[index - 1] integerValue];

        NSDictionary *dictionary = array1[rowIndex];

        array = dictionary[DATA_MODEL_ARRAY_KEY];


    } else {

        array = self.dataDictionary[DATA_MODEL_ARRAY_KEY];
    }

    NSParameterAssert(array);

    return array;


}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {


    if (_isTimeType) {
        NSIndexPath *indexPath =nil;
        if (indexPath.section >= component) {
            if (indexPath.row > row) {

                if (component==0){

                    [pickerView selectRow:indexPath.row inComponent:indexPath.section animated:YES];

                     _sectionArray[indexPath.section] = @(indexPath.row);
                }




                return;

            }
        }
    }

    _sectionArray[(NSUInteger) component] = @(row);


    //不是滚动的最后一条


    for (int l = 0; l < _sectionArray.count; ++l) {

        if (l > component) {

            if (component == 0 && _isTimeType) {

            
            } else {

                _sectionArray[l] = @(0);
            }


        }

    }


    for (int j = 0; j < _sectionArray.count; ++j) {
        _rowsArray[j] = [self arrayWithIndex:j];
    }


    [pickerView reloadAllComponents];


    for (int k = 0; k < _sectionArray.count; ++k) {

        int row = [_sectionArray[k] intValue];

        [pickerView selectRow:row inComponent:k animated:YES];
    }


    int sections = [self.dataDictionary[DATA_MODEL_SECTIONS_KEY] intValue];


    NSString *string = @"";

    for (int i = 0; i < sections; ++i) {

        NSUInteger selectRow = [pickerView selectedRowInComponent:i];

        string = [NSString stringWithFormat:@"%@%@", string,
                [self stringFromPickerView:pickerView titleForRow:selectRow forComponent:i]];

    }

    currentSelectString = string;


}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view; {


    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];


    float labelWidth = [adressTypeWidths[(NSUInteger) component] floatValue];

    float labelY = 2;

    for (int i = 0; i < component; ++i) {

        labelY = labelY + [adressTypeWidths[(NSUInteger) i] floatValue] + 2 * i;

    }


    label.frame = CGRectMake(labelY, 0, labelWidth, 44);

    label.font = [UIFont systemFontOfSize:13];

    label.numberOfLines = 2;

    label.lineBreakMode = NSLineBreakByTruncatingTail;

    label.textAlignment = NSTextAlignmentCenter;

    label.textColor = [UIColor redColor];

    label.text = [self stringFromPickerView:pickerView titleForRow:row forComponent:component];
    
    //label.text=@"3212131";

    label.backgroundColor = [UIColor clearColor];

    return label;


}



/**
 *  @author ZhangHang, 15-11-04 16:11:43
 *
 *  合成选择器数据源
 *
 *  @param title 标题
 *  @param array 标题下面的数组 可以为空数组
 *
 *  @return 数据源
 */
+ (NSDictionary *)dictionaryWithTitle:(NSString *)title array:(NSArray *)array{
    
    return @{
             DATA_MODEL_TITLE_KEY:title,
             DATA_MODEL_ARRAY_KEY:array
             };
}
@end
