//
//  TextViewController.m
//  Newsab
//
//  Created by 遠藤 豪 on 2014/03/08.
//
//

#import "TextViewController.h"

@interface TextViewController ()

@end

int category;

@implementation TextViewController

-(id)initWithArticle:(ArticleData *)articleData{
    self = [super init];
    if(self){
        
        category = 0;//articleDataのカテゴリに応じて変更
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(category == 0){
        [self.view addSubview:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aman.png"]]];
//    }else{//...
    }
}

@end
