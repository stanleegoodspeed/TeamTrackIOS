//
//  PostToServer.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
#define APIURL "http://himrod.home/~Colin/TeamTrack/api/index.php/"

// Declare delegate
@protocol PostToServerDelegate;

@interface PostToServer : NSObject <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSString *dataReturned;
    NSDictionary *dataDict;
    NSMutableData *dataBlock;
}

+ (PostToServer *)sharedStore;
@property (nonatomic, weak) id<PostToServerDelegate> delegate;
- (void)postDataToServer:(NSMutableDictionary *)dataDictionary withQuery:(NSString *)queryStr;
- (void)getDataFromServer:(NSString *)queryStr;
@end


// Delegate declaration
@protocol PostToServerDelegate <NSObject>

@optional

- (void)didCompletePost:(BOOL)status withData:(NSString *)data withDict:(NSDictionary *)dataDict;
- (void)didCompleteGet:(BOOL)status withData:(NSMutableData *)data;

@end
