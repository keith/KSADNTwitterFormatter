//
//  KSADNTwitterFormatter.m
//
//  Created by Keith Smiley @smileykeith
//

#import "KSADNTwitterFormatter.h"

@interface KSADNTwitterFormatter ()

@property (nonatomic, strong) NSDataDetector *detector;
@property (nonatomic, strong) NSURL *dummyURL;

@end


@implementation KSADNTwitterFormatter

+ (KSADNTwitterFormatter *)shared
{
    static KSADNTwitterFormatter *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[KSADNTwitterFormatter alloc] init];
    });
    
    return shared;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink error:nil];
    self.dummyURL = [NSURL URLWithString:@"https://thelongestURLpossibletobesafe.com"];
    
    return self;
}

#pragma mark

- (NSString *)formatTwitterStringWithString:(NSString *)post andURL:(NSURL *)url
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

- (NSUInteger)twitterLengthOfString:(NSString *)string
{
    NSString *formattedString = [self formatTwitterStringWithString:string andURL:self.dummyURL];
    return [self lengthOfTextCountingLinks:formattedString];
}

#pragma mark - Helper Methods

- (NSUInteger)lengthOfTextCountingLinks:(NSString *)text
{
    NSUInteger postLength = [text length];
    NSArray *matches = [self.detector matchesInString:text options:0 range:NSMakeRange(0, postLength)];

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
    
    return postLength;
}

- (NSUInteger)lengthOfURL:(NSURL *)url
{
    if (url.absoluteString.length < TCO_HTTP_LENGTH) {
        return url.absoluteString.length;
    }
    
    if ([[url.scheme lowercaseString] isEqualToString:@"https"]) {
        return TCO_HTTPS_LENGTH;
    }
    
    return TCO_HTTP_LENGTH;
}

@end
