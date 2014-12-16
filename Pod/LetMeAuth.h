//
//  LetMeAuth.h
//  LetMeAuth
//
//  Created by Alexey Aleshkov on 29.11.14.
//  Copyright (c) 2013 Webparadox, LLC. All rights reserved.
//

/**
 *  Workflow
 *
 *  Prepare
 *    Create LMAController (basically LMABaseController)
 *    Save instance somewhere (as property or shared object)
 *
 *    Register default request class (often LMABaseRequest) for providers without their own request class
 *
 *    Register provider class for some key (e.g. @"Provider1")
 *    It will use default request class
 *      or
 *    Register provider class for some key (e.g. @"Provider2")
 *    Register request class for the same key (@"Provider2") for use with @"Provider2" class
 *
 *  Authenticate
 *    Create request for provider with configuration
 *    Configuration will be passed to [LMAProvider initWithConfiguration:configuration] constructor
 *    id<LMARequest> request = [controller authenticateWithProvider:@"Provider1" configuration:@{} completionHandler:^(NSDictionary *credential, NSError *error) {}];
 *
 *    Start request by sending `start` message to request instance: [request start];
 *
 *    Cancel request if needed: [request cancel];
 *
 *    Wait for result in completionHandler block
 *
 *  Finishing
 *    After the request has been completed, it will be immediately removed from the request queue inside the controller.
 */

#import "LMAProvider.h"
#import "LMARequest.h"
#import "LMAController.h"

#import "LMABaseController.h"
#import "LMABaseRequest.h"

#import "LMAConstants.h"
