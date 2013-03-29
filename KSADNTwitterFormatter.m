//
//  KSADNTwitterFormatter.m
//
//  Created by Keith Smiley @smileykeith
//

#import "KSADNTwitterFormatter.h"

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

@implementation KSADNTwitterFormatter

+ (NSString *)formatTwitterStringWithString:(NSString *)post andURL:(NSURL *)url
{
    // If the post isn't too long, return it immediately
    if (post.length <= TWEET_LENGTH) {
        return post;
    }

    // Setup twitterText with the original post text
    NSString *twitterText = [post copy];

    // Get the post's length
    NSUInteger postLength = [self lengthOfTextCountingLinks:twitterText];
    
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
                twitterText = [twitterText stringByAppendingFormat:@"%@ ", component];
            }
        }
        
        // Append elipses a newline and the URL to the App.net post
        if ([[url absoluteString] length] > 0) {
            // Remove the string's trailing space
            if ([twitterText hasSuffix:@" "]) {
                twitterText = [twitterText substringToIndex:twitterText.length - 1];
            }
            
            // Check to see if the string is empty (when the input is a gigantic space-less string)
            if ([twitterText length] < 1) {
                twitterText = [url absoluteString];
            } else { // Append the ADN url
                twitterText = [twitterText stringByAppendingFormat:@"...\n%@", [url absoluteString]];
            }
        }
    }
    
    return twitterText;
}

+ (NSUInteger)lengthOfURL:(NSURL *)url
{
    if (url.absoluteString.length < TCO_HTTP_LENGTH) {
        return url.absoluteString.length;
    }

    if ([url.scheme isEqualToString:@"https"]) {
        return TCO_HTTPS_LENGTH;
    }
    
    return TCO_HTTP_LENGTH;
}

+ (NSUInteger)twitterLengthOfString:(NSString *)string
{
    NSURL *dummyURL = [NSURL URLWithString:@"https://thelongestURLpossibletobesafe.com"];
    NSString *formattedString = [self formatTwitterStringWithString:string andURL:dummyURL];
    return [self lengthOfTextCountingLinks:formattedString];
}

+ (NSUInteger)lengthOfTextCountingLinks:(NSString *)text
{
    NSUInteger postLength = [text length];

    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink
                                                               error:&error];

    if (error) {
        NSLog(@"Error creating Data Detector: %@ continuing...", [error localizedDescription]);
    } else {
        NSArray *matches = [detector matchesInString:text options:0 range:NSMakeRange(0, postLength)];

        //
        // If there are URLs and they're longer than the default t.co link length reduce the length variable because the URLs will be automatically shortened by Twitter
        // If they are shorter than the default twitter length leave them alone, they will appear as is
        //
        if (matches.count > 0) {
            for (NSTextCheckingResult *result in matches) {
                // Subtract the link length
                postLength -= result.URL.absoluteString.length;
                
                // Get and the length of the URL based on current TCO lengths
                postLength += [self lengthOfURL:result.URL];
            }
        }
    }
    
    return postLength;
}

@end
