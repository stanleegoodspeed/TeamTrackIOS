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

#pragma mark - GET

- (void)getDataFromServer:(NSString *)queryStr
{
    queryType = TRUE;
    //dataBlock = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@",APIURL,queryStr]];
    //dataBlock = [[NSMutableData alloc]init];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:YES];
}

#pragma mark - POST

- (void)postDataToServer:(NSMutableDictionary *)dataDictionary withQuery:(NSString *)queryStr
{
    queryType = FALSE;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@",APIURL,queryStr]];
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
        dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    id<PostToServerDelegate> strongDelegate = self.delegate;
    
    if(queryType)
    {
        if ([strongDelegate respondsToSelector:@selector(didCompleteGet:)]) {
            [strongDelegate didCompleteGet:dataDict];
        }
    }
    else
    {
        if ([strongDelegate respondsToSelector:@selector(didCompletePost:)]) {
            [strongDelegate didCompletePost:dataDict];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
}

@end
