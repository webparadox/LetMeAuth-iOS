//
//  LMAStubProvider.m
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 30/11/14.
//  Copyright (c) 2014 Webparadox, LLC. All rights reserved.
//


#import "LMAStubProvider.h"
#import <UIKit/UIKit.h>


NSString *const LMAStubProviderUrlKey = @"LMAStubProviderUrlKey";
NSString *const LMAStubProviderSourceApplicationKey = @"LMAStubProviderSourceApplicationKey";
NSString *const LMAStubProviderCredentialKey = @"LMAStubProviderCredentialKey";
NSString *const LMAStubProviderErrorKey = @"LMAStubProviderErrorKey";


@interface LMAStubProvider ()

@property (strong, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *sourceApplication;
@property (strong, nonatomic) id credential;
@property (strong, nonatomic) NSError *error;
@property (assign, nonatomic) BOOL finished;

@end


@implementation LMAStubProvider

@synthesize providerDelegate = _providerDelegate;

- (id)initWithConfiguration:(NSDictionary *)configuration
{
    self = [super init];
    if (!self) {
        return nil;
    }

    NSURL *url = [configuration objectForKey:LMAStubProviderUrlKey];
    self.url = url;

    NSString *sourceApplication = [configuration objectForKey:LMAStubProviderSourceApplicationKey];
    self.sourceApplication = sourceApplication;

    id credential = [configuration objectForKey:LMAStubProviderCredentialKey];
    self.credential = credential;

    NSError *error = [configuration objectForKey:LMAStubProviderErrorKey];
    self.error = error;

    return self;
}

- (void)start
{
    if (self.finished) {
        return;
    }

    UIApplication *currentApplication = [UIApplication sharedApplication];

    NSURL *url = self.url;
    NSString *sourceApplication = self.sourceApplication;

    if (self.credential || self.error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [currentApplication.delegate application:currentApplication openURL:url sourceApplication:sourceApplication annotation:nil];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [currentApplication.delegate applicationDidBecomeActive:currentApplication];
        });
    }
}

- (void)cancel
{
    if (self.finished) {
        return;
    }

    self.finished = YES;

    [self.providerDelegate providerDidCancel:self];
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (self.finished) {
        return NO;
    }

    if ([self.sourceApplication isEqualToString:sourceApplication] && [[self.url absoluteString] isEqualToString:[url absoluteString]]) {
        if (self.credential) {
            [self.providerDelegate provider:self didAuthenticateWithData:self.credential];
        } else if (self.error) {
            [self.providerDelegate provider:self didFailWithError:self.error];
        }
        return YES;
    }

    return NO;
}

- (BOOL)handleDidBecomeActive
{
    if (self.finished) {
        return YES;
    }

    self.finished = YES;

    [self.providerDelegate providerDidCancel:self];

    return YES;
}

@end
