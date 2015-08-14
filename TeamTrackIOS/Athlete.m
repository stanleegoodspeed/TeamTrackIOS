//
//  Athelete.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/5/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "Athlete.h"

@implementation Athlete

- (id) init {
    self = [super init];
    if (self != nil) {
        self.splits = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.runInRaceID = [aDecoder decodeObjectForKey:@"runInRaceID"];
        self.runnerID = [aDecoder decodeObjectForKey:@"runnerID"];
        self.finishTime = [aDecoder decodeObjectForKey:@"finishTime"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.runInRaceID forKey:@"runInRaceID"];
    [aCoder encodeObject:self.runnerID forKey:@"runnerID"];
    [aCoder encodeObject:self.finishTime forKey:@"finishTime"];
    //[aCoder encodeObject:self.lastName forKey:@"lastName"];
}


@end
