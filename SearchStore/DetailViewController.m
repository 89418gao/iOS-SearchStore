//
//  DetailViewController.m
//  StoreSearch
//
//  Created by Shuyan Guo on 6/6/16.
//  Copyright © 2016 GG. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GradientView.h"
#import "MenuViewController.h"
#import <MessageUI/MessageUI.h>

@interface DetailViewController () <MFMailComposeViewControllerDelegate>
{
    GradientView *_gradientView;
}

@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;

@property (strong, nonatomic) MenuViewController *menuVC;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *priceImage = [[UIImage imageNamed:@"PriceButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    priceImage = [priceImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.priceButton setBackgroundImage:priceImage forState:UIControlStateNormal];
    
    self.view.tintColor = [UIColor colorWithRed:20/255.0f
                                          green:160/255.0f blue:160/255.0f alpha:1.0f];
    self.popView.layer.cornerRadius = 10.0f;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
        
        _popView.hidden = YES;
        self.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(menuButtonPressed:)];
        
    }else{
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        tapRecognizer.cancelsTouchesInView = NO;
        tapRecognizer.delegate = self;
        [self.view addGestureRecognizer:tapRecognizer];
    }
    
}

-(void)menuButtonPressed:(UIBarButtonItem *)sender
{

    if(!_menuVC){
        _menuVC = [[MenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _menuVC.modalPresentationStyle = UIModalPresentationPopover;
        _menuVC.detailViewController = self;
    }
    _menuVC.popoverPresentationController.delegate = (id)self;
    _menuVC.popoverPresentationController.barButtonItem = sender;
    [self presentViewController:_menuVC animated:YES completion:nil];
    
}


-(void)setSearchResult:(SearchResult *)newsearchResult {
    if(_searchResult != newsearchResult) {
        _searchResult = newsearchResult;
        
        if([self isViewLoaded]){
            [self updateUI];
        }
    }
}

-(void)updateUI {
    
    _nameLabel.text = _searchResult.name;
    _artistLabel.text = _searchResult.artistName==nil? NSLocalizedString(@"Unknown", @"artist name: unknown"):_searchResult.artistName;
    _kindLabel.text = [_searchResult kindForDisplay];
    _genreLabel.text = _searchResult.genre;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:_searchResult.currency];
    
    NSString *priceText;
    if([_searchResult.price floatValue] == 0.0f){
        priceText = NSLocalizedString(@"Free", @"price: free");
    }else {
        priceText = [formatter stringFromNumber:_searchResult.price];
    }
    [_priceButton setTitle:priceText forState:UIControlStateNormal];
   
    [_artworkImageView setImageWithURL:[NSURL URLWithString:_searchResult.artworkURL100] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        _popView.hidden = NO;
            //    bounce animation for the view(for the pop view)
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation
                                                    animationWithKeyPath:@"transform.scale"];
        bounceAnimation.duration = 0.4;
        bounceAnimation.delegate = _popView;
        //    set frame scale values
        bounceAnimation.values = @[ @0.7, @1.2, @0.9, @1.0 ];
        //    set duration for each scale
        bounceAnimation.keyTimes = @[ @0.0, @0.334, @0.666, @1.0 ];
        bounceAnimation.timingFunctions = @[
                                                [CAMediaTimingFunction
                                                 functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                                [CAMediaTimingFunction
                                                 functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                                [CAMediaTimingFunction
                                                 functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_popView.layer addAnimation:bounceAnimation
                                   forKey:@"bounceAnimation"];
    }
    
    
}
-(void)dealloc {
    [_artworkImageView cancelImageDownloadTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}

- (IBAction)close:(UIButton *)sender {
    [self dismissFromParentVC];
}

-(void)presentInParentVC:(UIViewController *)parentVC {
    _gradientView = [[GradientView alloc] initWithFrame:parentVC.view.frame];
    [parentVC.view addSubview:_gradientView];
   
    self.view.frame = parentVC.view.bounds;
    [parentVC.view addSubview:self.view];
    [parentVC addChildViewController:self];
    
//    fade in animation for the gradientView
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = 0.1;
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @0.2f;
    [_gradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    
//    bounce animation for the view(for the pop view)
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation
                                            animationWithKeyPath:@"transform.scale"];
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
//    set frame scale values
    bounceAnimation.values = @[ @0.7, @1.2, @0.9, @1.0 ];
//    set duration for each scale
    bounceAnimation.keyTimes = @[ @0.0, @0.334, @0.666, @1.0 ];
    bounceAnimation.timingFunctions = @[
                                        [CAMediaTimingFunction
                                         functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction
                                         functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction
                                         functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:bounceAnimation
                           forKey:@"bounceAnimation"];

}

-(void)dismissFromParentVC {
   
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [UIView animateWithDuration:0.3 animations:^{
        _gradientView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_gradientView removeFromSuperview];
    }];
    
}
- (IBAction)openInStore:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_searchResult.storeURL]];
}

#pragma mark - UISplitViewController delegate 


-(void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    if(displayMode == UISplitViewControllerDisplayModePrimaryHidden){
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"❮ Search" style:UIBarButtonItemStylePlain target:svc.displayModeButtonItem.target action:svc.displayModeButtonItem.action];
        [self.navigationItem setLeftBarButtonItem:button];
        
    }else {
        [self.navigationItem setLeftBarButtonItem:nil];
    }

}


-(void)sendSupportEmail {
    [_menuVC dismissViewControllerAnimated:YES completion:nil];
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    if(controller){
        [controller setSubject:NSLocalizedString(@"Support Request", @"Support request")];
        [controller setToRecipients:@[@"89418.gao@students.itu.edu"]];
        controller.mailComposeDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposerViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
