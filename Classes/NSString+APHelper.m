//
//  NSString+APHelper.m
//  APLocalEventsGoogle
//
//  Created by  mac on 26.05.16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "NSString+APHelper.h"

/** Need to determine device platform & processor cores */
#import <sys/utsname.h>

/** Need to determine processor cores */
#include <mach/mach_host.h>

/** Need for MD5 & SHA hashes */
#import <CommonCrypto/CommonDigest.h>

/** Need to determine IP address */
#include <ifaddrs.h>
#include <arpa/inet.h>

/** Need for AES crypto */
#import <CommonCrypto/CommonCryptor.h>

/** Need for GZIP */
#import <zlib.h>

@implementation NSString (APHelper)

- (NSString *)removingWhitespaces {
    NSString *s = self;
    while ([s rangeOfString:@"  "].location != NSNotFound) {
      s = [s stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [s trim];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removingNumbers {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] componentsJoinedByString:@""];
}

- (NSString *)removingAllExeptNumbers {
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
}

- (BOOL)isBlank {
    return ([[self trim] isEqualToString:@""]) ? YES : NO;
}

//Checking if String is empty or nil

- (BOOL)isValid {
    return ([[self trim] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

- (NSString *)reverse {
    NSUInteger length = [self length];
    if (length < 2) {
        return self;
    }
    
    NSStringEncoding encoding = NSHostByteOrder() == NS_BigEndian ? NSUTF32BigEndianStringEncoding : NSUTF32LittleEndianStringEncoding;
    NSUInteger utf32ByteCount = [self lengthOfBytesUsingEncoding:encoding];
    uint32_t *characters = malloc(utf32ByteCount);
    if (!characters) {
        return nil;
    }
    
    [self getBytes:characters maxLength:utf32ByteCount usedLength:NULL encoding:encoding options:0 range:NSMakeRange(0, length) remainingRange:NULL];
    
    NSUInteger utf32Length = utf32ByteCount / sizeof(uint32_t);
    NSUInteger halfwayPoint = utf32Length / 2;
    for (NSUInteger i = 0; i < halfwayPoint; ++i) {
        uint32_t character = characters[utf32Length - i - 1];
        characters[utf32Length - i - 1] = characters[i];
        characters[i] = character;
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:utf32ByteCount encoding:encoding freeWhenDone:YES];
}


- (NSString *)underscoresToCamelCase:(NSString*)underscores {
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [underscores length]; idx += 1) {
        unichar c = [underscores characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

- (NSString *)camelCaseToUnderscores:(NSString *)input {
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSInteger idx = 0; idx < [input length]; idx += 1) {
        unichar c = [input characterAtIndex:idx];
        if ([uppercase characterIsMember:c]) {
            [output appendFormat:@"%s%C", (idx == 0 ? "" : "_"), (unichar)(c ^ 32)];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

- (NSString *)capitalizeFirst:(NSString *)s {
    if ([s length] == 0) {
        return s;
    }
    return [s stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                           withString:[[s substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
}

// Counts number of Words in String

- (NSUInteger)countNumberOfWords {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil]) {
        count++;
    }
    
    return count;
}

// If string contains substring

- (BOOL)containsString:(NSString *)subString {
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

// If my string starts with given string

- (BOOL)isBeginsWith:(NSString *)string {
    return ([self hasPrefix:string]) ? YES : NO;
}

// If my string ends with given string

- (BOOL)isEndssWith:(NSString *)string {
    return ([self hasSuffix:string]) ? YES : NO;
}

// Replace particular characters in my string with new character

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar {
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

// Get Substring from particular location to given lenght

- (NSString *)getSubstringFrom:(NSInteger)begin to:(NSInteger)end {
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}

// Add substring to main String

- (NSString *)addString:(NSString *)string {
    if (!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Remove particular sub string from main string

- (NSString *)removeSubString:(NSString *)subString {
    if ([self containsString:subString]) {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}


// If my string contains ony letters

- (BOOL)containsOnlyLetters {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers

- (BOOL)containsOnlyNumbers {
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers

- (BOOL)containsOnlyNumbersAndLetters {
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// Get String from array

+ (NSString *)getStringFromArray:(NSArray *)array {
    return [array componentsJoinedByString:@" "];
}

// Convert Array from my String

- (NSArray *)getArray {
    return [self componentsSeparatedByString:@" "];
}

// Get My Application Version number

+ (NSString *)getMyApplicationVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleVersion"];
    return version;
}

// Get My Application name

+ (NSString *)getMyApplicationName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}

// Convert string to NSData

- (NSData *)convertToData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// Get String from NSData

+ (NSString *)getStringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

// Is Valid Email

- (BOOL)isValidEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

// Is Valid Phone

- (BOOL)isValidPhoneNumber {
    NSString *regex = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

// Is Valid URL

- (BOOL)isValidURL {
    NSString *regex = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}


@end
