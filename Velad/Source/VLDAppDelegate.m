//
//  VLDAppDelegate.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDAppDelegate.h"
#import "VLDTodayViewController.h"
#import "VLDWeekViewController.h"
#import "VLDDiaryViewController.h"
#import "VLDReportsViewController.h"
#import "VLDConfigurationViewController.h"
#import "UIColor+VLDAdditions.h"
#import <Realm/Realm.h>
#import "VLDProfile.h"
#import "VLDProfileViewController.h"
#import "VLDSecurity.h"
#import "VLDSecurityPasscodeViewController.h"

@interface VLDAppDelegate () <VLDProfileViewControllerDelegate, VLDSecurityPasscodeViewControllerDelegate>

@property (nonatomic) VLDSecurity *security;

- (void)setupSecurity;
- (void)setupAppearance;
- (void)setupNavigation;
- (UITabBarController *)mainTabBarController;

@end

@implementation VLDAppDelegate

#pragma mark - Life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor vld_mainColor];
    [self setupSecurity];
    [self setupAppearance];
    [self setupNavigation];
    [self.window makeKeyAndVisible];
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        [self application:[UIApplication sharedApplication] didReceiveLocalNotification:launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (self.security.isEnabled && self.security.state == VLDSecurityStateOnOpen) {
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
            if ([navigationController.topViewController isKindOfClass:[VLDSecurityPasscodeViewController class]]) {
                [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            } else {
                VLDSecurityPasscodeViewController *viewController = [[VLDSecurityPasscodeViewController alloc] initWithMode:VLDSecurityPasscodeViewControllerModeRequest];
                viewController.delegate = self;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [self.window.rootViewController presentViewController:navigationController
                                                             animated:YES
                                                           completion:nil];
            }
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //TODO: Make this work with the security model.
}

#pragma mark - Setup methods

- (void)setupSecurity {
    self.security = [[VLDSecurity allObjects] firstObject];
    if (!self.security) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        VLDSecurity *security = [[VLDSecurity alloc] init];
        security.enabled = NO;
        security.state = VLDSecurityStateOnColdStart;
        [realm addObject:security];
        
        [realm commitWriteTransaction];
        
        self.security = security;
    }
}

- (void)setupAppearance {
    [[UITabBar appearance] setTintColor:[UIColor vld_mainColor]];
    [[UIButton appearance] setTintColor:[UIColor vld_mainColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor vld_mainColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)]) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
}

- (void)setupNavigation {
    VLDProfile *profile = [[VLDProfile allObjects] firstObject];
    if (profile) {
        if (self.security.isEnabled) {
            VLDSecurityPasscodeViewController *viewController = [[VLDSecurityPasscodeViewController alloc] initWithMode:VLDSecurityPasscodeViewControllerModeRequest];
            viewController.delegate = self;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            self.window.rootViewController = navigationController;
        } else {
            self.window.rootViewController = [self mainTabBarController];
        }
    } else {
        VLDProfileViewController *viewController = [[VLDProfileViewController alloc] init];
        viewController.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = navigationController;
    }
}

#pragma mark - Private methods

- (UITabBarController *)mainTabBarController {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UINavigationController *navigationController;
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    VLDTodayViewController *todayViewController = [[VLDTodayViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:todayViewController];
    navigationController.tabBarItem.title = @"Hoy";
    navigationController.navigationBar.translucent = NO;
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"TodayNormal"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"TodaySelected"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [viewControllers addObject:navigationController];
    
    VLDWeekViewController *weekViewController = [[VLDWeekViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:weekViewController];
    navigationController.tabBarItem.title = @"Semana";
    navigationController.navigationBar.translucent = NO;
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"WeekNormal"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"WeekSelected"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [viewControllers addObject:navigationController];
    
    VLDDiaryViewController *diaryViewController = [[VLDDiaryViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:diaryViewController];
    navigationController.tabBarItem.title = @"Diario";
    navigationController.navigationBar.translucent = NO;
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"DiaryNormal"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"DiarySelected"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [viewControllers addObject:navigationController];
    
    VLDReportsViewController *reportsViewController = [[VLDReportsViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:reportsViewController];
    navigationController.tabBarItem.title = @"Informes";
    navigationController.navigationBar.translucent = NO;
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"ReportsNormal"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"ReportsSelected"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [viewControllers addObject:navigationController];
    
    VLDConfigurationViewController *configurationViewController = [[VLDConfigurationViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:configurationViewController];
    navigationController.tabBarItem.title = @"Configuración";
    navigationController.navigationBar.translucent = NO;
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"ConfigurationNormal"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    navigationController.tabBarItem.image = [[UIImage imageNamed:@"ConfigurationSelected"]
                                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [viewControllers addObject:navigationController];
    
    tabBarController.viewControllers = [viewControllers copy];
    
    return tabBarController;
}

#pragma mark - VLDProfileViewControllerDelegate

- (void)profileViewControllerDidFinishEditingProfile:(VLDProfileViewController *)controller {
    [self.window.rootViewController presentViewController:[self mainTabBarController]
                                                 animated:YES
                                               completion:nil];
}

#pragma mark - VLDSecurityPasscodeViewControllerDelegate

- (void)securityPasscodeViewControllerDidFinish:(VLDSecurityPasscodeViewController *)viewController {
    [self.window.rootViewController presentViewController:[self mainTabBarController]
                                                 animated:YES
                                               completion:nil];
}

@end
