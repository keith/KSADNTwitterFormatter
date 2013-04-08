//
//  ExampleTests.h
//  ExampleTests
//
//  Created by Keith Smiley on 4/8/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface ExampleTests : SenTestCase

@property (nonatomic, strong) NSString *shortPostText;
@property (nonatomic, strong) NSString *longPostText;
@property (nonatomic, strong) NSURL *dummyURL;
@property (nonatomic, strong) NSURL *dummyHTTPSURL;

@end
