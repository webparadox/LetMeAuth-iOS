//
//  LMABaseRequest.m
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 30/11/14.
//  Copyright (c) 2014 Webparadox, LLC. All rights reserved.
//


#import "LMABaseRequest.h"


typedef NS_ENUM(NSInteger, LMABaseRequestState) {
    LMABaseRequestStateNew,
    LMABaseRequestStateStarted,
    LMABaseRequestStateTriggered,
    LMABaseRequestStateFinished
};


@interface LMABaseRequest ()

@property (strong, nonatomic, readwrite) NSDictionary *credential;
@property (strong, nonatomic, readwrite) NSError *error;
@property (assign, nonatomic) LMABaseRequestState state;

- (void)finish;

@end


@implementation LMABaseRequest

@synthesize provider = _provider;
@synthesize credential = _credential;
@synthesize error = _error;
@synthesize completionBlock = _completionBlock;

- (void)start
{
    if (self.state != LMABaseRequestStateNew) {
        return;
    }
    self.state = LMABaseRequestStateStarted;

    [self.provider start];
}

- (void)cancel
{
    if (self.state == LMABaseRequestStateNew) {
        self.state = LMABaseRequestStateTriggered;
        [self finish];
        return;
    }

    if (self.state == LMABaseRequestStateStarted) {
        self.state = LMABaseRequestStateTriggered;
        [self.provider cancel];
        return;
    }
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (self.state != LMABaseRequestStateStarted) {
        return NO;
    }

    BOOL result = [self.provider handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result) {
        self.state = LMABaseRequestStateTriggered;
    }

    return result;
}

- (void)handleDidBecomeActive
{
    if (self.state != LMABaseRequestStateStarted) {
        return;
    }

    BOOL result = [self.provider handleDidBecomeActive];
    if (result) {
        self.state = LMABaseRequestStateTriggered;
    }
}

- (void)finish
{
    self.state = LMABaseRequestStateFinished;

    void (^completionBlock)() = self.completionBlock;
    if (completionBlock) {
        completionBlock();
    }
}

#pragma mark -
#pragma mark LMAProviderDelegate

- (void)provider:(id<LMAProvider>)provider didAuthenticateWithData:(NSDictionary *)data
{
    if (self.state == LMABaseRequestStateFinished) {
        return;
    }

    self.credential = data;
    [self finish];
}

- (void)provider:(id<LMAProvider>)provider didFailWithError:(NSError *)error
{
    if (self.state == LMABaseRequestStateFinished) {
        return;
    }

    self.error = error;
    [self finish];
}

- (void)providerDidCancel:(id<LMAProvider>)provider
{
    if (self.state == LMABaseRequestStateFinished) {
        return;
    }

    [self finish];
}

@end
