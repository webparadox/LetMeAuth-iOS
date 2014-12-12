//
//  LMAController.h
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 07.10.13.
//  Copyright (c) 2013 Webparadox, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LMAProvider.h"
#import "LMARequest.h"


/// Possible results:
///   credential != nil, error == nil: success
///   credential == nil, error != nil: failure
///   credential == nil, error == nil: cancel
typedef void (^LMAAuthenticateHandler)(NSDictionary *credential, NSError *error);


/// Responsible for storing requests and notification of completion of the authorization procedures
@protocol LMAController <NSObject>

/// Default request class
/// For providers without their own request classes
- (Class<LMARequest>)defaultRequestClass;
- (void)setDefaultRequestClass:(Class<LMARequest>)defaultRequestClass;

/// Providers code names
- (NSArray *)providerKeys;
/// Register provider class for code name
- (void)registerProviderClass:(Class<LMAProvider>)providerClass forKey:(NSString *)key;
/// Unregister (remove) provider class by its code name
- (void)unregisterProviderClassForKey:(NSString *)key;
/// Get provider class by its code name
- (Class<LMAProvider>)providerClassForKey:(NSString *)key;

/// Requests code names (must be same as for provider)
- (NSArray *)requestKeys;
/// Register request class for code name
- (void)registerRequestClass:(Class<LMARequest>)requestClass forKey:(NSString *)key;
/// Unregister (remove) request class by its code name
- (void)unregisterRequestClassForKey:(NSString *)key;
/// Get request class by its code name
- (Class<LMAProvider>)requestClassForKey:(NSString *)key;

/// Create authorization request for provider (and request) by code name and store it in request queue
/// You must `start` or `cancel` request
- (id<LMARequest>)authorizeWithProvider:(NSString *)provider configuration:(NSDictionary *)configuration completionHandler:(LMAAuthenticateHandler)completionHandler;

/// Call this method from [UIApplication application:openURL:sourceApplication:annotation:].
/// Do not ignore value, returned by this method! Pass it back as result of caller.
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
/// Call this method from [UIApplication applicationDidBecomeActive:].
- (void)handleDidBecomeActive;

@end
