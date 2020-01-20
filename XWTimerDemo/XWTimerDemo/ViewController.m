//
//  ViewController.m
//  XWTimerDemo
//
//  Created by 邱学伟 on 2020/1/19.
//  Copyright © 2020 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWTimer.h"

@interface ViewController ()
{
    __weak IBOutlet UILabel *_numberLB;
    BOOL _isTarget;
    NSInteger _number;
    NSInteger _number2;
}

@property (nonatomic, strong) XWTimer *timerMain;
@property (nonatomic, strong) XWTimer *timerGlobal;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self creatTimerOnMainQueue];
    [self creatTimerOnGlobalQueue];
}

/// Main Queue Timer
- (void)creatTimerOnMainQueue
{
    if (_isTarget) {
        self.timerMain = [XWTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethodMain) repeats:YES];
    } else {
        __weak typeof(self) weakSelf = self;
        self.timerMain = [XWTimer timerWithTimeInterval:1.0 repeats:YES block:^(XWTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf timerMethodMain];
        }];
    }
}

/// Global Queue Timer
- (void)creatTimerOnGlobalQueue
{
    if (_isTarget) {
        self.timerGlobal = [XWTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethodGlobal) repeats:YES queue:dispatch_get_global_queue(0, 0)];
            
    } else {
        __weak typeof(self) weakSelf = self;
        self.timerGlobal = [XWTimer timerWithTimeInterval:1.0 repeats:YES queue:dispatch_get_global_queue(0, 0) block:^(XWTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf timerMethodGlobal];
        }];
    }
}

- (IBAction)fireClick:(id)sender
{
    [self.timerMain fire];
    [self.timerGlobal fire];
}

- (IBAction)pauseClick:(id)sender
{
    [self.timerMain pause];
    [self.timerGlobal pause];
}

- (IBAction)invalidateClick:(id)sender
{
    [self.timerMain invalidate];
    [self.timerGlobal invalidate];
}

- (IBAction)switchClick:(UISwitch *)sender
{
    _isTarget = sender.isOn;
//    [self creatTimerOnMainQueue];
    [self creatTimerOnGlobalQueue];
}

- (void)timerMethodMain
{
    _number += 1;
    NSString *string = [NSString stringWithFormat:@"%ld",(long)_number];
    _numberLB.text = string;
    NSLog(@"number: %@, thread: %@",string, [NSThread currentThread]);
}

- (void)timerMethodGlobal
{
    _number2 += 1;
    NSString *string = [NSString stringWithFormat:@"%zd",_number2];
    NSLog(@"number: %@, thread: %@",string, [NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_numberLB.text = string;
    });
}

@end
