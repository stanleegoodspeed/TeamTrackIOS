//
//  Timer.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/4/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject
{
    NSDate *start;
    NSDate *end;
    
    BOOL running;
    NSTimeInterval startTime;

}

- (void)startTimer;
- (void)stopTimer;
//- (double) timeElapsedInSeconds;
//- (double) timeElapsedInMilliseconds;
//- (double) timeElapsedInMinutes;


- (NSString *)getCurrentTime;

@property (nonatomic, retain) NSString *nameStr;
@property (nonatomic, retain) NSString *timeStr;

@end
