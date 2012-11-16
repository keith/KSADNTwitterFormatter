## KSADNTwitterFormatter

A simple class for taking [ADN](http://alpha.app.net/) posts and reformatting them to fit into Twitter's length restrictions, taking links into account.

-------------

## How to

Simply call:

	+ (NSString *)formatTwitterStringWithString:(NSString *)string andURL:(NSURL *)url;

Passing the two parameters,

1. The post text that you're planning on formatting
2. The response URL of your ADN post that will be appended to your Tweet if the post is too long.

-----------

## [CocoaPods](http://cocoapods.org/)

If you're using CocoaPods, which you should be, just add this to your podspec.

	pod 'KSADNTwitterFormatter', '~> 0.1.0'

-----------

### Issues 

Submit any issues you find through Github and I'll do what I can to fix them.
