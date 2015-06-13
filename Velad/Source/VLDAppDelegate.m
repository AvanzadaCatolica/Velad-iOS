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

@interface VLDAppDelegate ()

- (void)setupNavigation;

@end

@implementation VLDAppDelegate

#pragma mark - Life cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupNavigation];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Private methods

- (void)setupNavigation {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UINavigationController *navigationController;
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    VLDTodayViewController *todayViewController = [[VLDTodayViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:todayViewController];
    navigationController.tabBarItem.title = @"Hoy";
    [viewControllers addObject:navigationController];
    
    VLDWeekViewController *weekViewController = [[VLDWeekViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:weekViewController];
    navigationController.tabBarItem.title = @"Semana";
    [viewControllers addObject:navigationController];
    
    VLDDiaryViewController *diaryViewController = [[VLDDiaryViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:diaryViewController];
    navigationController.tabBarItem.title = @"Diario";
    [viewControllers addObject:navigationController];
    
    VLDReportsViewController *reportsViewController = [[VLDReportsViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:reportsViewController];
    navigationController.tabBarItem.title = @"Informes";
    [viewControllers addObject:navigationController];
    
    VLDConfigurationViewController *configurationViewController = [[VLDConfigurationViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:configurationViewController];
    navigationController.tabBarItem.title = @"Configuración";
    [viewControllers addObject:navigationController];
    
    tabBarController.viewControllers = [viewControllers copy];
    
    self.window.rootViewController = tabBarController;
}

@end
