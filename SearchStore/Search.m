//
//  Search.m
//  StoreSearch
//
//  Created by Shuyan Guo on 6/8/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "Search.h"
#import "SearchResult.h"
#import <AFNetworking/AFNetworking.h>

@interface Search ()
@property (readwrite,nonatomic,strong) NSMutableArray *searchResults;

@end

@implementation Search {
    NSURLSessionDataTask *_dataTask;
}

-(void)performSearchForText:(NSString *)text category:(NSInteger)category completion:(void (^)(BOOL success))completion
{
    _isLoading = YES;
    _searchResults = [NSMutableArray arrayWithCapacity:10];
        
    NSURL *url = [self urlWithSearchText:text category:category];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        [self parseDictionary:responseObject];
        _isLoading = NO;
        completion(YES);
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isLoading = NO;
        completion(NO);
    }];
    
}

-(NSURL *)urlWithSearchText:(NSString *)searchText category:(NSInteger)category{
    
    NSString *categoryName;
    
    switch (category) {
        case 0: categoryName = @"software"; break;
        case 1: categoryName = @"song"; break;
        case 2: categoryName = @"album"; break;
        case 3: categoryName = @"ebook"; break;
    }
    
    NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    
    NSArray *arLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *first_language = [arLanguages objectAtIndex:0];
    NSString *language = [first_language hasPrefix:@"zh-Hans"]?@"zh_CN":first_language;
    
    NSString *escapedSearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=200&entity=%@&lang=%@&country=%@", escapedSearchText, categoryName, language, countryCode];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

-(void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *array = dictionary[@"results"];
    if(array == nil){
        return;
    }
    for(NSDictionary *resultDict in array){
        SearchResult *searchResult;
        
        NSString *wrapperType = resultDict[@"wrapperType"];
        NSString *kind = resultDict[@"kind"];
        NSString *collectionType = resultDict[@"collectionType"];
        
        if([wrapperType isEqualToString:@"software"]){
            searchResult = [self parseSoftware:resultDict];
        }else if([kind isEqualToString:@"song"]){
            searchResult = [self parseSong:resultDict];
        }else if([collectionType isEqualToString:@"Album"]){
            searchResult = [self parseAlbum:resultDict];
        }else if([kind isEqualToString:@"ebook"]){
            searchResult = [self parseEBook:resultDict];
        }
        
        if(searchResult != nil){
            [_searchResults addObject:searchResult];
        }
    }
}

- (SearchResult *)parseSong:(NSDictionary *)dict {
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dict[@"trackName"];
    searchResult.artistName = dict[@"artistName"];
    searchResult.artworkURL60 = dict[@"artworkUrl60"];
    searchResult.artworkURL100 = dict[@"artworkUrl100"];
    searchResult.storeURL = dict[@"trackViewUrl"];
    searchResult.kind = dict[@"kind"];
    searchResult.price = dict[@"trackPrice"];
    searchResult.currency = dict[@"currency"];
    searchResult.genre = dict[@"primaryGenreName"];
    
    return searchResult;
    
}
- (SearchResult *)parseAlbum:(NSDictionary *)dict {
    
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dict[@"collectionName"];
    searchResult.artistName = dict[@"artistName"];
    searchResult.artworkURL60 = dict[@"artworkUrl60"];
    searchResult.artworkURL100 = dict[@"artworkUrl100"];
    searchResult.storeURL = dict[@"collectionViewUrl"];
    searchResult.kind = dict[@"collectionType"];
    searchResult.price = dict[@"trackPrice"];
    searchResult.currency = dict[@"currency"];
    searchResult.genre = dict[@"primaryGenreName"];
    
    return searchResult;
    
}

- (SearchResult *)parseSoftware:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"wrapperType"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"genres"][0];
    return searchResult;
}
- (SearchResult *)parseEBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = [(NSArray *)dictionary[@"genres"]
                          componentsJoinedByString:@", "];
    return searchResult;
}

@end
