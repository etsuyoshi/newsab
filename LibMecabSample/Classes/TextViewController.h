//
//  TextViewController.h
//  Newsab
//
//  Created by 遠藤 豪 on 2014/03/08.
//
//

#import <UIKit/UIKit.h>
#import "ArticleData.h"
#import "WebViewController.h"
typedef enum {
    HeaderViewStateHidden = 0,          // ヘッダが隠れた状態
    HeaderViewStatePullingDown,         // プルダウン状態１（ただし閾値は超えていない）
    HeaderViewStateOveredThreshold,     // プルダウン状態２（閾値を越えている）
    HeaderViewStateStopping             // プルダウン停止状態（処理中）
} HeaderViewState;

@interface TextViewController : UIViewController <UIScrollViewDelegate>

-(id)initWithArticle:(ArticleData *)_articleData;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
