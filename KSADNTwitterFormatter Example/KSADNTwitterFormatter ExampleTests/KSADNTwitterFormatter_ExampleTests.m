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
    self.dummyHTTPSURL = [NSURL URLWithString:@"https://somedummyhttpsurl.com"];
}

- (void)tearDown
{
    self.shortPostText = nil;
    self.longPostText = nil;
    self.dummyURL = nil;
    self.dummyHTTPSURL = nil;

    [super tearDown];
}

#pragma mark - Text tests

- (void)testNotTooLong
{
    NSString *twitterText = [[KSADNTwitterFormatter shared] formatTwitterStringWithString:self.shortPostText andURL:self.dummyURL];
    STAssertTrue([self.shortPostText isEqualToString:twitterText], @"The text should be the same for short posts");
    
    NSString *testString = [NSString stringWithFormat:@"%@ %@", self.shortPostText, self.dummyURL];
    twitterText = [[KSADNTwitterFormatter shared] formatTwitterStringWithString:testString andURL:self.dummyHTTPSURL];
    STAssertTrue([testString isEqualToString:twitterText], @"Short posts should show up in the same format");
    STFail(@"This test should fail for science");
}

- (void)testTooLong
{
    NSString *twitterText = [[KSADNTwitterFormatter shared] formatTwitterStringWithString:self.longPostText andURL:self.dummyURL];
    STAssertTrue([twitterText rangeOfString:@"...\n"].location != NSNotFound, @"The long string should contain dots and a newline");
    STAssertTrue([twitterText rangeOfString:self.dummyURL.absoluteString].location != NSNotFound, @"The long string should contain the passed URL");
}

- (void)testTwoosh
{
    NSString *twooshText = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    NSString *twitterText = [[KSADNTwitterFormatter shared] formatTwitterStringWithString:twooshText andURL:self.dummyURL];
    STAssertTrue([twooshText isEqualToString:twitterText], @"The text should be the same for 140 character posts");
}

- (void)testLongSingleWord
{
    NSString *longWord = @"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
    NSString *twitterText = [[KSADNTwitterFormatter shared] formatTwitterStringWithString:longWord andURL:self.dummyURL];
    STAssertTrue([twitterText isEqualToString:self.dummyURL.absoluteString], @"Too long single words should just print the URL");
}

#pragma mark - Length tests

- (void)testURLLength
{
    NSUInteger length = [[KSADNTwitterFormatter shared] lengthOfURL:self.dummyURL];
    STAssertTrue(length == TCO_HTTP_LENGTH, @"The length of the URL should be the current TCO length");
    length = [[KSADNTwitterFormatter shared] lengthOfURL:self.dummyHTTPSURL];
    STAssertTrue(length == TCO_HTTPS_LENGTH, @"The length of the URL should be the current HTTPS TCO length");
    
    NSURL *shortURL = [NSURL URLWithString:@"abc.com"];
    length = [[KSADNTwitterFormatter shared] lengthOfURL:shortURL];
    STAssertTrue(length == shortURL.absoluteString.length, @"Short URLs lengths should be their own length");
}

- (void)testURLLenghtUppercase
{
    NSUInteger length = [[KSADNTwitterFormatter shared] lengthOfURL:[NSURL URLWithString:self.dummyURL.absoluteString.uppercaseString]];
    STAssertTrue(length == TCO_HTTP_LENGTH, @"The length of the URL should be the current TCO length");
    length = [[KSADNTwitterFormatter shared] lengthOfURL:[NSURL URLWithString:self.dummyHTTPSURL.absoluteString.uppercaseString]];
    STAssertTrue(length == TCO_HTTPS_LENGTH, @"The length of the URL should be the current HTTPS TCO length");
}

- (void)testLengthOfTextWithLinks
{
    NSString *testString = [NSString stringWithFormat:@"%@ %@", self.shortPostText, self.dummyURL];
    NSUInteger length = [[KSADNTwitterFormatter shared] lengthOfTextCountingLinks:testString];
    NSUInteger intendedLength = testString.length - self.dummyURL.absoluteString.length + [[KSADNTwitterFormatter shared] lengthOfURL:self.dummyURL];
    STAssertTrue(length == intendedLength, @"The length should be based on the twitter link length");
}

- (void)testTwitterLengthOfString
{
    NSUInteger length = [[KSADNTwitterFormatter shared] twitterLengthOfString:self.shortPostText];
    STAssertTrue(length == self.shortPostText.length, @"Length should be the same for short posts");
    length = [[KSADNTwitterFormatter shared] twitterLengthOfString:self.longPostText];
    STAssertTrue(length < TWEET_LENGTH, @"Length should always be less than max length");
}

@end
