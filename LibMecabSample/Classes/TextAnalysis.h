//
//  TextAnalysis.h
//  Newsab
//
//  Created by 遠藤 豪 on 2014/02/12.
//
//

//#import "HMDTString.h"
#import <Foundation/Foundation.h>
#import "Node.h"
#import "Mecab.h"

@interface TextAnalysis : NSObject
//@property (nonatomic, copy) NSMutableArray *arrImportantSentence;//重要文格納配列
//@property (nonatomic, copy) NSMutableArray *arrImportantNode;//重要語句(Node形式)

-(id)initWithText:(NSString *)str;

-(NSArray *)getImportantSentence;
-(NSArray *)getImportantNode;

@end
