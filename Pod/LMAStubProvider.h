//
//  LMAStubProvider.h
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 30/11/14.
//  Copyright (c) 2014 Webparadox, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LMAProvider.h"


// NSURL
// Url that provider must handle
extern NSString *const LMAStubProviderUrlKey;
// NSString
// Source application's bundle identifier that provider must handle
extern NSString *const LMAStubProviderSourceApplicationKey;
// NSDictionary
// Credential that provider will return
extern NSString *const LMAStubProviderCredentialKey;
// NSError
// Error that provider will return
extern NSString *const LMAStubProviderErrorKey;


// Provider's stub implementation for testing purpose
@interface LMAStubProvider : NSObject <LMAProvider>

@end
