//
//  TextViewController.m
//  Newsab
//
//  Created by 遠藤 豪 on 2014/03/08.
//
//
#define LOG true
#import "ArticleCell.h"
#import "TextViewController.h"

@interface TextViewController ()

@end

int category;

UIView *viewReturn;
UIView *viewLink;
//ArticleCell *articleCell;//現在使用しない？
UITextView *textView;
//UIImage *imgBackground;
UIView *viewBackground;
ArticleData *articleData;

@implementation TextViewController

-(id)initWithArticle:(ArticleData *)_articleData{
    self = [super init];
    if(self){
        
        category = 0;//articleDataのカテゴリに応じて変更
        
        articleData = _articleData;
        
        
        //戻るボタン
        viewReturn = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 150, 70)];
        [viewReturn setBackgroundColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5f]];

        
        //tap recognizer
        UITapGestureRecognizer *tapGestureReturn;
        tapGestureReturn = [[UITapGestureRecognizer alloc]
                            initWithTarget:self
                            action:@selector(onTapped:)];
        [viewReturn addGestureRecognizer:tapGestureReturn];
        viewReturn.userInteractionEnabled = YES;
        viewReturn.tag = 0;
        
        //本サイトへのリンク
        viewLink = [[UIView alloc]initWithFrame:CGRectMake(200, 100, 150, 70)];
        [viewLink setBackgroundColor:[UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5f]];
        
        //tap recognizer
        UITapGestureRecognizer *tapGestureLink;
        tapGestureLink = [[UITapGestureRecognizer alloc]
                          initWithTarget:self
                          action:@selector(onTapped:)];
        [viewLink addGestureRecognizer:tapGestureLink];
        viewLink.userInteractionEnabled = YES;
        viewLink.tag = 1;
        
        
        //記事のタイトル表示と要約表示
//        articleCell =//磨りガラス風にしたいので転用(特別な意図はない)
//        [[ArticleCell alloc]
//         initWithFrame:CGRectMake(30, 180, 300, 350)
//         withArticleData:_articleData];
        textView = [[UITextView alloc]initWithFrame:
                    CGRectMake(0, 100, self.view.frame.size.width,
                               self.view.frame.size.height - 100)];//100は上部掲載予定の画像縦サイズ
        textView.text = articleData.strSentence;
        
        //背景画像の設定
#if LOG
        NSLog(@"image = %@", _articleData.strImageUrl);
#endif
        if([_articleData.strImageUrl isEqual:(NSString *)[NSNull null]] ||
           _articleData.strImageUrl == nil ||
           [_articleData.strImageUrl isEqualToString:@"http://noImageUrl.png"]){
            
            
            viewBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aman.png"]];
            
        }else{
            
#if LOG
            NSLog(@"image Data = %@", _articleData.strImageUrl);
#endif
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_articleData.strImageUrl]]];
            viewBackground = [[UIImageView alloc]initWithImage:image];
            
            
//            NSData *dt =
//            [NSData dataWithContentsOfURL:
//             [NSURL URLWithString:articleData.strImageUrl]];
//            UIImage *imgBackground = [[UIImage alloc] initWithData:dt];
//            viewBackground = [[UIImageView alloc]initWithImage:imgBackground];

        }
    
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [self.view addSubview:viewReturn];
    [self.view addSubview:viewLink];
//    [self.view addSubview:articleCell];
    [self.view addSubview:textView];
    [self.view addSubview:viewBackground];
    [self.view sendSubviewToBack:viewBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if(category == 0){
//        backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aman.png"]];
//        [self.view addSubview:backgroundView];
//        [self.view sendSubviewToBack:backgroundView];
////    }else{//...
//    }
    
    
    
    
}
-(void)onTapped:(UITapGestureRecognizer *)gr{
#if LOG
    NSLog(@"tapped %d, %@", (int)[gr.view tag], gr);
#endif
    if([gr.view tag] == 0){
        [self dispNextViewController];
    }else if([gr.view tag] == 1){
        //jump to view browser with html sites(作成中)
        
        WebViewController *wvcon =
        [[WebViewController alloc] initWithUrl:articleData.strUrl];//@"http:www.google.com"];
        
        [self presentViewController:wvcon
                           animated:NO completion:nil];
        
        
//        NSURL *url = [NSURL URLWithString:articleData.strImageUrl];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [self.webView loadRequest:request];
        
    }
}

-(void)dispNextViewController{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
