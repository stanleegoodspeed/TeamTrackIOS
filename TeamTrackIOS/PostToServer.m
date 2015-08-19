//
//  PostToServer.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "PostToServer.h"

@implementation PostToServer

// Singleton declaration
+ (PostToServer *)sharedStore
{
    static PostToServer *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil]init];
    
    return sharedStore;
}

// Override of allocWithZone - (alloc is just a dummy call that actually calls allocWithZone:)
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (void)postDataToServer:(NSMutableDictionary *)dataDictionary withURL:(NSURL *)url;
{
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    
    if(!jsonSerializationError) {
        NSString *serJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJSON);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error = nil;
    NSLog(@"Receiving data...");
    if(data) {
        dataReturned = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    id<PostToServerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(didCompletePost:withData:withDict:)]) {
        [strongDelegate didCompletePost:TRUE withData:dataReturned withDict:dataDict];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
    
    id<PostToServerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(didCompletePost:withData:withDict:)]) {
        [strongDelegate didCompletePost:FALSE withData:dataReturned withDict:dataDict];
    }
}

@end
