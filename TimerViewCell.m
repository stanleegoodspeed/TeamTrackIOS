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
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    //NSIndexPath *clickedButtonPath = [self.tableView indexPathForCell:clickedCell];
    

    id<TimerCellDelegate> strongDelegate = self.delegate;
    
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(timerDidPressStop:atIndex:)]) {
        [strongDelegate timerDidPressStop:self atIndex:1];
    }
}

- (IBAction)lapButtonPressed:(id)sender
{
    
}

@end
