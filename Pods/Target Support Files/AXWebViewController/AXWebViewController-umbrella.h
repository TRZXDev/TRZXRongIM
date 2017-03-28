#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AXWebViewController.h"
#import "AXWebViewControllerActivity.h"
#import "AXWebViewControllerActivityChrome.h"
#import "AXWebViewControllerActivitySafari.h"

FOUNDATION_EXPORT double AXWebViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char AXWebViewControllerVersionString[];

