//
//  PostToServer.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define APIURL "http://splts-dev.elasticbeanstalk.com/"
#define APIURL "http://192.168.1.3:8081/"

// Declare delegate
@protocol PostToServerDelegate;

@interface PostToServer : NSObject <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSString *dataReturned;
    NSDictionary *dataDict;
    NSMutableData *dataBlock;
    BOOL queryType;
}

+ (PostToServer *)sharedStore;
@property (nonatomic, weak) id<PostToServerDelegate> delegate;
- (void)postDataToServer:(NSMutableDictionary *)dataDictionary withQuery:(NSString *)queryStr;
- (void)getDataFromServer:(NSString *)queryStr;
@end


// Delegate declaration
@protocol PostToServerDelegate <NSObject>

@optional

- (void)didCompletePost:(NSDictionary *)dataDict;
- (void)didCompleteGet:(NSDictionary *)dataDict;

@end
