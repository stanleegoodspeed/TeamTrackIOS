//
//  Dropdown.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 9/22/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "Dropdown.h"

@implementation Dropdown

- (id) init {
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.myCode = [aDecoder decodeObjectForKey:@"myCode"];
        self.myDescription = [aDecoder decodeObjectForKey:@"myDescription"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.myCode forKey:@"myCode"];
    [aCoder encodeObject:self.myDescription forKey:@"myDescription"];
}

@end
