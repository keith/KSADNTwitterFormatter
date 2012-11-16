//
//  KSADNTwitterFormatter.m
//
//  Created by Keith Smiley @smileykeith
//

#import "KSADNTwitterFormatter.h"

// The maximum length for a tweet. Probably could've hard coded
#define TWEET_LENGTH 140

// The maximum length when the text is too long for a tweet and must be reduced
#define MAX_POST_LENGTH 115

//
// The length of t.co links as it stands today see:
// https://dev.twitter.com/docs/tco-link-wrapper/faq#Will_t.co-wrapped_links_always_be_the_same_length
//
#define TCO_LINK_LENGTH 20

@implementation KSADNTwitterFormatter

+ (NSString *)formatTwitterStringWithString:(NSString *)post andURL:(NSURL *)url
{
    // If the post isn't too long, return it immediately
    if (post.length <= TWEET_LENGTH) {
        return post;
    }

    // Setup twitterText with the original post text
    NSString *twitterText = post;
    
    // The length of the post
    NSUInteger postLength = [twitterText length];
    
    // The length of t.co links
    NSNumber *linkLength = [NSNumber numberWithInt:TCO_LINK_LENGTH];
    
    // Setup NSDataDetector
    NSError *error = nil;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:&error];
    
    // Check to see if the data detector failed
    if (error) {
        NSLog(@"Error creating Data Detector: %@ continuing...", [error localizedDescription]);
    } else {
        // Check for URLs in the original post
        NSArray *matches = [detector matchesInString:twitterText options:0 range:NSMakeRange(0, postLength)];
        
        //
        // If there are URLs and they're longer than the default t.co link length reduce the length variable because the URLs will be automatically shortened by Twitter
        // If they are shorter than the default twitter length leave them alone, they will appear as is
        //
        if (matches.count > 0) {
            for (NSTextCheckingResult *result in matches) {
                if (result.URL.absoluteString.length > linkLength.integerValue) {
                    postLength -= result.URL.absoluteString.length;
                    postLength += linkLength.integerValue;
                }
            }
        }
    }
    
    // If the post's length is greater than the Twitter character limit reduce it and append the URL to the post on App.net
    if (postLength > TWEET_LENGTH) {
        // Break the post at the spaces
        NSArray *stringComponents = [twitterText componentsSeparatedByString:@" "];
        
        // Reset the Tweet text
        twitterText = @"";
        
        // Loop through each of the parts from the post
        for (NSString *component in stringComponents) {
            // Check to see if the post text length + the item that would be added + the length of the space that would be added is greater than the maximum allowed post length at this point
            if (twitterText.length + component.length + 1 > MAX_POST_LENGTH) {
                break;
            } else {
                // If not append the component after a space
                twitterText = [twitterText stringByAppendingFormat:@" %@", component];
            }
        }
        
        // Append elipses a newline and the URL to the App.net post
        twitterText = [twitterText stringByAppendingFormat:@"...\n%@", [url absoluteString]];
    }
    
    return twitterText;
}

@end
