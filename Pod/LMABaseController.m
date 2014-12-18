//
//  LMABaseController.m
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 05/12/14.
//  Copyright (c) 2014 Webparadox, LLC. All rights reserved.
//


#import "LMABaseController.h"


@interface LMABaseController ()

@property (strong, nonatomic) Class<LMARequest> defaultRequestClass;

@property (strong, nonatomic) NSRecursiveLock *providerClassesLock;
@property (strong, nonatomic) NSMutableDictionary *providerClasses;
@property (strong, nonatomic) NSRecursiveLock *requestClassesLock;
@property (strong, nonatomic) NSMutableDictionary *requestClasses;
@property (strong, nonatomic) NSRecursiveLock *requestsLock;
@property (strong, nonatomic) NSMutableArray *requests;

@end


@implementation LMABaseController

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.providerClassesLock = [[NSRecursiveLock alloc] init];
    self.providerClasses = [[NSMutableDictionary alloc] init];
    self.requestClassesLock = [[NSRecursiveLock alloc] init];
    self.requestClasses = [[NSMutableDictionary alloc] init];
    self.requestsLock = [[NSRecursiveLock alloc] init];
    self.requests = [[NSMutableArray alloc] init];

    return self;
}

#pragma mark Providers

- (NSArray *)providerKeys
{
    NSArray *result;
    [self.providerClassesLock lock];
    result = [self.providerClasses allKeys];
    [self.providerClassesLock unlock];
    return result;
}

- (void)registerProviderClass:(Class<LMAProvider>)providerClass forKey:(NSString *)key
{
    NSParameterAssert(providerClass != nil);
    NSParameterAssert(key != nil);

    [self.providerClassesLock lock];
    [self.providerClasses setObject:providerClass forKey:key];
    [self.providerClassesLock unlock];
}

- (void)unregisterProviderClassForKey:(NSString *)key
{
    [self.providerClassesLock lock];
    [self.providerClasses removeObjectForKey:key];
    [self.providerClassesLock unlock];
}

- (Class<LMAProvider>)providerClassForKey:(NSString *)key
{
    Class result;

    [self.providerClassesLock lock];
    result = [self.providerClasses objectForKey:key];
    [self.providerClassesLock unlock];

    return result;
}

#pragma mark Requests

- (NSArray *)requestKeys
{
    NSArray *result;
    [self.requestClassesLock lock];
    result = [self.requestClasses allKeys];
    [self.requestClassesLock unlock];
    return result;
}

- (void)registerRequestClass:(Class<LMARequest>)requestClass forKey:(NSString *)key
{
    NSParameterAssert(requestClass != nil);
    NSParameterAssert(key != nil);

    [self.requestClassesLock lock];
    [self.requestClasses setObject:requestClass forKey:key];
    [self.requestClassesLock unlock];
}

- (void)unregisterRequestClassForKey:(NSString *)key
{
    [self.requestClassesLock lock];
    [self.requestClasses removeObjectForKey:key];
    [self.requestClassesLock unlock];
}

- (Class<LMARequest>)requestClassForKey:(NSString *)key
{
    Class result;

    [self.requestClassesLock lock];
    result = [self.requestClasses objectForKey:key];
    [self.requestClassesLock unlock];

    return result;
}

#pragma mark Public methods

- (id<LMARequest>)authorizeWithProvider:(NSString *)key configuration:(NSDictionary *)configuration completionHandler:(LMAAuthenticateHandler)completionHandler
{
    NSAssert(self.defaultRequestClass != nil, @"Default request class not found");
    NSParameterAssert(completionHandler != nil);

    Class providerClass = [self providerClassForKey:key];
    NSAssert(providerClass != nil, @"Provider class not found");

    Class requestClass = [self requestClassForKey:key];
    if (!requestClass) {
        requestClass = self.defaultRequestClass;
    }

    // create provider
    id<LMAProvider> provider = [[providerClass alloc] initWithConfiguration:configuration];

    // create request
    id<LMARequest> request = [[requestClass alloc] init];

    provider.providerDelegate = request;
    request.provider = provider;

    __weak typeof(self)weakSelf = self;
    __weak typeof(request)weakRequest = request;
    request.completionBlock = ^() {
        __strong typeof(weakSelf)self = weakSelf;
        __strong typeof(weakRequest)request = weakRequest;

        completionHandler(request.credential, request.error);

        [self removeRequest:request];
    };

    [self addRequest:request];

    return request;
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = NO;

    // Prevent array mutations when iterating
    // Make strong references to requests
    NSArray *requests;
    [self.requestsLock lock];
    requests = [self.requests copy];
    [self.requestsLock unlock];

    // find suitable request
    for (id<LMARequest> request in requests) {
        if ([request handleOpenURL:url sourceApplication:sourceApplication annotation:annotation]) {
            result = YES;
            break;
        }
    }

    return result;
}

- (void)handleDidBecomeActive
{
    // Prevent array mutations when iterating
    // Make strong references to requests
    NSArray *requests;
    [self.requestsLock lock];
    requests = [self.requests copy];
    [self.requestsLock unlock];

    // cancel all requests
    for (id<LMARequest> request in requests) {
        [request handleDidBecomeActive];
    }
}

#pragma mark Requests

- (void)addRequest:(id<LMARequest>)request
{
    [self.requestsLock lock];
    [self.requests insertObject:request atIndex:0];
    [self.requestsLock unlock];
}

- (void)removeRequest:(id<LMARequest>)request
{
    [self.requestsLock lock];
    [self.requests removeObject:request];
    [self.requestsLock unlock];
}

@end
