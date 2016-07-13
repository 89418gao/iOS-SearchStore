//
//  LandscapeViewController.m
//  StoreSearch
//
//  Created by Shuyan Guo on 6/7/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "LandscapeViewController.h"
#import "SearchResult.h"
#import <AFNetworking/UIButton+AFNetworking.h>
#import "DetailViewController.h"

@interface LandscapeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation LandscapeViewController{
    BOOL _firstTime;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        _firstTime = YES;
    }
    return self;
}

-(void)dealloc {
    for(UIButton *button in _scrollView.subviews){
        [button cancelImageDownloadTaskForState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
    _pageControl.numberOfPages = 0;
    
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if(!_firstTime) return;
    
    _firstTime = NO;
    if(!_search) return;
        
  
    if(_search.isLoading){
        [self showSpinner];
        return;
    }
    if(_search.searchResults.count == 0){
        [self showNothingFound];
    }else{
        [self tileButtons];
    }
    
}
-(void)showNothingFound{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = NSLocalizedString(@"Nothing Found", @"search results: nothing found");
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    label.center = self.view.center;
    [self.view addSubview:label];
    
}
-(void)showSpinner{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.center = self.view.center;
    spinner.tag = 1000;
    [self.view addSubview:spinner];
    [spinner startAnimating];
}
-(void)searchDone {
    [[self.view viewWithTag:1000] removeFromSuperview];
    if(_search.searchResults.count == 0){
        [self showNothingFound];
    }else {
        [self tileButtons];
    }
}

-(void)downloadImageForSearchresult: (SearchResult *)result andPlaceOnButton:(UIButton *)button {
    
    NSURL *url = [NSURL URLWithString:result.artworkURL100];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
//    to prevent onwership cycle, prevent possible memory leak
    __weak UIButton *weakButton = button;
    
    [button setImageForState:UIControlStateNormal withURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        UIImage *unscaledImage = [UIImage imageWithCGImage:image.CGImage scale:1.4f orientation:image.imageOrientation];
        [weakButton setImage:unscaledImage forState:UIControlStateNormal];
        
    } failure:nil];
}
-(void)tileButtons {
    int colsPerPage = 5;
    CGFloat itemWidth = 133.0f;
    CGFloat x = 1.0f;
    CGFloat extraSpace = 2.0f;
    
    CGFloat viewWidth = self.view.bounds.size.width;
    if(viewWidth > 667.0f){
        colsPerPage = 6;
        itemWidth = 122.0f;
        x = 2.0f;
        extraSpace = 4.0f;
    }
    const CGFloat itemHeight = 106.0f;
    const CGFloat buttonSize = 100.0f;
    const CGFloat marginHorz = (itemWidth - buttonSize)/2.0f;
    const CGFloat marginVert = (itemHeight - buttonSize)/2.0f;
    
    int index = 0;
    int row = 0;
    int col = 0;
    
    for(SearchResult *result in _search.searchResults){
//        set up the button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x+marginHorz, 20.0f+marginVert+row*itemHeight,buttonSize, buttonSize);
        [button setBackgroundImage:[UIImage imageNamed:@"LandscapeButton"] forState:UIControlStateNormal];
        [self downloadImageForSearchresult:result andPlaceOnButton:button];
//        the use of tag: when user click one button, use tag to get the search result index
        button.tag = index + 2000;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_scrollView addSubview:button];
        
        index++;
        row++;
        if(row==3){
            row = 0;
            col++;
            x += itemWidth;
            if(col == colsPerPage){
                col = 0;
                x+= extraSpace;
            }
        }
        
    }
    int buttonsPerPage = colsPerPage*3;
    int pageNumber = ceilf(_search.searchResults.count/(float)buttonsPerPage);
    _scrollView.contentSize = CGSizeMake((self.view.bounds.size.width*pageNumber), self.view.bounds.size.height);
    
    
    _pageControl.numberOfPages = pageNumber;
    _pageControl.currentPage = 0;
    
}
-(void)buttonPressed:(UIButton *)button {
    
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    SearchResult *result = _search.searchResults[button.tag - 2000];
    [detailVC presentInParentVC:self];
    detailVC.searchResult = result;
    
}


-(void)presentInParentVC:(UIViewController *)parentVC{
    
    self.view.frame = parentVC.view.bounds;
    self.view.alpha = 0.0;
    [parentVC.view addSubview:self.view];
    [parentVC addChildViewController:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self didMoveToParentViewController:parentVC];
    }];
}
-(void)dismissFromParentVC {
    [self didMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.view.bounds.size.width;
    int currentPage = (scrollView.contentOffset.x + width/2.0f) / width;
    _pageControl.currentPage = currentPage;
}

- (IBAction)pageChanged:(UIPageControl *)sender {
    _scrollView.contentOffset = CGPointMake(sender.currentPage * self.view.bounds.size.width, 0);
}


@end
