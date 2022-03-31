//
//  FMDatabase+RC.m
//  KEPRequestCapture
//
//  Created by zhen li on 2022/1/11.
//

#import "FMDatabase+RC.h"
#import <objc/runtime.h>

@implementation FMDatabase (RC)

- (void)setBindModelClass:(Class)bindModelClass {
    objc_setAssociatedObject(self, @selector(bindModelClass), bindModelClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Class)bindModelClass {
    return objc_getAssociatedObject(self, @selector(bindModelClass));
}

- (BOOL)rc_createTableWithName:(NSString *)tableName initializeModel:(id)model {
    return [self rc_createTable:tableName initializeModel:model ignorePropertyNames:nil];
}

- (BOOL)rc_createTable:(NSString *)tableName initializeModel:(id)model ignorePropertyNames:(NSArray<NSString *> *)ignoreNames {
    NSDictionary *dict;
    Class aClass;
    if ([model isKindOfClass:[NSObject class]]) {
        aClass = model;
    } else {
        return false;
    }
    self.bindModelClass = aClass;
    dict = [self rc_modelToDict:aClass excludePropertyNames:ignoreNames];
    
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (pkid INTEGER PRIMARY KEY,", tableName];
    int keyCount = 0;
    for (NSString *key in dict) {
        keyCount ++;
        if ((ignoreNames && [ignoreNames containsObject:key]) || [key isEqualToString:@"pkid"]) { continue; }
        
        if (keyCount == dict.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dict[key]];
            break;
        }
        
        [fieldStr appendFormat:@" %@ %@,", key, dict[key]];
    }
    
    BOOL createFlag = [self executeUpdate:fieldStr];
    return createFlag;
}

#pragma mark - 插入数据
- (BOOL)rc_insertTable:(NSString *)tableName model:(id)model {
    NSArray *columnArr = [self rc_getColumnArray:tableName];
    return [self rc_insertTable:tableName model:model columnArray:columnArr];
}

- (NSArray *)rc_getColumnArray:(NSString *)tableName {
    NSMutableArray *cArray = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet *resultSet = [self getTableSchema:tableName];
    
    while ([resultSet next]) {
        [cArray addObject:[resultSet stringForColumn:@"name"]];
    }
    
    return cArray;
}

- (BOOL)rc_insertTable:(NSString *)tableName model:(id)model columnArray:(NSArray *)columnArray {
    BOOL flag = false;
    if ([model isKindOfClass:[NSObject class]]) {
        NSDictionary *dict = [self rc_getModelpropertyKeyValue:model tableName:tableName columnArray:columnArray];
        
        NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
        NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
        NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *key in dict) {
            if (![columnArray containsObject:key] || [key isEqualToString:@"pkid"]) { continue; }
            
            [finalStr appendFormat:@"%@,", key];
            [tempStr appendString:@"?,"];
            
            [argumentsArr addObject:dict[key]];
        }
        
        [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length - 1, 1)];
        if (tempStr.length) {
            [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length - 1, 1)];
        }
        [finalStr appendFormat:@") values (%@)", tempStr];
        flag = [self executeUpdate:finalStr withArgumentsInArray:argumentsArr];
        return flag;
    }
    
    return flag;
}

#pragma mark - 删除数据
- (BOOL)rc_deleteTable:(NSString *)tableName whereFormat:(NSString *)format {
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@ %@", tableName, format];
    flag = [self executeUpdate:finalStr];
    return flag;
}

- (BOOL)rc_deleteTable:(NSString *)tableName toRow:(NSInteger)row {
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"DELETE FROM %@ WHERE pkid IN(SELECT pkid FROM %@ LIMIT %zd)", tableName, tableName, row];
    flag = [self executeUpdate:finalStr];
    return flag;
}

#pragma mark - 更新数据
- (BOOL)rc_updateTable:(NSString *)tableName model:(id)model whereFormat:(NSString *)format {
    BOOL flag = false;
    NSArray *columnArray = [self rc_getColumnArray:tableName];
    if ([model isKindOfClass:[NSObject class]]) {
        NSDictionary *dict = [self rc_getModelpropertyKeyValue:model tableName:tableName columnArray:columnArray];
        
        NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
        NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *key in dict) {
            if (![columnArray containsObject:key] || [key isEqualToString:@"pkid"]) { continue; }
            [finalStr appendFormat:@"%@ = %@,", key, @"?"];
            [argumentsArr addObject:dict[key]];
        }
        
        [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length - 1, 1)];
        
        if (format.length) {
            [finalStr appendFormat:@" %@", format];
        }
        
        flag = [self executeUpdate:finalStr withArgumentsInArray:argumentsArr];
        return flag;
    }
    
    return flag;
}

#pragma mark - 查询数据
- (NSArray *)rc_searchTable:(NSString *)tableName whereFormat:(NSString *)format {
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSString *finalStr = [NSString stringWithFormat:@"select * from %@ %@", tableName, (format ? format : @"")];
    
    NSArray *columnArray = [self rc_getColumnArray:tableName];
    FMResultSet *set = [self executeQuery:finalStr];
    
    if (self.bindModelClass) {
        Class aClass = self.bindModelClass;
        NSDictionary *propertyType = [self rc_modelToDict:aClass excludePropertyNames:nil];
        NSError *error = nil;
        @try {
            while ([set nextWithError:&error]) {
                id model = aClass.new;
                for (NSString *name in columnArray) {
                    if ([propertyType[name] isEqualToString:@"TEXT"]) {
                        id value = [set stringForColumn:name];
                        if (value) {
                            [model setValue:value forKey:name];
                        }
                    } else if ([propertyType[name] isEqualToString:@"INTEGER"]) {
                        [model setValue:@([set longLongIntForColumn:name]) forKey:name];
                    } else if ([propertyType[name] isEqualToString:@"REAL"]) {
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    } else if ([propertyType[name] isEqualToString:@"BIT"]) {
                        [model setValue:[NSNumber numberWithBool:[set boolForColumn:name]] forKey:name];
                    } else if ([propertyType[name] isEqualToString:@"BLOB"]) {
                        NSData *data = [set dataForColumn:name];
                        if (data) {
                            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                            [model setValue:obj forKey:name];
                        }
                    }
                }
                [resultMArr addObject:model];
            }
        } @catch (NSException *exception) {
        }
        return resultMArr;
    }
    
    return nil;
}

#pragma mark - 模型转化为字典
- (NSDictionary *)rc_modelToDict:(Class)aClass excludePropertyNames:(NSArray *)names {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    for (int i = 0; i < count; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([names containsObject:name]) { continue; }
        
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        id value = [self rc_propertyTypeConvert:type];
        if (value) {
            [mDict setObject:value forKey:name];
        }
    }
    
    free(properties);
    
    return mDict;
}

- (NSString *)rc_propertyTypeConvert:(NSString *)typeStr {
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        /// 文本类型
        resultStr = @"TEXT";
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        /// 整数类型 int、long、integer...
        resultStr = @"INTEGER";
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]) {
        /// 浮点型
        resultStr = @"REAL";
    } else if ([typeStr hasPrefix:@"T@\"NSData\""] || [typeStr hasPrefix:@"T@\"NSMutableData\""] || [typeStr hasPrefix:@"T@\"NSDate\""] || [typeStr hasPrefix:@"T@\"NSDictionary\""]) {
        resultStr = @"BLOB";
    } else {

    }
    return resultStr;
}

- (NSDictionary *)rc_getModelpropertyKeyValue:(id)model tableName:(NSString *)tableName columnArray:(NSArray *)columnArray {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    for (int i = 0; i < count; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if (![columnArray containsObject:name]) {
            continue;
        }
        
        id value = [model valueForKey:name];
        if (!value) {
            continue;
        }
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        if ([[self rc_propertyTypeConvert:type] isEqualToString:@"BLOB"]) {
            if ([value conformsToProtocol:@protocol(NSCoding)]) {
                value = [NSKeyedArchiver archivedDataWithRootObject:value];
            }
        }
         [mDict setObject:value forKey:name];
    }
    
    free(properties);
    return mDict;
}

#pragma mark - 删除表
- (BOOL)rc_deleteTable:(NSString *)tableName {
    NSString *sqlStr = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    return [self executeUpdate:sqlStr];
}

#pragma mark - 清空表
- (BOOL)rc_clearAllDataFromTable:(NSString *)tableName {
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    return [self executeUpdate:sqlStr];
}


@end
