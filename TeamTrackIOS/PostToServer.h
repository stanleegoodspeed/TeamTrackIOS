//
//  PostToServer.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

// Declare delegate
@protocol PostToServerDelegate;

@interface PostToServer : NSObject <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSString *dataReturned;
    NSDictionary *dataDict;
}

+ (PostToServer *)sharedStore;
@property (nonatomic, weak) id<PostToServerDelegate> delegate;
- (void)postDataToServer:(NSMutableDictionary *)dataDictionary withURL:(NSURL *)url;

@end


// Delegate declaration
@protocol PostToServerDelegate <NSObject>

- (void)didCompletePost:(BOOL)status withData:(NSString *)data withDict:(NSDictionary *)dataDict;

@end
