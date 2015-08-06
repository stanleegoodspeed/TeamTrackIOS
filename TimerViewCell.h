//
//  TimerViewCell.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/5/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerCellDelegate;

@interface TimerViewCell : UITableViewCell
{
    
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIButton *splitButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) id<TimerCellDelegate> delegate;


- (IBAction)stopButtonPressed:(id)sender;
- (IBAction)splitButtonPressed:(id)sender;

@end

// Delegate definition
@protocol TimerCellDelegate <NSObject>

- (void)timerDidPressStop:(TimerViewCell *)timerCell;
- (void)timerDidPressSplit:(TimerViewCell *)timerCell;

@end
