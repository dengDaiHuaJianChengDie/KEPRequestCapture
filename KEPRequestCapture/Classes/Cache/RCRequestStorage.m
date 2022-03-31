//
//  RCRequestStorage.m
//  KEPRequestCapture
//
//  Created by zhen li on 2022/1/6.
//

#import "RCRequestStorage.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase+RC.h"

#define KEP_REQUEST_INFO_CACHE_TABLE @"KEPRequestCache"

@interface RCRequestStorage ()

@property (nonatomic, strong) FMDatabaseQueue *dataBaseQueue;

@end

@implementation RCRequestStorage

+ (instancetype)sharedInstance {
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[RCRequestStorage alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithURL:[self diskCachePath]];
        [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db isOpen]) {
                BOOL ret = [db rc_createTableWithName:KEP_REQUEST_INFO_CACHE_TABLE initializeModel:[RCRequestModel class]];
                if (ret) {
                    NSLog(@"请求缓存数据库建表成功");
                }
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoCheckCleanCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

#pragma mark - Public Api

- (NSArray *)loadAllReuestsCache {
    __block NSArray *dataArray = nil;
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        dataArray = [db rc_searchTable:KEP_REQUEST_INFO_CACHE_TABLE whereFormat:nil];
    }];
    return dataArray;
}

/// 新增请求到缓存
/// @param requestModel 请求信息
- (void)saveRequest:(RCRequestModel *)requestModel {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db rc_insertTable:KEP_REQUEST_INFO_CACHE_TABLE model:requestModel];
    }];
}

#pragma mark - Private Api
- (NSURL *)diskCachePath {
    NSURL *pathUrl = [[NSFileManager defaultManager] URLsForDirectory:(NSCachesDirectory) inDomains:(NSUserDomainMask)].firstObject;
    pathUrl = [pathUrl URLByAppendingPathComponent:@"KEPReqInfo.sqlite"];
    return pathUrl;
}

#pragma mark - Clear API

/// 清除所有请求缓存信息
- (void)clearAllRequestCache {
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db rc_clearAllDataFromTable:KEP_REQUEST_INFO_CACHE_TABLE];
    }];
}

/// 检查是否需要清理内存缓存
- (void)autoCheckCleanCache {
    __block NSInteger columnCount = 0;
    [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        columnCount = db.lastInsertRowId;
    }];
    NSInteger limitRowCount = 1000;
    if (columnCount > limitRowCount) {
        [self.dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            [db rc_deleteTable:KEP_REQUEST_INFO_CACHE_TABLE toRow:limitRowCount / 2];
        }];
    }
}

@end
