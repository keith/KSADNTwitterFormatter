//
//  KBSAppDelegate.m
//  Example
//
//  Created by Keith Smiley on 4/8/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "KBSAppDelegate.h"
#import "KSADNTwitterFormatter.h"

@implementation KBSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *postText = @"This is a long string that is much to long for a Twitter post but isn't too long for an ADN post. Luckily this library will truncate it and add the URL passed (typically the ADN URL) to the end.";
    NSLog(@"\n\nOriginal Post: %@\n\nTwitter Post: %@", postText, [[KSADNTwitterFormatter shared] formatTwitterStringWithString:postText andURL:[NSURL URLWithString:@"http://thelinktosomepostid.com/"]]);
}

@end
