//
//  SearchResultCell.m
//  StoreSearch
//
//  Created by Shuyan Guo on 6/2/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "SearchResultCell.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.5f];
    self.selectedBackgroundView = selectedView;
   

}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [_artworkImageView cancelImageDownloadTask];
    _nameLabel.text = nil;
    _artistNameLabel.text = nil;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureSearchResult:(SearchResult *)searchResult {
    
    _nameLabel.text = searchResult.name;
    
    NSString *artistName = searchResult.artistName;
    if(searchResult.artistName == nil) {
        artistName = NSLocalizedString(@"Unknown", @"artist name: unknown");
    }
    NSString *kind = [searchResult kindForDisplay];
    _artistNameLabel.text = [NSString stringWithFormat:@"%@ %@",kind,artistName];
    
    [_artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL100] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
}

@end
