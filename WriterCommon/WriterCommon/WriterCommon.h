//
//  WriterCommon.h
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-08-29.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import Cocoa;
#endif

//! Project version number for WriterCommon.
FOUNDATION_EXPORT double WriterCommonVersionNumber;

//! Project version string for WriterCommon.
FOUNDATION_EXPORT const unsigned char WriterCommonVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WriterCommon/PublicHeader.h>


