//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <stdint.h>
#include <stdio.h>

// Core Foundation
#include <CoreFoundation/CoreFoundation.h>

// Cryptography
#include <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 4096
CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath, size_t chunkSizeForReadingData);

#import "MobClick.h"