//
//  SelectTypeView.h
//  LogisticBsusines
//
//  Created by hangzhang on 15/1/6.
//  Copyright (c) 2015 物流商户端. All rights reserved.
//

/*
 这是用数据源控制的选择器 数据源为json对象
 example 1 json:
 
{
     "sections":1,
     "array":[
     
         {
         
         "title":"这是显示的标题",
         "array":[]
         
         
         }
     
     ]
 }
 
 
 example 2 json
 
 {
     "sections":2,
     "array":[
     
         {
         
         "title":"这是显示的标题",
         "array":
             [
                     {
                         "title":"这是显示的标题",
                         "array":
                         [
 
                         ]
 
                     }
             ]
 
 
         }
 
     ]
 }
 
 SelectTypeView *selectView = [SelectTypeView alloc]init];
 selectView.dataDictionary = NSDictionary;
 selectView.promptTitle = @"这是提示的字符";
 [promptTitle showInView:self.view]
 
 
 */


#import <UIKit/UIKit.h>

#define DATA_MODEL_TITLE_KEY @"title"

#define DATA_MODEL_ARRAY_KEY @"array"

#define DATA_MODEL_SECTIONS_KEY @"sections"

@protocol SelectTypeViewDelegate;

/**
* 选择类型
*/

@interface SelectTypeView : UIView {
    NSDictionary *adressDictionary;
}

-(instancetype)init;
///数据源
@property(nonatomic, strong) NSDictionary *dataDictionary;
///提示
@property (nonatomic, copy) NSString *promptTitle;
///最大支持的薪资(单位为k) 默认为0 如果设置这个值>0 dataDictionary 将在内部初始化 注意
@property (nonatomic, assign) NSUInteger maxSalaryNumber;

@property (nonatomic, weak) id<SelectTypeViewDelegate> delegate;
///是否是选择时间段 默认为 no  如果为yes dataDictionary 将在内部初始化 注意
@property (nonatomic, assign) BOOL isSelectTimePassage;
//选中标题所在的索引
@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *titleIndexs;


- (void)show:(UIView *)view;
- (void)hide;



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
+ (NSDictionary *)dictionaryWithTitle:(NSString *)title array:(NSArray *)array;

@end

@protocol SelectTypeViewDelegate <NSObject>
/**
 *  @author ZhangHang, 15-11-04 17:11:37
 *
 *  返回选择的文字 文字按照从左到右
 *
 *  @param array 文字组
 *  @param view 选择器对象
 */
- (void)selectTypeViewDidSelectTitleArray:(NSArray <NSString *> *)array
                               selectView:(SelectTypeView *)view;

@end
