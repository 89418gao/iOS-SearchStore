//
//  SearchResult.m
//  StoreSearch
//
//  Created by Shuyan Guo on 6/2/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult

-(NSComparisonResult)compareName:(SearchResult *)other {
    return [self.name localizedStandardCompare:other.name];
}

-(NSString *)kindForDisplay {
    if([_kind isEqualToString:@"Album"]){
        return NSLocalizedString(@"Album", @"Localized kind: Album");
    }
    if([_kind isEqualToString:@"audiobook"]){
        return NSLocalizedString(@"Audio Book", @"Localized kind: Audio Book");
    }
    if([_kind isEqualToString:@"book"]){
        return NSLocalizedString(@"Book", @"Localized kind: Book");
    }
    if([_kind isEqualToString:@"ebook"]){
        return NSLocalizedString(@"E-Book", @"Localized kind: E-Book");
    }
    if([_kind isEqualToString:@"feature-movie"]){
        return NSLocalizedString(@"Movie", @"Localized kind: Movie");
    }
    if([_kind isEqualToString:@"music-video"]){
        return NSLocalizedString(@"MV", @"Localized kind: MV");
    }
    if([_kind isEqualToString:@"podcast"]){
        return NSLocalizedString(@"Podcast", @"Localized kind: Podcast");
    }
    if([_kind isEqualToString:@"software"]){
        return NSLocalizedString(@"App", @"Localized kind: App");
    }
    if([_kind isEqualToString:@"song"]){
        return NSLocalizedString(@"Song", @"Localized kind: Song");
    }
    if([_kind isEqualToString:@"tv-episode"]){
        return NSLocalizedString(@"TV Episode", @"Localized kind: TV Episode");
    }
    return _kind;
}

@end
