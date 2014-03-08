//
//  ViewController.m
//  NewsAbst
//
//  Created by 遠藤 豪 on 2014/02/08.
//  Copyright (c) 2014年 endo.news. All rights reserved.
//

#define DispDatabaseLog

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mecab;

NSMutableArray *arrArticleData;

BackgroundView *backgroundView;
CGPoint pntStartDrag;
int noStatus;//現在の状態(どの区切りか)を判別:最初は一番左の状態
UIView *btnUpdate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //既にテキスト解析は終了しているはず
//    self.mecab = [Mecab new];
    
    
    
    //背景画像backgroundViewに記事を配置
    [self updateBackgroundAndArticle];
    
    
    //更新ボタンの作成(backgroundViewの上に配置するのでも良い)
    btnUpdate = [[UIView alloc]initWithFrame:CGRectMake(150, 30, 100, 70)];
    [btnUpdate setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0 blue:0 alpha:0.5f]];
    [backgroundView addSubview:btnUpdate];
    btnUpdate.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureUpdate;
    tapGestureUpdate = [[UITapGestureRecognizer alloc]
                        initWithTarget:self
                        action:@selector(updateBackgroundAndArticle)];
    [btnUpdate addGestureRecognizer:tapGestureUpdate];
}

-(void)updateBackgroundAndArticle{
    //(背景画像である)backgroundにデータを格納した記事セルを配置する
    [self setArticleWithBackground];
    
    //backgroundの表示
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
}

-(void)onTapped:(UITapGestureRecognizer *)gr{
    
    [self dispNextViewController:[gr.view tag]];
}

-(void)dispNextViewController:(int)noTapped{
    TextViewController *tvcon =
    [[TextViewController alloc]
     initWithArticle:(ArticleData *)arrArticleData[noTapped]];
    [self presentViewController:tvcon animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    //backgroundの表示
//    [self.view addSubview:imvBackground];
    [self.view addSubview:backgroundView];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    
    NSLog(@"exit viewDidAppear");
}

-(void)setArticleWithBackground{
    
    
    
    
    
    //表示コンポーネントやデータの初期化等
    NSArray *arrTable = [NSArray arrayWithObjects:
                         [[ArticleTable alloc] initWithType:TableTypeTechnology],
                         [[ArticleTable alloc] initWithType:TableTypeSports],
                         [[ArticleTable alloc] initWithType:TableTypeArts],
                         [[ArticleTable alloc] initWithType:TableTypeBusiness],
                         [[ArticleTable alloc] initWithType:TableTypeFinance],
                         nil];
    
    arrArticleData = [NSMutableArray array];
    
    
    int category = 0;
    int lastID = 10000;
    int numOfArticleAtDB = 0;
    int maxDispArticle = 2;//簡易
    
    for(int i = 0 ;i < [arrTable count];i++){//全てのテーブルに対して
        lastID = 10000;
        category = i;
        
        //記事を確認
        numOfArticleAtDB = [DatabaseManage getCountFromDBUnderNaive:lastID category:i];
        NSLog(@"記事数:numOfArticle = %d", numOfArticleAtDB);
        if(numOfArticleAtDB < 1){//if categoy's article data does not exist..
            continue;//記事が存在しないので次のカテゴリへ(当該カテゴリにはarticleCellを配置しない)
        }
        
        
        for(int j = 0;j < MIN(maxDispArticle, numOfArticleAtDB);j++){//各テーブルに５個のセルを配置
            lastID = [DatabaseManage
                      getLastIDFromDBUnderNaive:lastID
                      category:category];
            
            
            //上記キー値を元にデータを取得
            NSDictionary *dictTmp = [DatabaseManage getRecordFromDBAt:lastID];//lastID未満の最大のlastIDを取得する
            lastID = [[dictTmp objectForKey:@"id"] integerValue];
            NSString *strTitle = [dictTmp objectForKey:@"title"];
            NSString *strReturnBody = [dictTmp objectForKey:@"body"];
            NSString *strAbst = [dictTmp objectForKey:@"abstforblog"];
            NSString *strKeyword = [dictTmp objectForKey:@"keywordblog"];
            NSLog(@"id=%d", lastID);
            NSLog(@"strTitle = %@", strTitle);
            NSLog(@"strBody = %@", strReturnBody);
            NSLog(@"abstforblog = %@", strAbst);
            NSLog(@"keyword=%@", strKeyword);
            
            
            //既に要約文が作成されている前提なのでテキスト解析は行わない
            //            TextAnalysis *textAnalysis = [[TextAnalysis alloc]initWithText:strReturnBody];
            //            NSArray *arrImportantSentence = textAnalysis.getImportantSentence;
            //            NSArray *arrImportantNode = textAnalysis.getImportantNode;
            
            
            
            
            //記事セルにテキストを格納
            //            articleCell.text = arrImportantSentence[j];
            
            ArticleData *articleData = [[ArticleData alloc]init];
            articleData.noID = lastID;
            articleData.title = strTitle;
            articleData.strKeyword = strKeyword;
            articleData.strSentence = strAbst;
            
            
            [arrArticleData addObject:articleData];
            
            
            
            //記事セル作成
            ArticleCell *articleCell =
            [[ArticleCell alloc]
             initWithFrame:
             CGRectMake(0, 0, 250, 100)
             withArticleData:articleData
             ];//位置はaddCellメソッド内で適切に配置
            
            
            
            [((ArticleTable *)arrTable[i]) addCell:articleCell];
            
            
            
            UITapGestureRecognizer *tapGesture;
            tapGesture = [[UITapGestureRecognizer alloc]
                          initWithTarget:self
                          action:@selector(onTapped:)];
            [articleCell addGestureRecognizer:tapGesture];
            articleCell.userInteractionEnabled = YES;
            //            articleCell.tag=countArticle;//初期番号をゼロにするため
            
            
            //            NSLog(@"arrtable%d = %@", i, arrTable[i]);
        }
    }
    
    
    backgroundView = [[BackgroundView alloc]initWithTable:arrTable];
}


//使用していない(必要性なければ後で削除)
-(void)getDataFromDB{
    //databasemanageクラスからデータを取得(引数なしだと最大100記事を取得)
    NSArray *array = [DatabaseManage getRecordFromDBAll];//100個取得
    
    NSString *strId = nil;
    NSString *strBody = nil;
    NSString *strSaved = nil;
    NSString *strDate = nil;
    NSDictionary *_dict = nil;
    for(int i = 0;i < [array count];i++){
        _dict = array[i];
        strId = [_dict objectForKey:@"id"];
        strBody = [_dict objectForKey:@"body"];
        strSaved = [_dict objectForKey:@"saveddate"];
        strDate = [_dict objectForKey:@"datetime"];
#ifdef DispDatabaseLog
        NSLog(@"id=%@",strId);
        
        NSLog(@"id=%@",strBody);
        NSLog(@"id=%@",strSaved);
        NSLog(@"id=%@",strDate);
#endif
    }
}


@end
