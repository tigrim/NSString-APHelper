//
//  NSString+APHelper.h
//  APLocalEventsGoogle
//
//  Created by  mac on 26.05.16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (APHelper)

#pragma mark -  Work with String

// @"   car   bus cat     " -> @"car   bus cat"
- (NSString *)trim;

// @"   car   bus " -> @"car bus"
- (NSString *)removingWhitespaces;
- (NSString *)removingNumbers;
- (NSString *)removingAllExeptNumbers;
- (NSString *)reverse;

// aa___ddd  -> aaBbb
- (NSString *)underscoresToCamelCase:(NSString*)s;

//$ InternalCapitalization -> $_internal_capitalization
- (NSString *)camelCaseToUnderscores:(NSString *)s;
- (NSString *)capitalizeFirst:(NSString *)s;

- (BOOL)isBlank;
- (BOOL)isValid;

- (NSUInteger)countNumberOfWords;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidURL;

@end
