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

int widthImage;
int heightImage;
int widthText;
int heightText;

UIToolbar *toolBarText;
UIBarButtonItem *returnBarButton;
UIBarButtonItem *forwardBarButton;

UIView *viewReturn;
UIView *viewLink;
//ArticleCell *articleCell;//現在使用しない？
UIView *contentViewOnScroll;//textViewを置く土台
UITextView *textView;
UIView *returnView;//右にフリックした時に左に見えるやつ
//UIImage *imgBackground;
UIView *viewImage;
ArticleData *articleData;
UIScrollView *scrollView;

@implementation TextViewController

-(id)initWithArticle:(ArticleData *)_articleData{
    self = [super init];
    if(self){
        
        
        
        category = 0;//articleDataのカテゴリに応じて変更
        
        articleData = _articleData;
        
#if LOG
        NSLog(@"articleData = %@", articleData.strUrl);
#endif
        toolBarText =
        [[UIToolbar alloc]
         initWithFrame:
         CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        
        //ツールバーに戻るボタン配置
        NSMutableArray *items = [[NSMutableArray alloc] init];
        returnBarButton =
        [[UIBarButtonItem alloc]
         initWithTitle:@"⇦"
         style:UIBarButtonItemStyleBordered
         target:self
         action:@selector(dismissViewController)];
        
        forwardBarButton =
        [[UIBarButtonItem alloc]
         initWithTitle:@"⇨"
         style:UIBarButtonItemStyleBordered
         target:self
         action:@selector(gotoWebViewController)];
        
        
        [items addObject:returnBarButton];
        [items addObject:forwardBarButton];
        
        [toolBarText setItems:items animated:NO];
        
        
        
        
        
        //画面全体にスクロールビューを表示
        scrollView = [[UIScrollView alloc]initWithFrame:
                      CGRectMake(0,//-self.view.bounds.size.width/2,
                                 toolBarText.bounds.size.height,
                                 self.view.bounds.size.width,
                                 self.view.bounds.size.height - toolBarText.bounds.size.height)];
        scrollView.contentSize = contentViewOnScroll.bounds.size;
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.alwaysBounceVertical = NO;
        
        //戻るボタン:フリックでも戻る:以下、消去可能
//        viewReturn = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 150, 70)];
//        [viewReturn setBackgroundColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5f]];
//
//        
//        //tap recognizer
//        UITapGestureRecognizer *tapGestureReturn;
//        tapGestureReturn = [[UITapGestureRecognizer alloc]
//                            initWithTarget:self
//                            action:@selector(onTapped:)];
//        [viewReturn addGestureRecognizer:tapGestureReturn];
//        viewReturn.userInteractionEnabled = YES;
//        viewReturn.tag = 0;
//        
//        //本サイトへのリンク
//        viewLink = [[UIView alloc]initWithFrame:CGRectMake(200, 10, 150, 70)];
//        [viewLink setBackgroundColor:[UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5f]];
//        
//        //tap recognizer
//        UITapGestureRecognizer *tapGestureLink;
//        tapGestureLink = [[UITapGestureRecognizer alloc]
//                          initWithTarget:self
//                          action:@selector(onTapped:)];
//        [viewLink addGestureRecognizer:tapGestureLink];
//        viewLink.userInteractionEnabled = YES;
//        viewLink.tag = 1;
        
        
        //記事のタイトル表示と要約表示
//        articleCell =//磨りガラス風にしたいので転用(特別な意図はない)
//        [[ArticleCell alloc]
//         initWithFrame:CGRectMake(30, 180, 300, 350)
//         withArticleData:_articleData];
        
        
        returnView =
        [[UIView alloc]
         initWithFrame:
         CGRectMake(0, 0, 50, self.view.bounds.size.height)];
        returnView.backgroundColor = [UIColor grayColor];
        
        textView = [[UITextView alloc]initWithFrame:
                    CGRectMake(returnView.bounds.size.width,//returnViewの右隣
                               200,
                               self.view.frame.size.width,
                               self.view.frame.size.height - 200)];//200は上部掲載予定の画像縦サイズ
        textView.text = articleData.strSentence;
        textView.editable = NO;
        
        //returnViewの横幅だけ左に隠すので通常ではreturnViewが見えなくなる
        contentViewOnScroll =
        [[UITextView alloc]
         initWithFrame:
            CGRectMake(-returnView.bounds.size.width,//-self.view.bounds.size.width/2,
                       0,//self.view.bounds.size.height/4,
                       textView.bounds.size.width + returnView.bounds.size.width,
                       self.view.bounds.size.height)];
        
        
        
        
        //背景画像の設定
        if([_articleData.strImageUrl isEqual:(NSString *)[NSNull null]] ||
           _articleData.strImageUrl == nil ||
           [_articleData.strImageUrl isEqualToString:@"http://noImageUrl.png"]){
            
#if LOG
            NSLog(@"image = aman.png caz no image");
#endif
            viewImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aman.png"]];
//            viewImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            
        }else{
            
#if LOG
            NSLog(@"image Data = %@", _articleData.strImageUrl);
#endif
            
            UIImage *image =
            [UIImage
             imageWithData:
             [NSData
              dataWithContentsOfURL:
              [NSURL
               URLWithString:_articleData.strImageUrl]]];
            viewImage = [[UIImageView alloc]initWithImage:image];
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
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    scrollView.delegate = self;
    
    scrollView.scrollEnabled = YES;
    [self.view addSubview:toolBarText];
    
//    [viewImage addSubview:viewReturn];
//    [viewImage addSubview:viewLink];
    
    [contentViewOnScroll addSubview:viewImage];
    [contentViewOnScroll addSubview:textView];
    [contentViewOnScroll addSubview:returnView];
    [scrollView addSubview:contentViewOnScroll];
//    [scrollView sendSubviewToBack:viewImage];
    
    
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)onTapped:(UITapGestureRecognizer *)gr{
//#if LOG
//    NSLog(@"tapped %d, %@", (int)[gr.view tag], gr);
//#endif
//    if([gr.view tag] == 0){
//        [self dismissViewController];
//    }else if([gr.view tag] == 1){
//        //jump to view browser with html sites
//        
//        
//    }
//}

-(void)dismissViewController{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)gotoWebViewController{
    WebViewController *wvcon =
    [[WebViewController alloc]
     initWithUrl:articleData.strUrl];//@"http:www.google.com"];
    
    [self presentViewController:wvcon
                       animated:NO completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    NSLog(@"scrollViewDidScroll @ x=%f, y=%f",
          scrollView.contentOffset.x,
          scrollView.contentOffset.y);
    
    if(scrollView.contentOffset.x < -50.0){
        NSLog(@"touch left side");
        
        
        [UIView
         animateWithDuration:3.25f
         delay:0.0f
         options:UIViewAnimationOptionCurveEaseIn
         animations:^{
             scrollView.contentOffset =
             CGPointMake(-self.view.bounds.size.width/2, 0);
             
         }
         completion:^(BOOL finished){
             if(finished){
                 
//                 [self dismissViewController];
                 [self performSelector:@selector(dismissViewController)
                            withObject:nil
                            afterDelay:3.0f];
             }
         }];
        
        
        
        
        
    }
    
//    CGFloat pageWidth = scrollView.frame.size.width;
//    
//    if (fmod(scrollView.contentOffset.x, pageWidth) == 0.0) {
//        int pageNum = scrollView.contentOffset.x / pageWidth;
//    }
}

@end
