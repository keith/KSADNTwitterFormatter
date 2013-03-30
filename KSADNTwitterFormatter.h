//
//  KSADNTwitterFormatter.h
//  A simple helper method for reformatting ADN posts to Tweets depending on their length
//
//  Created by Keith Smiley @smileykeith
//

#import <Foundation/Foundation.h>

// The maximum length for a tweet. Probably could've hard coded
#define TWEET_LENGTH 140

// The maximum length when the text is too long for a tweet and must be reduced
#define MAX_POST_LENGTH 113

//
// The length of t.co links as it stands today see:
// https://dev.twitter.com/docs/tco-link-wrapper/faq#Will_t.co-wrapped_links_always_be_the_same_length
//
#define TCO_HTTP_LENGTH 22
#define TCO_HTTPS_LENGTH 23

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




/**
     NOTE: Methods below this aren't particularly intended to be used directly and are only exposed
          for testing purposes
**/

/**
    This method returns the length of a given URL
 
    URL: An NSURL
 
    return: The length of the URL based on Twitter's TCO URLs
 **/
- (NSUInteger)lengthOfURL:(NSURL *)url;


/**
    This method calculates the length of a given string by calculating the length of its URLs
      according to Twitter
 
    text: A string to get the length of less URLs
 **/
- (NSUInteger)lengthOfTextCountingLinks:(NSString *)text;

@end
