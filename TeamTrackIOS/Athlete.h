//
//  Athelete.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/5/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Athlete : NSObject <NSCoding>
{
    
}

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSNumber *runInRaceID;
@property (nonatomic, retain) NSMutableArray *splits;
@property (nonatomic, retain) NSNumber *finishTime;


@end
