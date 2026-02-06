//
//  LoginManager.h
//  DiscoveryApp
//
//  Created by Arya Maadeni on 05/02/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoginManager : NSObject

+ (instancetype)sharedInstance;
- (void)handleLoginWithViewController:(UIViewController *)presentingVC;
- (void)performSilentLogin;
- (void)logout;

@end
