//
//  NetConnection.m
//  Network Connection Class.
//
//  Created by Paulo Sergio Pimentel on 2015/06/10.
//  Copyright (c) 2015年 __Paulo Pimentel.__. All rights reserved.
//

#import "NetConnection.h"


@implementation NetConnection

@synthesize delegate;

// ------------------------------------------------------------------------------------------------
// 通信開始(GET).
// IN：  urlStr: URL, userAgent: USER AGENT, cache: キャッシュポリシー(YES, NO), tag: TAG.
// OUT： YES: 通信開始成功, NO: 通信開始失敗（通信中）.
// ------------------------------------------------------------------------------------------------
- (BOOL)connectGet:(NSString*)urlStr userAgent:(NSString*)userAgent cache:(BOOL)cache tag:(int)tag
{
    // 通信状態確認.
    if(m_is_connecting){
        return NO;
    }
    
    m_data = [[NSMutableData alloc] initWithCapacity:0];
    m_tag  = tag;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL: url];
    [req setHTTPMethod: @"GET"];
    if(userAgent != nil && ![userAgent isEqualToString:@""]){
        [req setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    if(cache == YES){
        [req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    }else{
        [req setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    }
    [req setTimeoutInterval:TIME_OUT_INTERVAL];

//#if DEBUG_NET
    //if(urlStr != nil){
    //    LOG(urlStr);
    //}
//#endif
    
    m_connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    m_is_connecting = YES;
    
    return YES;
}

// ------------------------------------------------------------------------------------------------
// 通信開始(POST).
// IN：  urlStr: URL, userAgent: USER AGENT, postData: POSTデータ, cache: キャッシュポリシー(YES, NO), tag: TAG.
// OUT： YES: 通信開始成功, NO: 通信開始失敗（通信中）.
// ------------------------------------------------------------------------------------------------
- (BOOL)connectPost:(NSString*)urlStr userAgent:(NSString*)userAgent postData:(NSData*)postData cache:(BOOL)cache tag:(int)tag
{
    // 通信状態確認.
    if(m_is_connecting){
        return NO;
    }
    
    m_data = [[NSMutableData alloc] initWithCapacity:0];
    m_tag  = tag;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL: url];
    [req setHTTPMethod: @"POST"];
    [req setHTTPBody:postData];
    if(userAgent != nil && ![userAgent isEqualToString:@""]){
        [req setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    if(cache == YES){
        [req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    }else{
        [req setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    }
    [req setTimeoutInterval:TIME_OUT_INTERVAL];
   
//#if DEBUG_NET
    //if(urlStr != nil){
    //    LOG(urlStr);
    //}
    //if(postData != nil){
    //    LOG([[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    //}
//#endif
    
    m_connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    m_is_connecting = YES;
    
    return YES;
}

// ------------------------------------------------------------------------------------------------
// 通信キャンセル.
// IN：  none.
// OUT： none.
// ------------------------------------------------------------------------------------------------
- (void)cancel
{
    if (m_connection != nil) {
        [m_connection cancel];
    }
    m_is_connecting = NO;
}

// ------------------------------------------------------------------------------------------------
// didReceiveResponse CB.
// IN:  none.
// OUT: none.
// ------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [m_data setLength:0];
}

// ------------------------------------------------------------------------------------------------
// didReceiveData CB.
// IN:  none.
// OUT: none.
// ------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata
{
    [m_data appendData:nsdata];
}

// ------------------------------------------------------------------------------------------------
// didFailWithError CB.
// IN:  none.
// OUT: none.
// ------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    m_data = nil;
    
    [[self delegate] netConnectionResult:m_data tag:m_tag];
    
    [self cancel];
}

// ------------------------------------------------------------------------------------------------
// connectionDidFinishLoading CB.
// IN:  none.
// OUT: none.
// ------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//#if DEBUG_NET
    //if(m_data != nil){
    //    LOG([[NSString alloc] initWithData:m_data encoding:NSUTF8StringEncoding]);
    //}
//#endif
    
    [[self delegate] netConnectionResult:m_data tag:m_tag];
    
    [self cancel];
}

@end
