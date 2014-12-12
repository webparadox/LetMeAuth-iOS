//
//  LMARequest.h
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 30/11/14.
//  Copyright (c) 2014 Webparadox, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LMAProvider.h"


/// Responsible for the control of the process of passing a separate authorization process of provider
/// Filters multiple calls of methods from controller and provider
/// Handles provider results
@protocol LMARequest <NSObject, LMAProviderDelegate>

/// Provider instance
/// Set by controller
@property (strong, nonatomic) id<LMAProvider> provider;

/// Authorization results
/// Set by request from provider delegate methods
@property (strong, nonatomic, readonly) NSDictionary *credential;
@property (strong, nonatomic, readonly) NSError *error;

/// Called when authorization process is finished
/// Called by request
@property (copy, nonatomic) void (^completionBlock)(void);

/// Start authorization request
/// Called by user
- (void)start;
/// Cancel authorization request
/// Called by user
- (void)cancel;

/// Called for all requests, until it returns YES from at least one of them
/// Called by controller
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
/// Called for all requests
/// Called by controller
- (void)handleDidBecomeActive;

@end
