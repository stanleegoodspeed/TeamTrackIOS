//
//  PostToServer.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "PostToServer.h"

@implementation PostToServer

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
    NSLog(@"Receiving data...");
    if(data) {
        dataReturned = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    id<PostToServerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(didCompletePost:withData:)]) {
        [strongDelegate didCompletePost:TRUE withData:dataReturned];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
    
    id<PostToServerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(didCompletePost:withData:)]) {
        [strongDelegate didCompletePost:FALSE withData:dataReturned];
    }
}

@end