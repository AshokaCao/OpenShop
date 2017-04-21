//
//  WebViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/13.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <UIWebViewDelegate>
@property (nonatomic ,strong)  UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//    
//    webView.delegate = self;
//    webView.scalesPageToFit = YES;
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.showUrl]]];
//    
//    [self.view addSubview:webView];
    
    
//    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    backButton.frame = CGRectMake(10, 20, 20, 20);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back:) image:@"nav_icon_back" highImage:@""];
    
    self.webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [UIColor clearColor];
    for (UIView * views in [self.webView subviews]) {
        if ([views isKindOfClass:[UIScrollView class]]) {
            //去掉水平方向的滑动条
            [(UIScrollView *)views setShowsHorizontalScrollIndicator:NO];
            //去掉垂直方向的滑动条
            [(UIScrollView *)views setShowsVerticalScrollIndicator:NO];
            for (UIView * inScrollView in views.subviews) {
                if ([inScrollView isKindOfClass:[UIImageView class]]) {
                    //隐藏上下滚动出边界时的黑色的图片
                    inScrollView.hidden = YES;
                }
            }
        }
    }
//    NSString * urlString = [NSString stringWithFormat:@"%@xxxxxxxx",BASE_URL];
    NSURL * url = [NSURL URLWithString:self.showUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    _webView.delegate = self;
    [_webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    
}


//用苹果自带的返回键按钮处理如下(自定义的返回按钮)
- (void)back:(UIBarButtonItem *)btn
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//如果是H5页面里面自带的返回按钮处理如下:
#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString * requestString = [[request URL] absoluteString];
    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //获取H5页面里面按钮的操作方法,根据这个进行判断返回是内部的还是push的上一级页面
    if ([requestString hasPrefix:@"goback:"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.webView goBack];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"------:  %@",html);
    self.title = html;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;//枚举类型不同的效果
    hud.dimBackground = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
