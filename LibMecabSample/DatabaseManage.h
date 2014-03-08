//
//  DatabaseManage.h
//  NewsAbst
//
//  Created by 遠藤 豪 on 2014/02/08.
//  Copyright (c) 2014年 endo.news. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, DataType) {
    DataTypeId,
    DataTypeDateTime,
    DataTypeBlogId,
    DataTypeTitle,
    DataTypeUrl,
    DataTypeBodyWithTags,
    DataTypeBody,
    DataTypeHatebu,
    DataTypeSavedData
};




@interface DatabaseManage : NSObject
+(NSArray *)getRecordFromDBAll;
+(NSArray *)getRecordFromDBFor:(int)num;
+(NSDictionary *)getRecordFromDBAt:(int)idNo;
+(Boolean)updateValueToDB:(NSString *)user_id
                   column:(NSString *)column
                   newVal:(NSString *)newValue;
//指定したカテゴリ(DBカラム名：category)内で、指定したID以下で最大のidを返す
+(int)getLastIDFromDBUnderNaive:(int)_idNo
                       category:(int)_category;
//指定したカテゴリ(DBカラム名：category)内で、指定したID以下で最大のidの個数(０か１のみ)を返す
+(int)getCountFromDBUnderNaive:(int)_idNo
                      category:(int)_category;

//最終的には以下のクラスは内部クラス用として使用し、外部からカラム名等を指定させないようにする(アクセス禁止)
//-(NSString *)getValueFromDB:(NSString *)user_id column:(NSString *)column;
//-(NSData *)formEncodedDataFromDictionary:(NSDictionary *)dict;
@end
