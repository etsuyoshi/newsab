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

@interface TextViewController : UIViewController <UIScrollViewDelegate>

-(id)initWithArticle:(ArticleData *)_articleData;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
