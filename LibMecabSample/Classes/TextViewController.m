//
//  TextViewController.m
//  Newsab
//
//  Created by 遠藤 豪 on 2014/03/08.
//
//

#import "ArticleCell.h"
#import "TextViewController.h"

@interface TextViewController ()

@end

int category;

UIView *viewReturn;
UIView *viewLink;
ArticleCell *articleCell;
//UIImage *imgBackground;
UIView *viewBackground;

@implementation TextViewController

-(id)initWithArticle:(ArticleData *)articleData{
    self = [super init];
    if(self){
        
        category = 0;//articleDataのカテゴリに応じて変更
        
        
        
        
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
        articleCell =//磨りガラス風にしたいので転用(特別な意図はない)
        [[ArticleCell alloc]
         initWithFrame:CGRectMake(30, 180, 300, 350)
         withArticleData:articleData];
        
        
        //背景画像の設定
        NSLog(@"image = %@", articleData.strImageUrl);
        if(articleData.strImageUrl == (NSString *)[NSNull null]){
            NSData *dt =
            [NSData dataWithContentsOfURL:
             [NSURL URLWithString:articleData.strImageUrl]];
            UIImage *imgBackground = [[UIImage alloc] initWithData:dt];
            viewBackground = [[UIImageView alloc]initWithImage:imgBackground];
        }else{
            viewBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aman.png"]];
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
    [self.view addSubview:articleCell];
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
    NSLog(@"tapped %d, %@", [gr.view tag], gr);
    if([gr.view tag] == 0){
        [self dispNextViewController];
    }else if([gr.view tag] == 1){
        //jump to view browser with html sites(未作成)
        
    }
}

-(void)dispNextViewController{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
