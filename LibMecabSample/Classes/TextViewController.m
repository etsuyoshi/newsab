//
//  TextViewController.m
//  Newsab
//
//  Created by 遠藤 豪 on 2014/03/08.
//
//
#define LOG true
#define IMAGE_HEIGHT 200
#import "ArticleCell.h"
#import "TextViewController.h"

@interface TextViewController ()

@end

CGPoint _scrollPrevPoint;  //スクロールの開始位置
BOOL _cancelDecelerating;  //慣性スクロールをキャンセルするフラグ
int _scrolling_direction;  //0:未確定 1:上（offset.yが小さくなる）　2:下（offset.yが大きくなる）



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
        scrollView.directionalLockEnabled = YES;
        
        //戻るために右スライドした時に表示される左ビュー
        returnView =
        [[UIView alloc]
         initWithFrame:
         CGRectMake(0, 0, 100, self.view.bounds.size.height)];
        returnView.backgroundColor = [UIColor grayColor];
        
        
        //allow追加
        UIImageView *viewAllow =
        [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"allow_update.png"]];
        viewAllow.center =
        CGPointMake(returnView.bounds.size.width*2/3,
                    returnView.bounds.size.height/2);
        [returnView addSubview:viewAllow];
        
        textView = [[UITextView alloc]initWithFrame:
                    CGRectMake(returnView.bounds.size.width,//returnViewの右隣
                               IMAGE_HEIGHT,
                               self.view.frame.size.width,
                               self.view.frame.size.height - IMAGE_HEIGHT)];//200は上部掲載予定の画像縦サイズ
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
        
        
        viewImage.frame = CGRectMake(returnView.bounds.size.width,0,
                                     self.view.bounds.size.width, IMAGE_HEIGHT);
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
    
    //viewDidLoadに記載すべき
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


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //慣性スクロールを止める
    if (_cancelDecelerating){
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    }
}

//スクロール開始前に初期位置を把握(右方向以外にスクロールできないようにするため)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrolling_direction = 0;
    _cancelDecelerating = false;
    _scrollPrevPoint = [scrollView contentOffset];
}



//http://cocoadays.blogspot.jp/2011/07/ios-uitableview.html
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
//    NSLog(@"scrollViewDidScroll @ x=%f, y=%f",
//          scrollView.contentOffset.x,
//          scrollView.contentOffset.y);
    
    
    CGPoint currentPoint = [scrollView contentOffset];
    
    if (CGPointEqualToPoint(_scrollPrevPoint, currentPoint)){
        return;
    }
    else {
        //上下スクロール方向の判定
        _scrolling_direction = (_scrollPrevPoint.y != currentPoint.y) ? 2 : 1;
        
        if(_scrolling_direction != 2){//上下方向の移動ではないとき
            //左フリックは無効化(_scrolling_directionは偶数の時に元座標にリセット)
            _scrolling_direction = (_scrollPrevPoint.x < currentPoint.x) ? 4 : 3;
        }
        
//        NSLog(@"cy=%f, _sy=%f _scrolling_direction = %d : %@",
//              currentPoint.y,
//              _scrollPrevPoint.y,
//              _scrolling_direction,
//              _scrolling_direction==2?@"キャンセル":@"スクロール中");
    }
    
    //常にスクロール縦位置は同じ
    currentPoint.y = _scrollPrevPoint.y;
    //上下及び右スクロールのキャンセル
    if (_scrolling_direction % 2 == 0)
    {
        
        currentPoint.x = _scrollPrevPoint.x;
        [scrollView setContentOffset:currentPoint];
        _cancelDecelerating = true; //慣性スクロールを止めるためのフラグをセット
    }
    
    
    
    //左方向である場合は一定の閾値以上であれば「戻る」アクション
    if(scrollView.contentOffset.x < -returnView.bounds.size.width/2){
        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        
        NSLog(@"touch limit-left side");
        
//        [self dismissViewController];
        //１秒後に戻る
        [self performSelector:@selector(dismissViewController)
                   withObject:nil
                   afterDelay:1.0f];
        
    }
    
}

@end
