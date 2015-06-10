//
//  NetConnection.h
//  Network Connection Class.
//
//  Created by Paulo Sergio Pimentel on 2015/06/10.
//  Copyright (c) 2015年 __Paulo Pimentel.__. All rights reserved.
//

#import <UIKit/UIKit.h>

// Defines.
// Time Out Interval.
#define TIME_OUT_INTERVAL   30.0

// Delegates.
@protocol NetConnectionDelegate
- (void)netConnectionResult:(NSData*)data tag:(int)tag;
@end

// Net Connection Class.
@interface NetConnection : NSObject
{
    id <NetConnectionDelegate>  delegate;           // デリゲート.
    BOOL                        m_is_connecting;    // 通信中フラグ.
    NSURLConnection             *m_connection;      // 通信クラスポインタ.
    NSMutableData               *m_data;            // レスポンスデータ.
    int                         m_tag;              // TAG.
}

// Delegate.
@property (nonatomic, strong) id <NetConnectionDelegate> delegate;

// GET Connection.
- (BOOL)connectGet:(NSString*)urlStr userAgent:(NSString*)userAgent cache:(BOOL)cache tag:(int)tag;
// POST Connection.
- (BOOL)connectPost:(NSString*)urlStr userAgent:(NSString*)userAgent postData:(NSData*)postData cache:(BOOL)cache tag:(int)tag;
// Cancel Connection.
- (void)cancel;

@end
