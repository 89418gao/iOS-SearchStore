//
//  SearchViewController.m
//  StoreSearch
//
//  Created by Shuyan Guo on 6/2/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "SearchViewController.h"
#import "Search.h"
#import "SearchResultCell.h"
#import <AFNetworking/AFNetworking.h>
#import "DetailViewController.h"
#import "LandscapeViewController.h"


static NSString * const SearchResultCellIdentifier = @"SearchResultCell";
static NSString * const NothingFoundCellIdentifier = @"NothingFoundCell";
static NSString * const LoadingCellIdentifier = @"LoadingCell";


@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController {
    
    Search *_search;

    __weak LandscapeViewController *_landscapeVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"Search";
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 0, 0);
    
//  load the SearchResultCell nib
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    self.tableView.rowHeight = 80;
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    cellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        [self.searchBar becomeFirstResponder];        
    }
    
    
}
- (BOOL)prefersStatusBarHidden{
    return false;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(!_search) return 0;
    if(_search.isLoading) return 1;
    if(_search.searchResults.count == 0) return 1;
    
    return _search.searchResults.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_search.isLoading) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier forIndexPath:indexPath];
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:100];
        
        [spinner startAnimating];
        
        return cell;
    }
    
    if(_search.searchResults.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier forIndexPath:indexPath];
    }
    
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier forIndexPath:indexPath];
        
    SearchResult *searchResult = _search.searchResults[indexPath.row];
    [cell configureSearchResult:searchResult];
    
    return cell;
    
}



#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.searchBar resignFirstResponder];
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        [detailVC presentInParentVC:self];
        detailVC.searchResult = _search.searchResults[indexPath.row];
        
        _detailVC = detailVC;
        
    }else {
        _detailVC.searchResult = _search.searchResults[indexPath.row];
    }
    

}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_search.searchResults.count == 0 || _search.isLoading) {
        return nil;
    }else {
        return indexPath;
    }
}


#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self performSearch];
}

- (void)performSearch {
    
    if(_searchBar.text.length > 0){
        _search = [[Search alloc] init];
        [_search performSearchForText:_searchBar.text category:_segmentedControl.selectedSegmentIndex completion:^(BOOL success) {
            if(!success){
                [self showNetworkError];
            }
            [_tableView reloadData];
            [_landscapeVC searchDone];
        }];
    }
    [_tableView reloadData];
    [_searchBar resignFirstResponder];
    
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

-(void)showNetworkError {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Whoops...", @"Error alert: title") message:NSLocalizedString(@"There was an error reading from the iTunes Store. Please try again.", @"Error alert: content") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"cancel button title") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)segmentChange:(UISegmentedControl *)sender {
    
    if(_search != nil) {
        [self performSearch];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if(fabsf((float)size.height) < fabsf((float)size.width)) {
        [_searchBar resignFirstResponder];
        [_detailVC dismissFromParentVC];
        
        if(!_landscapeVC){
            // create an LandscapeVC, and assign it to the self.landscapeVC
            LandscapeViewController *landscapeVC = [[LandscapeViewController alloc] initWithNibName:@"LandscapeViewController" bundle:nil];
            landscapeVC.search = _search;
            _landscapeVC = landscapeVC;
            [_landscapeVC presentInParentVC:self];
        }
    }else {
        if(_landscapeVC){
            [_landscapeVC dismissFromParentVC];
            _landscapeVC = nil;
        }
    }
}


@end
