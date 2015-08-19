//
//  Timer.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/4/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "Timer.h"
#import "Split.h"

@implementation Timer

- (id) init {
    self = [super init];
    if (self != nil) {
        running = false;
        splitCounter = 0;
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
        masterStartTime = [NSDate timeIntervalSinceReferenceDate];
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

    // Save final split
    [self triggerSplit];
    
    // Finish time calc
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval finishTime = currentTime - masterStartTime;

    id<TimerDelegate> strongDelegate = self.delegate;
    
    // Save finish time
    if ([strongDelegate respondsToSelector:@selector(saveFinishTime:withFinishTime:)]) {
        [strongDelegate saveFinishTime:self withFinishTime:finishTime];
    }
}

- (void)triggerSplit
{
    splitCounter++;
    
    // Get the split and send to parent for storage/push
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = currentTime - startTime;
    NSNumber *tmpNumber = [[NSNumber alloc]initWithDouble:elapsed];
    NSNumber *tmpSplitNum = [[NSNumber alloc]initWithInteger:splitCounter];
    
    // Reset time label and start time
    startTime = [NSDate timeIntervalSinceReferenceDate];
    self.timeStr = [NSString stringWithFormat:@"%u:%02u.%u",0,0,0];
    
    // Create split object
    Split *mySplit = [[Split alloc]init];
    mySplit.splitNumber = tmpSplitNum;
    mySplit.splitTime = tmpNumber;
    
    id<TimerDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(saveSplit:withObject:)]) {
        [strongDelegate saveSplit:self withObject:mySplit];
    }
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
    return self.timeStr ? self.timeStr : @"0:00.0";
}

// Tells the parent to call the getCurrentTime() function of the child
- (void)updateTimeLabel
{
    id<TimerDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(timerDidUpdate:)]) {
        [strongDelegate timerDidUpdate:self];
    }
}

@end



