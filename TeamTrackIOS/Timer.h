//
//  Timer.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/4/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

// Declare delegate
@protocol TimerDelegate;


@interface Timer : NSObject
{
    BOOL running;
    NSTimeInterval startTime;
}

- (void)startTimer;
- (void)stopTimer;
- (NSString *)getCurrentTime;

@property (nonatomic, retain) NSString *nameStr;
@property (nonatomic, retain) NSString *timeStr;
@property (nonatomic, weak) id<TimerDelegate> delegate;

@end

// Delegate definition
@protocol TimerDelegate <NSObject>

- (void)timer:(Timer *)timer didUpdate:(NSString *)value;

@end
