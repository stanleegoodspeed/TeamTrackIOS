//
//  TableViewCell.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerDelegate;

@interface TableViewCell : UITableViewCell
{
    BOOL running;
    NSTimeInterval startTime;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIButton *lapButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;

- (IBAction)stopTimer:(id)sender;

@end




@protocol TimerDelegate <NSObject>

- (void)pressedStartButton;

@end
