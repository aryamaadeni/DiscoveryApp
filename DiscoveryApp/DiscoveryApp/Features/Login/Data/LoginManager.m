//
//  LoginManager.m
//  DiscoveryApp
//
//  Created by Arya Maadeni on 05/02/26.
//

#import "LoginManager.h"
#import <GoogleSignIn/GoogleSignIn.h>

static NSString *const LoginSuccessNotificationName = @"LoginSuccessNotification";

@implementation LoginManager

+ (instancetype)sharedInstance {
    static LoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)handleLoginWithViewController:(UIViewController *)presentingVC {
    [GIDSignIn.sharedInstance signInWithPresentingViewController:presentingVC
                                                      completion:^(GIDSignInResult * _Nullable signInResult, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        [self notifySuccess];
    }];
}

- (void)performSilentLogin {
    [GIDSignIn.sharedInstance restorePreviousSignInWithCompletion:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            if (error.code == -5) {
                [self logout];
            }
            return;
        }
        [self notifySuccess];
    }];
}

- (void)logout {
    [GIDSignIn.sharedInstance signOut];
    [GIDSignIn.sharedInstance disconnectWithCompletion:^(NSError * _Nullable error) {
        NSLog(@"User logged out and cache cleared.");
    }];
}

- (void)notifySuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotificationName object:nil];
    });
}

@end
