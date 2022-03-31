//
//  FMDatabase+RC.h
//  KEPRequestCapture
//
//  Created by zhen li on 2022/1/11.
//

@import FMDB;

NS_ASSUME_NONNULL_BEGIN

@interface FMDatabase (RC)

/// 当前表快捷方式绑定的类
@property (nonatomic, strong) Class bindModelClass;

/// 建表
/// @param tableName 表名
/// @param model 用来建表的数据模型，根据模型的属性自动建表
- (BOOL)rc_createTableWithName:(NSString *)tableName initializeModel:(id)model;


/// 建表
/// @param tableName 表名
/// @param model 用来建表的数据模型，根据模型的属性自动建表
/// @param ignoreNames 需要忽略的属性名
- (BOOL)rc_createTable:(NSString *)tableName initializeModel:(id)model ignorePropertyNames:(NSArray <NSString *>* _Nullable)ignoreNames;

/// 插入数据
/// @param tableName 表名
/// @param model 数据模型
- (BOOL)rc_insertTable:(NSString *)tableName model:(id)model;

/// 删除数据
/// @param tableName 表名
/// @param format 条件语句
- (BOOL)rc_deleteTable:(NSString *)tableName whereFormat:(NSString * _Nullable)format;
/// 删除从主键从0 到 row
/// @param tableName 表名
/// @param row id
- (BOOL)rc_deleteTable:(NSString *)tableName toRow:(NSInteger)row;

/// 更新数据
/// @param tableName 表名
/// @param model 新数据
/// @param format 条件语句
- (BOOL)rc_updateTable:(NSString *)tableName model:(id)model whereFormat:(NSString * _Nullable)format;

/// 查询数据
/// @param tableName 表名
/// @param format 条件语句
- (NSArray *)rc_searchTable:(NSString *)tableName whereFormat:(NSString * _Nullable)format;

/// 删除表
/// @param tableName 表名
- (BOOL)rc_deleteTable:(NSString *)tableName;

/// 清空表内信息
/// @param tableName 表名
- (BOOL)rc_clearAllDataFromTable:(NSString *)tableName;


@end

NS_ASSUME_NONNULL_END
