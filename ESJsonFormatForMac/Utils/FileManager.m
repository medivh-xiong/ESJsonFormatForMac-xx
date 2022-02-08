//
//  FileManager.m
//  ESJsonFormatForMac
//
//  Created by zx on 17/6/13.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "FileManager.h"
#import "ESJsonFormat.h"

@implementation FileManager

+ (FileManager *)sharedInstance
{
    static FileManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)handleBaseData:(NSString *)folderPath
             hFileName:(NSString *)hFileName
             mFileName:(NSString *)mFileName
              hContent:(NSString *)hContent
              mContent:(NSString *)mContent
{
    NSString *des = [[NSUserDefaults standardUserDefaults] objectForKey:@"Des"];
    NSString *projectName = [[NSUserDefaults standardUserDefaults] objectForKey:@"project"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (userName.length <= 0) {
        userName = @"medivh";
    }

//    NSString *modelStr = [NSString stringWithFormat:@"//\n//Created by ESJsonFormatForMac on %@.\n//\n\n",[self getDateStr]];
    NSString *modelStrH = [NSString stringWithFormat:@"//\n"
                                                    "//  %@\n"
                                                    "//  %@\n"
                                                    "//\n"
                                                    "//  Created by %@ on %@.\n"
                                                    "//  Copyright © %@ %@. All rights reserved.\n"
                                                    "//  %@\n\n", hFileName, projectName, userName, self.getDateStr, self.getYearStr, userName, des];

    NSString *modelStrM = [NSString stringWithFormat:@"//\n"
                                                     "//  %@\n"
                                                     "//  %@\n"
                                                     "//\n"
                                                     "//  Created by %@ on %@.\n"
                                                     "//  Copyright © %@ %@. All rights reserved.\n"
                                                     "//  %@\n\n", mFileName, projectName, userName, self.getDateStr, self.getYearStr, userName, des];
    NSMutableString *hImportStr = nil;
    NSString *mImportStr = nil;
    NSString *newHContent = nil;
    NSString *newMContent = nil;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isSwift"]) {

        hImportStr = [NSMutableString stringWithString:@"#import <Foundation/Foundation.h>\n"];
        NSString *superClassString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SuperClass"];
        if (superClassString && superClassString.length > 0) {
            [hImportStr appendString:[NSString stringWithFormat:@"#import \"%@.h\" \n\n", superClassString]];
        } else {
            [hImportStr appendString:@"\n"];
        }
        mImportStr = [NSString stringWithFormat:@"#import \"%@\"\n\n", hFileName];
        newHContent = [NSString stringWithFormat:@"%@%@%@", modelStrH, hImportStr, hContent];
        newMContent = [NSString stringWithFormat:@"%@%@%@", modelStrM, mImportStr, mContent];
    } else {
        hImportStr = [NSMutableString stringWithString:@"import UIKit\n\n"];
        NSString *superClassString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SuperClass"];
        if (superClassString && superClassString.length > 0) {
            [hImportStr appendString:[NSString stringWithFormat:@"import %@ \n\n", superClassString]];
        }
        newHContent = [NSString stringWithFormat:@"%@%@%@", modelStrH, hImportStr, hContent];
    }
    [self createFileWithFolderPath:folderPath hFileName:hFileName mFileName:mFileName hContent:newHContent mContent:newMContent];
}

- (void)createFileWithFolderPath:(NSString *)folderPath
                       hFileName:(NSString *)hFileName
                       mFileName:(NSString *)mFileName
                        hContent:(NSString *)hContent
                        mContent:(NSString *)mContent
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isSwift"]) {
        //创建.h文件
        [self createFileWithFileName:[folderPath stringByAppendingPathComponent:hFileName] content:hContent];
        //创建.m文件
        [self createFileWithFileName:[folderPath stringByAppendingPathComponent:mFileName] content:mContent];
    } else {
        //创建.swift文件
        [self createFileWithFileName:[folderPath stringByAppendingPathComponent:hFileName] content:hContent];
    }
}

- (void)createFileWithFileName:(NSString *)FileName content:(NSString *)content
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createFileAtPath:FileName contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

- (NSString *)getDateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)getYearStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    return [formatter stringFromDate:[NSDate date]];
}


@end
