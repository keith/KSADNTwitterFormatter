//
//  KSADNTwitterFormatter.h
//  A simple helper method for reformatting ADN posts to Tweets depending on their length
//
//  Created by Keith Smiley @smileykeith
//

#import <Foundation/Foundation.h>

@interface KSADNTwitterFormatter : NSObject


/**
   This method returns a shared insance of KSADNTwitterFormatter so that variables can be cached
 
   Using this shared instance call the formatting instance methods
 **/
+ (KSADNTwitterFormatter *)shared;


/**
   This method receives the users string to be reformatted for twitter and the URL of the ADN post
    in the case it's too long for twitter and needs to be appended.

    String: The text you want to be converted for twitter

    URL: The URL of the ADN post, which is appended when the text is too long
 **/
- (NSString *)formatTwitterStringWithString:(NSString *)string andURL:(NSURL *)url;


/**
    This is purely a convinence method for determine the length of the string
        that would be produced with the passed string
 
    String: The text that would be used for the twitter post
 **/
- (NSUInteger)twitterLengthOfString:(NSString *)string;

@end
