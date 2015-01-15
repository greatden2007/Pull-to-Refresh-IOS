# Pull to Refresh IOS (UIViewController category)

![Pull to Refresh IOS](https://camo.githubusercontent.com/e5dc6dc94a0bb3a4f379c245de85401efca76155/687474703a2f2f63646e2e6d616b65616769662e636f6d2f6d656469612f312d31342d323031352f583967474a4c2e676966)

## What is this?

This is a Category for UIViewController, which you can use for UITableView to update info in it via "Pull To Refresh" gesture

## How Can I use it?

It's simple to use:

1. In your TableViewController viewDidLoad method add:

    *     [self setUpdatableAndInitWithTableView:self.tableView];

    *     [self addToInnerViewImageViewWithImage: LoadingIndicatorWithStyle: WithColor: ]; //See Note

2. Add into your TableViewController.m -(void)updateInfo method

    * use this method to load data from network/database and reload tableView

3. Use [self stopUpdate] when your update completed. Method reset UITableView to normal state.

***


_Note: if you got your own ActivityIndicator and UIImageView for updating (e.g. on storyboard) use_

        self.loadingIndicatorView.frame = yourActivityIndicator

        self.loadingImageView.frame = yourLoadingImageView 

In this case you wan't use [self addToInnerViewImageViewWithImage: LoadingIndicatorWithStyle: WithColor: ];

***

If you have any problems, please contact me here or kudinov.dw@gmail.com
