//
//  TimerViewCell.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/5/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "TimerViewCell.h"

@implementation TimerViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions

- (IBAction)stopButtonPressed:(id)sender
{
    id<TimerCellDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(timerDidPressStop:)]) {
        [strongDelegate timerDidPressStop:self];
    }
}

- (IBAction)splitButtonPressed:(id)sender
{
    id<TimerCellDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(timerDidPressSplit:)]) {
        [strongDelegate timerDidPressSplit:self];
    }

}

@end
