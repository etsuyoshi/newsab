//
//  WebViewController.m
//  Newsab
//
//  Created by 遠藤 豪 on 2014/04/13.
//
//

#import "WebViewController.h"

NSString *strUrl;

UIToolbar *toolBarWeb;
UIBarButtonItem *returnBarButton;
UIBarButtonItem *fBarButton;
UIBarButtonItem *bBarButton;

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUrl:(NSString *)_strUrl{
    
    self = [super init];
    if(self){
        strUrl = _strUrl;
        
        
        toolBarWeb = [[UIToolbar alloc] init];
        toolBarWeb.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        returnBarButton =
        [[UIBarButtonItem alloc]
         initWithTitle:@"戻る"
         style:UIBarButtonItemStyleBordered
         target:self
         action:@selector(exit)];
        
        
        //ウェブ進むボタン
        fBarButton =
        [[UIBarButtonItem alloc]
         initWithTitle:@"<"
         style:UIBarButtonItemStyleBordered
         target:self
         action:@selector(goBack)];
        
        //ウェブ戻るボタン
        bBarButton =
        [[UIBarButtonItem alloc]
         initWithTitle:@">"
         style:UIBarButtonItemStyleBordered
         target:self
         action:@selector(goForward)];
        
//        [items addObject:[UIBarButtonItem alloc]initWithButton];
        [items addObject:returnBarButton];
        [items addObject:fBarButton];
        [items addObject:bBarButton];
        
        [toolBarWeb setItems:items animated:NO];
        
        
        [self.view addSubview:toolBarWeb];
        
        
        
        
        
        //webView
        UIWebView *webview=
        [[UIWebView alloc]initWithFrame:
         CGRectMake(0, toolBarWeb.frame.size.height,
                    self.view.frame.size.width,
                    self.view.frame.size.height)];
        NSString *url=strUrl;//@"http://techable.jp/archives/13102";
        NSURL *nsurl=[NSURL URLWithString:url];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [webview loadRequest:nsrequest];
        [self.view addSubview:webview];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)exit{
    [self dismissViewControllerAnimated:nil completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)webViewDidStartLoad:(UIWebView *)webView {
	// ページのロードが開始されたので、ステータスバーのロード中インジケータを表示する。
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// ページのロードが終了したので、ステータスバーのロード中インジケータを非表示にする。
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// ページの「進む」および「戻る」が可能かチェックし、各ボタンの有効／無効を指定する。
	bBarButton.enabled = [webView canGoBack];
	fBarButton.enabled = [webView canGoForward];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	// エラーが発生したので、ステータスバーのロード中インジケータを非表示にする。
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // ロードキャンセルエラーの場合はエラー処理を行わない。
    // ページのロード途中に別のページを表示しようとした場合でも、このエラーが発生するが、
    // アプリの操作はそのまま続行できるため、エラー処理は行わない。
    if ([error code] != NSURLErrorCancelled) {
        // エラーの内容をWebView画面に表示する。
        NSString* errString = [NSString stringWithFormat:
                               @"<html><center><font size=+7 color='red'>エラーが発生しました。:<br>%@</font></center></html>",
                               error.localizedDescription];
        [webView loadHTMLString:errString baseURL:nil];
    }
}

@end
