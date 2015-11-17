//
//  ViewController.m
//  ZHSelectView
//
//  Created by 张行 on 15/11/17.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ViewController.h"
#import "SelectTypeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {

   SelectTypeView  *typeView = [[SelectTypeView alloc] init];

    typeView.dataDictionary=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demoSelectType" ofType:@"plist"]];
    [typeView show:self.view];
}

@end
