//
//  LikeButtonDemoViewController.m
//  LikeButtonDemo
//
//  Created by Tom Brow on 6/27/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import "FacebookLikeViewDemoViewController.h"

@interface FacebookLikeViewDemoViewController () <FacebookLikeViewDelegate>

@end


@implementation FacebookLikeViewDemoViewController

@synthesize facebookLikeView=_facebookLikeView;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //_facebook = [[Facebook alloc] initWithAppId:@"158575400878173" andDelegate:self];
        //[self FacebookSetup];
        NSArray *m_Permissions =  [NSArray array];
        _facebook = [[FBSession alloc] initWithAppID:@"522087991179608"
                                         permissions:m_Permissions
                                     urlSchemeSuffix:nil
                                  tokenCacheStrategy:nil];
        [_facebook closeAndClearTokenInformation];
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    return self;
}

- (void)dealloc
{
    [_facebook release];
    [_facebookLikeView release];
    [super dealloc];
}


- (void) FacebookSetup
{
    /*
    if (_facebook == nil) {
        _facebook = [[FBSession alloc] initWithAppID:@"522087991179608"
                                          permissions:m_Permissions
                                      urlSchemeSuffix:nil
                                   tokenCacheStrategy:nil];
        
    }
    else{
        
        [_facebook closeAndClearTokenInformation];
    }
    
    
    if(FALSE == YES)
	{
        
        [_facebook closeAndClearTokenInformation];
        _facebook = [[FBSession alloc] initWithAppID:@"522087991179608"
                                          permissions:m_Permissions
                                      urlSchemeSuffix:nil
                                   tokenCacheStrategy:nil];
        //self.m_Token = nil;
        NSLog(@"[Facebook] Recreate facebook object]");
        
    }
    
    [_facebook closeAndClearTokenInformation];
     */
    //[FBSession setActiveSession:_facebook];
    //[m_Facebook closeAndClearTokenInformation];
    
    //NSLog(@"[Facebook] AppId: %@", facebookAppId);
    
    [_facebook openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session state:status error:error];
        
    }];

}


#pragma mark Facebook Sdk IOS methods




- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            //NSLog(@"[Facebook] User Logged In. Old token: %@, New token: %@", m_Token, m_Facebook.accessTokenData.accessToken);
            //NSLog(@"[Facebook] session User Logged In. Old token: %@, New token: %@", m_Token, session.accessTokenData.accessToken);
            
            //self.m_Token = m_Facebook.accessTokenData.accessToken;
            //[self showFacebookStreamMessageAlert];
            self.facebookLikeView.alpha = 1;
            [self.facebookLikeView load];
            
        }
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
            //[self cancelFacebook];
            self.facebookLikeView.alpha = 1;
            [self.facebookLikeView load];
            break;
        default:
            break;
    }
    
    
    if (error && state!=FBSessionStateClosedLoginFailed) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Facebook Problem"
                                  message:@"There was a problem. Please try again."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"[Facebook] Error: %@", error.localizedDescription);
        //[self.delegate facebookLoginFailed];
    }
}

#pragma mark FBSessionDelegate methods

- (void)fbDidLogin {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

- (void)fbDidLogout {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

#pragma mark FacebookLikeViewDelegate methods

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
    //[_facebook authorize:[NSArray array]];
    [self FacebookSetup];
    NSLog(@"facebookLikeViewRequiresLogin");
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    NSLog(@"facebookLikeViewDidRender");
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liked"
                                                     message:@"You liked Yardsellr. Thanks!"
                                                    delegate:self 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    [_facebook closeAndClearTokenInformation];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unliked"
                                                     message:@"You unliked Yardsellr. Where's the love?"
                                                    delegate:self 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    [_facebook closeAndClearTokenInformation];
}

#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.facebookLikeView.href = [NSURL URLWithString:@"http://www.yardsellr.com"];
    self.facebookLikeView.layout = @"button_count";
    self.facebookLikeView.showFaces = NO;
    
    self.facebookLikeView.alpha = 0;
    [self.facebookLikeView load];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.facebookLikeView = nil;
}

@end
