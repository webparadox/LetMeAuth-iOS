//
//  LMAProvider.h
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 29/11/14.
//  Copyright (c) 2014 Webparadox, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol LMAProvider;

@protocol LMAProviderDelegate <NSObject>
@required
- (void)provider:(id<LMAProvider>)provider didAuthenticateWithData:(NSDictionary *)data;
- (void)provider:(id<LMAProvider>)provider didFailWithError:(NSError *)error;
- (void)providerDidCancel:(id<LMAProvider>)provider;
@end


/// Responsible for the authorization process of one service
@protocol LMAProvider <NSObject>

/// Delegate methods called by provider
/// Set by controller
@property (weak, nonatomic) id<LMAProviderDelegate> providerDelegate;

/// You can pass anything you want: controllers, your configurations
/// Called by controller
- (id)initWithConfiguration:(NSDictionary *)configuration;

/// Start authorization process
/// Called by request
- (void)start;
/// Cancel authorization process
/// Called by request
- (void)cancel;

/// Return YES if provider can handle url from application, otherwise - NO
/// Used for external (like Safari) authorization
/// Called by request
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
/// Return YES if provider handled event
/// Used for external (like Safari) authorization
/// Called by request
- (BOOL)handleDidBecomeActive;

@end
