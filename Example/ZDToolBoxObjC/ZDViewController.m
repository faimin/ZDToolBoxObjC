//
//  ZDViewController.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 06/04/2023.
//  Copyright (c) 2023 Zero.D.Saber. All rights reserved.
//

#import "ZDViewController.h"
#import <ZDToolBoxObjC/ZDOSLogger.h>

@interface ZDViewController ()

@end

@implementation ZDViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
    
    ZDOSLog(OS_LOG_TYPE_DEBUG, "message： %{public}@", @[@"1", @"2"]);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
