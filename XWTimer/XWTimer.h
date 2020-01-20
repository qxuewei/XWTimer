//
//  XWTimer.h
//  XWTimerDemo
//
//  Created by 邱学伟 on 2020/1/19.
//  Copyright © 2020 邱学伟. All rights reserved.
//  GCD Timer

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWTimer : NSObject

/// Creates and returns a new Timer object initialized with the specified block object.  (main dispatch queue)
/// @param timeInterval The number of seconds between firings of the timer.
/// @param isRepeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// @param block The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)isRepeats block:(nonnull void(^)(XWTimer *timer))block;

/// Creates and returns a new Timer object initialized with the specified block object.  (custom dispatch queue)
/// @param timeInterval The number of seconds between firings of the timer.
/// @param isRepeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// @param queue custom dispatch queue
/// @param block The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)isRepeats queue:(dispatch_queue_t)queue block:(nonnull void(^)(XWTimer *timer))block;

/// Creates and returns a new Timer object initialized. (main dispatch queue)
/// @param timeInterval  The number of seconds between firings of the timer.
/// @param target target
/// @param selector selector
/// @param isRepeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector repeats:(BOOL)isRepeats;

/// Creates and returns a new Timer object initialized. (custom dispatch queue)
/// @param timeInterval  The number of seconds between firings of the timer.
/// @param target target
/// @param selector selector
/// @param isRepeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// @param queue custom dispatch queue
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector repeats:(BOOL)isRepeats queue:(dispatch_queue_t)queue;

/// Start Timer
- (void)fire;

/// Pause Timer
- (void)pause;

/// Invalidate Timer
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
