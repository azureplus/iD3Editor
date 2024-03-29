//
//  NSString.m
//  iD3
//
//  Created by Qiang Yu on 7/31/14.
//  Copyright (c) 2014 xboxng.com. All rights reserved.
//

#import "NSString_Filename.h"

#define TAG_ARTIST @":a"
#define TAG_ALBUM @":A"
#define TAG_TITLE @":t"
#define TAG_COMPOSER @":c"
#define TAG_GENRE @":g"
#define TAG_TRACK @":T"
#define TAG_YEAR @":y"
#define TAG_COLON @"::"
@implementation NSString(FileName)

+(NSString *) formatString:(NSString *) str byReplacing:(NSString *) from with:(NSString *) to andCapitalization:(NSUInteger)cap {
    str = [str stringByReplacingOccurrencesOfString:from withString:to];
    
    if (cap == 1) {
        str =  [str lowercaseStringWithLocale:[NSLocale currentLocale]];
    } else if (cap == 2) {
        str = [str uppercaseStringWithLocale:[NSLocale currentLocale]];
    } else if (cap == 3) {
        str = [str capitalizedStringWithLocale:[NSLocale currentLocale]];
    }

    return str;
}

//
//:A - album
//:a - artist
//:t - title
//:c - composer
//:g - genre
//:T - track
//:y - year
//:: - : itself
//
+(NSString *) fromTag:(TagEntity *)tag withPattern:(NSString *)pattern andTrackSize:(NSUInteger)trackSize {
    NSMutableDictionary * frames = [NSMutableDictionary dictionaryWithCapacity:8];
    if (tag.artist) {
        frames[@"artist"] = tag.artist;
    }
    
    if (tag.album) {
        frames[@"album"] = tag.album;
    }
    
    if (tag.title) {
        frames[@"title"] = tag.title;
    }
    
    if (tag.composer) {
        frames[@"composer"] = tag.composer;
    }
    
    if (tag.genre) {
        frames[@"genre"] = tag.genre;
    }
    
    if (tag.track) {
        frames[@"track"] = tag.track;
    }
    
    if (tag.year) {
        frames[@"year"] = tag.year;
    }
    return [NSString fromFrames:frames withPattern:pattern andTrackSize:trackSize];
}

+(NSString *) fromFrames: (NSDictionary *)frames withPattern:(NSString *)pattern andTrackSize:(NSUInteger)trackSize {
    NSMutableString * rv = [NSMutableString stringWithCapacity:32];
    NSUInteger pl = [pattern length];
    NSUInteger index = 0;
    
    while (index < pl) {
        unichar ch = [pattern characterAtIndex:index];
        if (ch == ':' && index < pl - 1) {
            ch = [pattern characterAtIndex:index + 1];
            NSString * value = nil;
            switch (ch) {
                case 'a':
                    value = frames[@"artist"];
                    break;
                case 'A':
                    value = frames[@"album"];
                    break;
                case 't':
                    value = frames[@"title"];
                    break;
                case 'T':
                    if (trackSize == 0) {
                        value = frames[@"track"];
                    } else {
                        NSMutableString * tmpValue = [NSMutableString stringWithString:frames[@"track"]];
                        if (trackSize > tmpValue.length) {
                            for (int i = (int)(trackSize - tmpValue.length); i > 0; i--) {
                                [tmpValue insertString:@"0" atIndex:0];
                            }
                        }
                        value = tmpValue;
                    }
                    break;
                case 'c':
                    value = frames[@"composer"];
                    break;
                case 'g':
                    value = frames[@"genre"];
                    break;
                case 'y':
                    value = frames[@"year"];
                    break;
                case ':':
                    value = @":";
                    break;
            }
            
            if (value) {
                [rv appendString:value];
            }
            index += 2;
        } else {
            [rv appendString:[NSString stringWithCharacters:&ch length:1]];
            index += 1;
        }
    }
    
    return rv;
    
}

-(NSDictionary *) parse:(NSString *)pattern {
    NSDictionary * dic = [self _parseWithPattern:pattern];
    NSMutableDictionary * rv = [NSMutableDictionary dictionaryWithCapacity:8];
    for (NSString * key in dic) {
        //value cannot be null using current algorithm
        NSString * value = [dic objectForKey:key];
        if ([key isEqualTo:TAG_ARTIST]) {
            [rv setObject:value forKey:@"artist"];
        } else if ([key isEqualTo:TAG_ALBUM]) {
            [rv setObject:value forKey:@"album"];
        } else if ([key isEqualTo:TAG_TITLE]) {
            [rv setObject:value forKey:@"title"];
        } else if ([key isEqualTo:TAG_COMPOSER]) {
            [rv setObject:value forKey:@"composer"];
        } else if ([key isEqualTo:TAG_GENRE]) {
            [rv setObject:value forKey:@"genre"];
        } else if ([key isEqualTo:TAG_TRACK]) {
            [rv setObject:value forKey:@"track"];
        } else if ([key isEqualTo:TAG_YEAR]) {
            [rv setObject:value forKey:@"year"];
        }
    }
    
    return rv;
}

// Determine if two chars are compitable or not
// return -2 not match ::
// return -1 not match
// return 1 match with single char
// return 2 match with :x
-(NSInteger) _matchAt:(NSUInteger) c and:(NSUInteger) r with:(NSString *)pattern {
    unichar ch1 = [self characterAtIndex:c - 1];
    unichar ch2 = [pattern characterAtIndex:r - 1];
    NSUInteger pl = [pattern length];
    
    if (ch2 == ':' && r + 1 <= pl) {
        unichar ch3 = [pattern characterAtIndex: r];
        if (ch3 != ':') {
            return 2;
        } else if (ch1 == ':') {
            return 2;
        } else {
            return -2;
        }
    }
    
    return ch1 == ch2 ? 1 : -1;
}

-(NSDictionary *) _parseWithPattern:(NSString *)pattern {
    NSMutableDictionary * tag = [NSMutableDictionary dictionaryWithCapacity:5];
    
    // find out matches with DP
    // DP[r][c] = false if chars at r of pattern and at c of self dont match
    // otherwise, DP[r][c] = DP[r - 1][c - 1] or DP[r - 1][c] (if char at r - 1 of pattern is wildcard)
    NSUInteger l1 = [self length], l2 = [pattern length];
    BOOL matches[l2 + 1][l1 + 1];
    
    // track matches
    // 1 means DP[r][c] = DP[r - 1][c]
    // 2 means DP[r][c] = DP[r - 1][c - 1]
    int track[l2 + 1][l1 + 1];
    
    for (NSUInteger c = 0; c <= l1; c++) {
        matches[0][c] = YES;
        track[0][c] = 0;
    }
    
    for (NSUInteger r = 1; r <= l2; r++) {
        matches[r][0] = NO;
        track[r][0] = 0;
    }
    
    NSUInteger r = 1, c = 1;
    
    // DP
    while (c <= l1) {
        r = 1;
        while (r <= l2) {
            track[r][c] = 0;
            NSInteger match = [self _matchAt:c and:r with:pattern];
            switch(match) {
                case -1:
                    matches[r][c] = NO;
                    r++;
                    break;
                case -2:
                    matches[r][c] = NO;
                    matches[r + 1][c] = NO;
                    r += 2;
                    break;
                case 1:
                    matches[r][c] = matches[r - 1][c - 1];
                    track[r][c] = 2;
                    r++;
                    break;
                case 2:
                    matches[r][c] = matches[r + 1][c] = matches[r][c - 1] | matches[r - 1][c - 1];
                    if (matches[r][c - 1]) {
                        track[r][c] = track[r + 1][c] = 1;
                    } else if (matches[r - 1][c - 1]) {
                        track[r][c] = track[r + 1][c] = 2;
                    }
                    r += 2;
                    break;
            }
        }
        c++;
    }
    
    // find the last match which we uses to find values matched
    r = pattern.length;
    c = self.length;
    
    while (c>0 && !matches[r][c]) {
        c--;
    }
    
    if (c==0) {
        return tag;
    }
    
    NSUInteger prevC = c;
    while (c>0 && r>0) {
        if (matches[r][c]) {
            if (track[r][c] == 1) {
                c = c - 1;
            } else if (r == 1 || [pattern characterAtIndex:r - 2] != ':') {
                r = r - 1;
                c = c - 1;
                prevC = c;
            } else {
                NSRange rangeC = NSMakeRange(c - 1, prevC - c + 1);
                NSString * value = [self substringWithRange:rangeC];
                NSRange rangeR = NSMakeRange(r - 2, 2);
                NSString * key = [pattern substringWithRange:rangeR];
                [tag setObject:value forKey:key];
                r = r - 2;
                c = c - 1;
                prevC = c;
            }
        } else if (r == 1 || [pattern characterAtIndex:r - 2] != ':') {
                r = r - 1;
        } else {
                NSRange rangeC = NSMakeRange(c, prevC - c);
                NSString * value = [self substringWithRange:rangeC];
                NSRange rangeR = NSMakeRange(r - 2, 2);
                NSString * key = [pattern substringWithRange:rangeR];
                [tag setObject:value forKey:key];
                r = r - 2;
        }
    }
    
    return tag;
}
@end
