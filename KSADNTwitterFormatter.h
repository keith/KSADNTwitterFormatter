//
//  KSADNTwitterFormatter.h
//  A simple helper method for reformatting ADN posts to Tweets depending on their length
//
//  Created by Keith Smiley @smileykeith
//

#import <Foundation/Foundation.h>

@interface KSADNTwitterFormatter : NSObject

/**
   This method receives the users string to be reformatted for twitter and the URL of the ADN post
    in the case it's too long for twitter and needs to be appended.

    String: The text you want to be converted for twitter

    URL: The URL of the ADN post, appended when the text is too long
 **/
+ (NSString *)formatTwitterStringWithString:(NSString *)string andURL:(NSURL *)url;

@end
