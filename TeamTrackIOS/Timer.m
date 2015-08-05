//
//  Timer.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/4/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "Timer.h"

@implementation Timer

- (id) init {
    self = [super init];
    if (self != nil) {
        running = false;
    }
    return self;
}


#pragma mark - Timing Methods

- (void)startTimer
{
    if(!running)
    {
        running = true;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        [self updateTime];
    }
    else
    {
        running = false;
    }
}

- (void)stopTimer
{
    running = false;
}

- (void)updateTime
{
    if(!running) return;
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    
    int mins = (int) (elapsed / 60.0);
    elapsed -= mins * 60;
    int secs = (int) (elapsed);
    elapsed -= secs;
    int fraction = elapsed * 10.0;
    
    self.timeStr = [NSString stringWithFormat:@"%u:%02u.%u",mins,secs,fraction];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
    
    // Send notice to parent to reload table
    [self updateTimeLabel];
}


#pragma mark - Helpers

// Returns the time string so the label can be updated in the parent class
- (NSString *)getCurrentTime
{
    return self.timeStr;
}

// Tells the parent to call the getCurrentTime() function of the child
- (void)updateTimeLabel
{
    id<TimerDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(timer:didUpdate:)]) {
        [strongDelegate timer:self didUpdate:@"test"];
    }
}

@end



