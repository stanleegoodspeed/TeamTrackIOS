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


@end
