//
//  Timer.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/4/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Split.h"

// Declare delegate
@protocol TimerDelegate;


@interface Timer : NSObject
{
    BOOL running;
    NSTimeInterval startTime;
    NSTimeInterval masterStartTime;
    NSInteger splitCounter;
}

- (void)startTimer;
- (void)stopTimer;
- (void)triggerSplit:(BOOL)flag;
- (NSString *)getCurrentTime;

@property (nonatomic, retain) NSString *nameStr;
@property (nonatomic, retain) NSString *timeStr;
@property (nonatomic, weak) id<TimerDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

@end

// Delegate definition
@protocol TimerDelegate <NSObject>

- (void)timerDidUpdate:(Timer *)timer;
- (void)saveSplit:(Timer *)timer withObject:(Split *)split;
- (void)saveFinishTime:(Timer *)timer withFinishTime:(NSTimeInterval)finishTime;


@end
