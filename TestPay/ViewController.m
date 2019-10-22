//
//  ViewController.m
//  TestPay
//
//  Created by Apple on 2019/10/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "ViewController.h"
#import "PayCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 150, 35)];
    [btn1 setTitle:@"内购商品1" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(pay1_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 120, 150, 35)];
    [btn2 setTitle:@"内购商品2" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor redColor]];
    [btn2 addTarget:self action:@selector(pay2_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)pay1_Click:(id)sender{
    
    [[PayCenter sharedInstance] payItem:IAP1_ProductID];
}

- (void)pay2_Click:(id)sender{
    
    [[PayCenter sharedInstance] payItem:IAP2_ProductID];
}


@end
