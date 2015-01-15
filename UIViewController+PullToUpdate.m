//
//  UIViewController+PullToUpdate.m
//  WhatHappening
//
//  Created by Denis on 14.01.15.
//  Copyright (c) 2015 HowAboutNo. All rights reserved.
//

#import "UIViewController+PullToUpdate.h"
#import <objc/runtime.h>
@implementation UIViewController (PullToUpdate)

@dynamic isUpdating;
@dynamic loadingImageView;
@dynamic loadingIndicatorView;
@dynamic innerTableView;
@dynamic isAfterUpdate;

NSString * const kloadImageView = @"kloadImageView";
NSString * const kloadingIndicatorView = @"kloadingIndicatorView";
NSString * const kinnerTableView = @"kinnerTableView";
NSString * const kIsUpdating = @"kIsUpdating";
NSString * const kisUpdatable = @"kIsupdatable";
NSString * const kisAfterUpdate = @"kisAfterUpdate";


-(void)setLoadingIndicatorView:(UIActivityIndicatorView *)loadingIndicatorView {
    objc_setAssociatedObject(self, (__bridge const void *)(kloadingIndicatorView), loadingIndicatorView, OBJC_ASSOCIATION_RETAIN);
}

-(UIActivityIndicatorView *)loadingIndicatorView {
    return objc_getAssociatedObject(self, (__bridge const void *)(kloadingIndicatorView));
}

-(void)setInnerTableView:(UITableView *)innerTableView {
    objc_setAssociatedObject(self, (__bridge const void *)(kinnerTableView), innerTableView, OBJC_ASSOCIATION_RETAIN);
}

-(UITableView *)innerTableView {
    return objc_getAssociatedObject(self, (__bridge const void *)(kinnerTableView));
}

-(void)setLoadingImageView:(UIImageView *)loadingImageView {
    objc_setAssociatedObject(self, (__bridge const void *)(kloadImageView), loadingImageView, OBJC_ASSOCIATION_RETAIN);
}

-(UIImageView *)loadingImageView {
    return objc_getAssociatedObject(self, (__bridge const void *)(kloadImageView));
}

-(void)setIsUpdating:(NSNumber *)isUpdating {
    objc_setAssociatedObject(self, (__bridge const void *)(kIsUpdating), isUpdating, OBJC_ASSOCIATION_RETAIN);
}

-(NSNumber *)isUpdating {
    return objc_getAssociatedObject(self, (__bridge const void *)(kIsUpdating));
}

-(void)setIsUpdatable:(BOOL)isUpdatable {
    NSNumber *number = [NSNumber numberWithBool: isUpdatable];
    objc_setAssociatedObject(self, (__bridge const void *)(kisUpdatable), number , OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)isUpdatable {
    NSNumber *number = objc_getAssociatedObject(self, (__bridge const void *)(kisUpdatable));
    return [number boolValue];
}

-(void)setIsAfterUpdate:(BOOL)isAfterUpdate {
    NSNumber *number = [NSNumber numberWithBool: isAfterUpdate];
    objc_setAssociatedObject(self, (__bridge const void *)(kisAfterUpdate), number , OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)isAfterUpdate {
    NSNumber *number = objc_getAssociatedObject(self, (__bridge const void *)(kisAfterUpdate));
    return [number boolValue];
}



-(void)setUpdatableAndInitWithTableView:(UITableView *)tableView {
    
    self.isUpdatable = YES;
    self.innerTableView = tableView;
    self.isAfterUpdate = NO;
    
}

-(void)addToInnerViewImageViewWithImage:(UIImage *)image
              LoadingIndicatorWithStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle
                              WithColor:(UIColor *)color {
    
    if(!activityIndicatorStyle) {
        activityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    self.loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorStyle];
    
    if(color) {
        [self.loadingIndicatorView setColor:color];
    }
    
    self.loadingImageView  = [[UIImageView alloc] initWithImage:image];
    self.loadingImageView.contentMode = UIViewContentModeScaleAspectFit;

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.innerTableView.frame];
    
    self.loadingIndicatorView.frame = CGRectMake(self.innerTableView.frame.size.width/2, 15, 50, 50);
    self.loadingImageView.frame     = CGRectMake(self.innerTableView.frame.size.width/2, 15, 50, 50);
    
    [self.loadingIndicatorView setCenter:CGPointMake(backgroundView.center.x, self.loadingIndicatorView.center.y)];
    [self.loadingImageView setCenter:CGPointMake(backgroundView.center.x, self.loadingImageView.center.y)];
    
    [backgroundView addSubview:self.loadingImageView];
    [backgroundView addSubview:self.loadingIndicatorView];
    
    [self.innerTableView setBackgroundView:backgroundView];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!self.isUpdatable) {
        return;
    }
    int offset = scrollView.contentOffset.y;
    
    if(offset < 0 && offset < -70 && ![self.isUpdating boolValue]) {
        self.loadingIndicatorView.hidden = NO;
        self.loadingImageView.hidden = YES;
        [self.loadingIndicatorView startAnimating];
        self.isUpdating = @(YES);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(@"updateInfo")];
#pragma clang diagnostic pop
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isUpdatable) {
        return;
    }
    int offset = scrollView.contentOffset.y;
    if(offset == 0) {
        self.isAfterUpdate = NO;
    }
    if(offset < 0 && offset < -70 && ![self.isUpdating boolValue] && !self.isAfterUpdate) {
        self.loadingIndicatorView.hidden = NO;
        self.loadingImageView.hidden = YES;
    } else if (offset < 0 && offset > -70 && ![self.isUpdating boolValue]) {
        self.loadingIndicatorView.hidden = YES;
        self.loadingImageView.hidden = NO;
    }
    if([self.isUpdating boolValue]) {
        [self.innerTableView setContentOffset:CGPointMake(0, -80)];
    }
}

-(void)stopUpdate {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isUpdating = @(NO);
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.loadingIndicatorView stopAnimating];
        self.loadingIndicatorView.hidden = YES;
        self.loadingImageView.hidden = NO;
        [self.innerTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.isAfterUpdate = YES;
    });
}

@end
