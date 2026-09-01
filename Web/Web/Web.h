//
//  Web.h
//  Web
//
//  Created by Sébastien Hamel on 2015-02-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import Cocoa;
#endif

//! Project version number for Web.
FOUNDATION_EXPORT double WebVersionNumber;

//! Project version string for Web.
FOUNDATION_EXPORT const unsigned char WebVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Web/PublicHeader.h>


