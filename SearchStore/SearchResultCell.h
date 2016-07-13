//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by Shuyan Guo on 6/2/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

- (void)configureSearchResult:(SearchResult *)searchResult;

@end
