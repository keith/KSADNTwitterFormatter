//
//  KSADNTwitterFormatter_ExampleTests.m
//  KSADNTwitterFormatter ExampleTests
//
//  Created by Keith Smiley on 3/30/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "KSADNTwitterFormatter_ExampleTests.h"
#import "KSADNTwitterFormatter.h"

@implementation KSADNTwitterFormatter_ExampleTests

- (void)setUp
{
    [super setUp];
    
    self.shortPostText = @"This is a short post";
    self.longPostText = @"This is a long string that is much to long for a Twitter post but isn't too long for an ADN post. Luckily this library will truncate it and add the URL passed (typically the ADN URL) to the end.";
    self.dummyURL = [NSURL URLWithString:@"http://someurltoyourpost.com"];
}

- (void)tearDown
{
    self.shortPostText = nil;
    self.longPostText = nil;
    self.dummyURL = nil;

    [super tearDown];
}

- (void)testNotTooLong
{
    NSString *twitterText = [KSADNTwitterFormatter formatTwitterStringWithString:self.shortPostText andURL:self.dummyURL];
    STAssertTrue([self.shortPostText isEqualToString:twitterText], @"The text should be the same for short posts");
}

- (void)testTooLong
{
    NSString *twitterText = [KSADNTwitterFormatter formatTwitterStringWithString:self.longPostText andURL:self.dummyURL];
    STAssertTrue([twitterText rangeOfString:@"...\n"].location != NSNotFound, @"The long string should contain dots and a newline");
    STAssertTrue([twitterText rangeOfString:self.dummyURL.absoluteString].location != NSNotFound, @"The long string should contain the passed URL");
}

- (void)testTwoosh
{
    NSString *twooshText = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    NSString *twitterText = [KSADNTwitterFormatter formatTwitterStringWithString:twooshText andURL:self.dummyURL];
    STAssertTrue([twooshText isEqualToString:twitterText], @"The text should be the same for 140 character posts");
}

- (void)testLongSingleWord
{
    NSString *longWord = @"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
    NSString *twitterText = [KSADNTwitterFormatter formatTwitterStringWithString:longWord andURL:self.dummyURL];
    STAssertTrue([twitterText isEqualToString:self.dummyURL.absoluteString], @"Too long single words should just print the URL");
}

@end
