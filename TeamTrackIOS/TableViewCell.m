//
//  TableViewCell.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
@synthesize timeLabel;


- (void)awakeFromNib {
    // Initialization code
    running = false;
    timeLabel.text = @"0:00";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

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

- (IBAction)stopTimer:(id)sender
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
    
    timeLabel.text = [NSString stringWithFormat:@"%u:%02u.%u",mins,secs,fraction];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (void)pressedStartButton
{
    [self startTimer];
}



@end
