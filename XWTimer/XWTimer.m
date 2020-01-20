//
//  XWTimer.m
//  XWTimerDemo
//
//  Created by 邱学伟 on 2020/1/19.
//  Copyright © 2020 邱学伟. All rights reserved.
//

#import "XWTimer.h"
@interface XWTimer ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t timerSerialQueue;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, assign) BOOL isRepeats;
@property (nonatomic, assign) BOOL isTarget;
@property (nonatomic, weak)   id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy)   void(^block)(XWTimer *timer);
@property (nonatomic, assign) BOOL isFired;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, assign) BOOL isInvalidated;
@end

@implementation XWTimer

#pragma mark - Public
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)isRepeats block:(nonnull void(^)(XWTimer *timer))block
{
    return [XWTimer timerWithTimeInterval:timeInterval repeats:isRepeats queue:dispatch_get_main_queue() block:block];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)isRepeats queue:(dispatch_queue_t)queue block:(nonnull void(^)(XWTimer *timer))block
{
    NSParameterAssert(block);
    NSParameterAssert(queue);
    XWTimer *timer = [[XWTimer alloc] initWithTimerInterval:timeInterval repeats:isRepeats queue:queue];
    timer.block = block;
    timer.isTarget = NO;
    return timer;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector repeats:(BOOL)isRepeats
{
    return [XWTimer timerWithTimeInterval:timeInterval target:target selector:selector repeats:isRepeats queue:dispatch_get_main_queue()];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector repeats:(BOOL)isRepeats queue:(dispatch_queue_t)queue
{
    NSParameterAssert(target);
    NSParameterAssert(selector);
    NSParameterAssert(queue);
    XWTimer *timer = [[XWTimer alloc] initWithTimerInterval:timeInterval repeats:isRepeats queue:queue];
    timer.target = target;
    timer.selector = selector;
    timer.isTarget = YES;
    return timer;
}

#pragma mark - Private
- (instancetype)initWithTimerInterval:(NSTimeInterval)timeInterval repeats:(BOOL)isRepeats queue:(dispatch_queue_t)queue
{
    if (self = [super init]) {
        self.timeInterval = timeInterval;
        self.isRepeats = isRepeats;
        self.lock = dispatch_semaphore_create(1);
        NSString *timerSerialQueueName = [NSString stringWithFormat:@"com.qiuxuewei.xwtimer.%p",self];
        self.timerSerialQueue = dispatch_queue_create([timerSerialQueueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(self.timerSerialQueue, queue);
        [self createTimer];
    }
    return self;
}

- (void)createTimer
{
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.timerSerialQueue);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf timerMethod];
    });
    dispatch_source_t timer = self.timer;
    dispatch_async(self.timerSerialQueue, ^{
        dispatch_resume(timer);
    });
}

- (void)discardTimer
{
    dispatch_source_t timer = self.timer;
    dispatch_async(self.timerSerialQueue, ^{
        dispatch_source_cancel(timer);
    });
}

- (void)fire
{
    if (self.isInvalidated == YES || self.isFired == YES) return;
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    self.isPaused = NO;
    self.isFired = YES;
    [self createTimer];
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_semaphore_signal(self.lock);
}

- (void)pause
{
    if (self.isInvalidated == YES || self.isPaused == YES || self.isFired == NO) return;
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    self.isPaused = YES;
    self.isFired = NO;
    [self discardTimer];
    dispatch_semaphore_signal(self.lock);
}

- (void)invalidate
{
    if (self.isInvalidated == YES) return;
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    self.isInvalidated = YES;
    self.isFired = NO;
    [self discardTimer];
    dispatch_semaphore_signal(self.lock);
}

- (void)timerMethod
{
    if (self.isInvalidated == YES || self.isPaused == YES) return;
    if (self.isTarget) {
        id target = self.target;
        if (target) {
            SEL selector = self.selector;
            IMP imp = [target methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(target, selector);
        } else {
            [self invalidate];
        }
    } else {
        if (self.block) {
            self.block(self);
        } else {
            [self invalidate];
        }
    }
    if (self.isRepeats == NO) {
        [self invalidate];
    }
}

- (void)dealloc
{
    NSLog(@"🌹 %@ %s", self.description, __func__);
}
@end
