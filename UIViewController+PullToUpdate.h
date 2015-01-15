//
//  UIViewController+PullToUpdate.h
//  WhatHappening
//
//  Created by Denis on 14.01.15.
//  Copyright (c) 2015 HowAboutNo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PullToUpdate) <UITableViewDelegate>
@property (strong, nonatomic) UIImageView *loadingImageView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicatorView;
@property (strong, nonatomic) UITableView *innerTableView;
@property (strong, nonatomic) NSNumber *isUpdating;
@property (readwrite) BOOL isUpdatable;
@property (readwrite) BOOL isAfterUpdate;

/**
 *  main method. After this method you can use -(void)addToInnerViewImageViewWithImage:LoadingIndicatorWithStyle:Withcolor: to customise view
 *
 *  @param tableView UITableView, which you want to use as updatable TableView
 */
-(void)setUpdatableAndInitWithTableView:(UITableView *)tableView;

/**
 *  in case you haven't got own Loading indicator and imageView --> use default
 *   use carefully //not support interface orientations for now
 *
 *  @param image                  "Pull" image. Could be nil
 *  @param activityIndicatorStyle style, see docs
 *  @param color                  spinner color
 */
-(void)addToInnerViewImageViewWithImage:(UIImage *)image
              LoadingIndicatorWithStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle
                              WithColor:(UIColor *)color;

// must use when update completed.
// Return view to normal position and reset views (ImageView & ActivityIndicatorView)
-(void)stopUpdate;

@end
