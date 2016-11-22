//
//  Database.m
//  DbExample
//
//  Created by mac on 08/02/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "Database.h"

static Database *db;
@implementation Database

+(Database *)shareddatabase
{
    if(!db)
    {
        db=[[Database alloc]init];
        return db;
    }
    else
    {
        return db;
    }
}

-(id)init
{
    if (!db)
    {
        db=[super init];
        
    }
    else
    {
        @throw [NSException exceptionWithName:@"invalid method called" reason:@"use shareddatabase method" userInfo:NULL];
    }
    return db;
}

-(NSString *)getDatabasePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cube_DB.sqlite"];
}



-(void)insertDepartMentData:(NSArray*)deptArray
{
    for (int i=0; i<deptArray.count; i++)
    {
        DepartMent* deptObj= [deptArray objectAtIndex:i];
        NSString *query3=[NSString stringWithFormat:@"INSERT INTO DepartMentList values(\"%ld\",\"%@\")",deptObj.Id,deptObj.departmentName];
        
        Database *db=[Database shareddatabase];
        NSString *dbPath=[db getDatabasePath];
        sqlite3_stmt *statement;
        sqlite3* feedbackAndQueryTypesDB;
        
        
        const char * queryi3=[query3 UTF8String];
        if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
        {
            sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
               // NSLog(@"report data inserted");
               // NSLog(@"%@",NSHomeDirectory());
                sqlite3_reset(statement);
            }
            else
            {
               // NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
            }
        }
        else
        {
            //NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        
        if (sqlite3_finalize(statement) == SQLITE_OK)
        {
            //NSLog(@"statement is finalized");
        }
        else
           // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        
        
        if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
        {
            //NSLog(@"db is closed");
        }
        else
        {
            //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
        

    }
    
    
    
    }


-(NSMutableArray*)getDepartMentNames
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    NSString* companyId;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableArray* departmentNameArray=[[NSMutableArray alloc]init];;
    NSString *query3=[NSString stringWithFormat:@"Select DepartMentName from DepartMentList"];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
               companyId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                [departmentNameArray addObject:companyId];
                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
    {
    }
        //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

    
    return departmentNameArray;
}

-(DepartMent*)getDepartMentFromDepartmentName:(NSString*)name
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    DepartMent* obj=[[DepartMent alloc]init];

    NSString *query3=[NSString stringWithFormat:@"Select * from DepartMentList Where DepartMentName='%@'",name];

    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                obj.Id=sqlite3_column_int(statement, 0);

                obj.departmentName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
    {
    }
       // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       // NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return obj;
}

-(int)getCountOfTransfersOfDicatationStatus:(NSString*)status
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    int count;
    NSString *query3;
    if ([status isEqualToString:@"RecordingComplete"])
    {
        query3=[NSString stringWithFormat:@"Select Count(RecordItemName) from CubeData Where DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') or DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') and (TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@') or TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@'))",status,@"RecordingFileUpload",@"NotTransferred",@"Resend"];
    }
    else
    query3=[NSString stringWithFormat:@"Select Count(RecordItemName) from CubeData Where DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@')",status];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
              //  count=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
              count=  sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
       // NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
    {
    }  // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return count;
}

-(int)getCountOfTodaysTransfer:(NSString*)dateAndTimeString
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    int count;
    
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    
    dateAndTimeString=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]];
    NSString *query3=[NSString stringWithFormat:@"Select Count(RecordItemName) from CubeData Where TransferStatus=(Select Id from TransferStatus Where TransferStatus='Transferred') and TransferDate LIKE '%@%%'",dateAndTimeString];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //  count=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                count=  sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
       // NSLog(@"statement is finalized");
    }
    else
    {
    }
       //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return count;

}


-(int)getCountOfTransferFailed
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    int count;
    NSString *query3=[NSString stringWithFormat:@"Select Count(RecordItemName) from CubeData Where TransferStatus=(Select Id from TransferStatus Where TransferStatus='TransferFailed')"];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //  count=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                count=  sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
        //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return count;
}

//RecordItemName,RecordCreatedDate,DepartmentName

-(NSMutableArray*)getListOfFileTransfersOfStatus:(NSString*)status
{
  
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement1,*statement2,*statement3,*statement4;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    NSMutableArray* listArray=[[NSMutableArray alloc]init];
    NSString* RecordItemName,*RecordCreatedDate,*Department,*TransferStatus,*CurrentDuration,*transferDate,*deleteStatus,*dictationStatus;
    NSString *query3;
    NSString* dateAndTimeString= [[APIManager sharedManager] getDateAndTimeString];
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    
    dateAndTimeString=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]];

    if ([status isEqualToString:@"Transferred"])
    {
               query3=[NSString stringWithFormat:@"Select RecordItemName,RecordCreateDate,Department,TransferStatus,CurrentDuration,TransferDate,DeleteStatus,DictationStatus from CubeData Where TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@') and TransferDate LIKE '%@%%'",status,dateAndTimeString];

    }
    else
   // query3=[NSString stringWithFormat:@"Select RecordItemName,RecordCreateDate,Department,TransferStatus,CurrentDuration from CubeData Where DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@' or RecordingStatus='%@') and TransferStatus=%d",status,@"RecordingFileUpload",0];
        if ([status isEqualToString:@"RecordingComplete"])
        {

    query3=[NSString stringWithFormat:@"Select RecordItemName,RecordCreateDate,Department,TransferStatus,CurrentDuration,TransferDate,DeleteStatus,DictationStatus from CubeData Where DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') or DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') and (TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@') or TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@'))",status,@"RecordingFileUpload",@"NotTransferred",@"Resend"];
        }
    
    else
        if ([status isEqualToString:@"TransferFailed"])
        {
         query3=[NSString stringWithFormat:@"Select RecordItemName,RecordCreateDate,Department,TransferStatus,CurrentDuration,TransferDate,DeleteStatus,DictationStatus from CubeData Where TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@')",status];
    
        }
    else
        if ([status isEqualToString:@"RecordingPause"])
        {
            
            query3=[NSString stringWithFormat:@"Select RecordItemName,RecordCreateDate,Department,TransferStatus,CurrentDuration,TransferDate,DeleteStatus,DictationStatus from CubeData Where DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@')",status];
        }

    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                  RecordItemName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                RecordCreatedDate=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                Department=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                TransferStatus=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                CurrentDuration=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                transferDate=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];
                deleteStatus=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 6)];
                dictationStatus=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 7)];

                NSString *query4=[NSString stringWithFormat:@"Select DepartMentName from DepartMentList Where Id='%@'",Department];

                    if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query4 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                    {
                        while (sqlite3_step(statement1) == SQLITE_ROW)
                        {
                            Department=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 0)];
                        }
                    }
                    else
                    {
                       // NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                
                    if (sqlite3_finalize(statement1) == SQLITE_OK)
                    {
                      //NSLog(@"statement1 is finalized");
                    }
                    else
                    {}
                     //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));

                
                
                
                NSString *query5=[NSString stringWithFormat:@"Select TransferStatus from TransferStatus Where Id='%@'",TransferStatus];
                
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query5 UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        TransferStatus=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement2, 0)];
                    }
                }
                else
                {
//                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement2) == SQLITE_OK)
                {
//                    NSLog(@"statement1 is finalized");
                }
                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                {}
                
                
                NSString *query6=[NSString stringWithFormat:@"Select DeleteStatus from DeleteStatus Where Id='%@'",deleteStatus];
                
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query6 UTF8String], -1, &statement3, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement3) == SQLITE_ROW)
                    {
                        deleteStatus=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement3, 0)];
                    }
                }
                else
                {
//                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement3) == SQLITE_OK)
                {
//                    NSLog(@"statement1 is finalized");
                }
                else
//                    NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                {}
               
                
                NSString *query7=[NSString stringWithFormat:@"Select RecordingStatus from DictationStatus Where Id='%@'",dictationStatus];
                
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query7 UTF8String], -1, &statement4, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement4) == SQLITE_ROW)
                    {
                        dictationStatus=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement4, 0)];
                    }
                }
                else
                {
//                    NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement4) == SQLITE_OK)
                {
                   // NSLog(@"statement1 is finalized");
                }
                else
                    //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                {}
                dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:RecordItemName,@"RecordItemName",RecordCreatedDate,@"RecordCreatedDate",Department,@"Department",TransferStatus,@"TransferStatus",CurrentDuration,@"CurrentDuration",transferDate,@"TransferDate",deleteStatus,@"DeleteStatus",dictationStatus,@"DictationStatus",nil];
                [listArray addObject:dict];
            }
            
            
        }
        else
        {
           // NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
        //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {}
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
       // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return listArray;

}

-(NSString*)getDepartMentIdFromDepartmentName:(NSString*)departmentName;
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    NSString* departmentId;
    NSString *query3=[NSString stringWithFormat:@"Select Id from DepartMentList Where DepartMentName='%@'",departmentName];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                  departmentId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
       // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       // NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return departmentId;

}
-(int)getDepartMentIdForFileName:(NSString*)fileName;
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    int departmentId;
    NSString *query3=[NSString stringWithFormat:@"Select Department from CubeData Where RecordItemName='%@'",fileName];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
//                departmentId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                departmentId=sqlite3_column_int(statement, 0);

                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
        // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        // NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return departmentId;


}
-(void)insertRecordingData:(NSDictionary*)dict;
{
    
                NSString *query3=[NSString stringWithFormat:@"INSERT INTO CubeData values(\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\",\"%@\",\"%@\",\"%d\",\"%d\",\"%d\",\"%@\")",[dict valueForKey:@"recordItemName"],[dict valueForKey:@"recordCreatedDate"],[dict valueForKey:@"recordingDate"],[dict valueForKey:@"transferDate"],[[dict valueForKey:@"dictationStatus"]intValue],[[dict valueForKey:@"transferStatus"]intValue],[[dict valueForKey:@"deleteStatus"]intValue],[dict valueForKey:@"deleteDate"],[dict valueForKey:@"fileSize"],[dict valueForKey:@"currentDuration"],[[dict valueForKey:@"newDataUpdate"]intValue],[[dict valueForKey:@"newDataSend"]intValue],[[dict valueForKey:@"mobileDictationIdVal"]intValue],[dict valueForKey:@"departmentName"]];
    
                Database *db=[Database shareddatabase];
                NSString *dbPath=[db getDatabasePath];
                sqlite3_stmt *statement;
                sqlite3* feedbackAndQueryTypesDB;
    
    
                const char * queryi3=[query3 UTF8String];
                if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
                {
                    sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
                    if(sqlite3_step(statement)==SQLITE_DONE)
                    {
                        //NSLog(@"report data inserted");
                        //NSLog(@"%@",NSHomeDirectory());
                        sqlite3_reset(statement);
                    }
                    else
                    {
                        //NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                    }
                }
                else
                {
                    //NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
    
                if (sqlite3_finalize(statement) == SQLITE_OK)
                {
                    //NSLog(@"statement is finalized");
                }
                else
                    //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                {}
    
                if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
                {
                    //NSLog(@"db is closed");
                }
                else
                {
                    //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }

}


-(void)updateAudioFileName:(NSString*)existingAudioFileName dictationStatus:(NSString*)status;
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') Where RecordItemName='%@'",status,existingAudioFileName];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
      sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
      if(sqlite3_step(statement)==SQLITE_DONE)
        {
           // NSLog(@"report data inserted");
            //NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
            //NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
        //NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
   // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
       // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
                


}

-(void)updateAudioFileName:(NSString*)existingAudioFileName duration:(float)duration;
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set CurrentDuration=%f Where RecordItemName='%@'",duration,existingAudioFileName];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            //NSLog(@"report data inserted");
            //NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
            //NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
        //NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
        //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {}
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       // NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }

}


-(NSMutableArray*)getListOfTransferredOrDeletedFiles:(NSString*)listName
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement1,*statement2;
    sqlite3* feedbackAndQueryTypesDB;
    NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
    NSMutableArray* listArray=[[NSMutableArray alloc]init];
    NSString* RecordItemName,*Date,*Department,*RecordCreateDate,*status,*transferDate;
    NSString* query3,*statusQuery;
    if ([listName isEqual:@"Transferred"])
    {
        query3=[NSString stringWithFormat:@"Select RecordItemName,TransferDate,Department,RecordCreateDate,DeleteStatus,TransferDate from CubeData Where TransferStatus=(Select Id from TransferStatus Where TransferStatus='Transferred') and DeleteStatus!=%d",1];
        
        statusQuery=[NSString stringWithFormat:@"Select DeleteStatus from DeleteStatus Where Id='%@'",status];
    }
    if ([listName isEqual:@"Deleted"])
    {
        query3=[NSString stringWithFormat:@"Select RecordItemName,DeleteDate,Department,RecordCreateDate,TransferStatus,TransferDate from CubeData Where DeleteStatus=1"];
        statusQuery=[NSString stringWithFormat:@"Select TransferStatus from TransferStatus Where Id='%@'",status];

    }
//    NSString *query3=[NSString stringWithFormat:@"Select RecordItemName,RecordCreateDate,Department,TransferStatus,CurrentDuration from CubeData Where DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@')",status];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                RecordItemName=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                Date=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                Department=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                RecordCreateDate=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                status=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 4)];
                transferDate=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 5)];

                NSString *query4=[NSString stringWithFormat:@"Select DepartMentName from DepartMentList Where Id='%@'",Department];
                
                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query4 UTF8String], -1, &statement1, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement1) == SQLITE_ROW)
                    {
                        Department=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement1, 0)];
                    }
                }
                else
                {
                    //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement1) == SQLITE_OK)
                {
                    //NSLog(@"statement1 is finalized");
                }
                else
                    //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                {}
                
                if ([listName isEqual:@"Transferred"])
                {
                    statusQuery=[NSString stringWithFormat:@"Select DeleteStatus from DeleteStatus Where Id='%@'",status];
                }
                if ([listName isEqual:@"Deleted"])
                {
                    statusQuery=[NSString stringWithFormat:@"Select TransferStatus from TransferStatus Where Id='%@'",status];
                    
                }

                if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [statusQuery UTF8String], -1, &statement2, NULL) == SQLITE_OK)// 2. Prepare the query
                {
                    while (sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        status=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement2, 0)];
                    }
                }
                else
                {
                    //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                }
                
                if (sqlite3_finalize(statement2) == SQLITE_OK)
                {
                   // NSLog(@"statement1 is finalized");
                }
                else
                   // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
                {
                }
                
                dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:RecordItemName,@"RecordItemName",Date,@"Date",Department,@"Department",RecordCreateDate,@"RecordCreateDate",status,@"status",transferDate,@"TransferDate", nil];
                [listArray addObject:dict];
            }
            
            
        }
        else
        {
           // NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
       // NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
       // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {}
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
       // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return listArray;
    

}


-(void)updateAudioFileStatus:(NSString*)status fileName:(NSString*)fileName dateAndTime:(NSString*)dateAndTimeString;
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@'),DeleteStatus=1,DeleteDate='%@' Where RecordItemName='%@'",status,dateAndTimeString,fileName];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            //NSLog(@"report data inserted");
            //NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
            //NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
        //NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
       // NSLog(@"statement is finalized");
    }
    else
       // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
}

-(void)updateAudioFileUploadedStatus:(NSString*)status fileName:(NSString*)fileName dateAndTime:(NSString*)dateAndTimeString mobiledictationidval:(long) idval;
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@'),TransferDate='%@',mobiledictationidval=%ld Where RecordItemName='%@'",status,dateAndTimeString,idval,fileName];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
           // NSLog(@"report data inserted");
            //NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
           // NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
        //NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
        //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {}
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
       // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
}



-(void)updateAudioFileStatus:(NSString*)status fileName:(NSString*)fileName
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') Where RecordItemName='%@'",status,fileName];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
           // NSLog(@"report data inserted");
           // NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
           // NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
       // NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
       // NSLog(@"statement is finalized");
    }
    else
       // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       // NSLog(@"db is closed");
    }
    else
    {
        //NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    
}


-(void)updateDemo:(NSString* )fileName
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') Where RecordItemName='%@'",@"RecordingComplete",fileName];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
           // NSLog(@"report data inserted");
           // NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
           // NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
       // NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
       // NSLog(@"statement is finalized");
    }
    else
        //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
       // NSLog(@"db is closed");
    }
    else
    {
       // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
}

-(int)getMobileDictationIdFromFileName:(NSString*)fileName;
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    int mobiledictationidval;
    NSString *query3=[NSString stringWithFormat:@"Select mobiledictationidval from CubeData Where RecordItemName='%@'",fileName];
    
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
//                departmentId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                mobiledictationidval=sqlite3_column_int(statement, 0);

            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
       // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {}
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
       // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return mobiledictationidval;
    
}


-(void)updateUploadingFileDictationStatus
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') Where TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@') and DictationStatus=(Select Id from DictationStatus Where RecordingStatus='%@') ",@"RecordingComplete",@"NotTransferred",@"RecordingFileUpload"];
    
    NSString *query4=[NSString stringWithFormat:@"Update CubeData set TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@') Where TransferStatus=(Select Id from TransferStatus Where TransferStatus='%@')",@"Transferred",@"Resend"];
    
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement,*statement1;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
           // NSLog(@"report data inserted");
           // NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
            //NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
        //NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
       // NSLog(@"statement is finalized");
    }
    else
      //  NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {}
    
    //
    const char * queryi4=[query4 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi4, -1, &statement1, NULL);
        if(sqlite3_step(statement1)==SQLITE_DONE)
        {
           // NSLog(@"report data inserted");
           // NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement1);
        }
        else
        {
           // NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
       // NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement1) == SQLITE_OK)
    {
       // NSLog(@"statement1 is finalized");
    }
    else
    {}
       // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    //
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
       // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
}

-(int)getTransferStatus:(NSString*)fileName
{
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    int transferStatus;
    NSString *query3=[NSString stringWithFormat:@"Select TransferStatus from CubeData Where RecordItemName='%@'",fileName];
    
    if(sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB) == SQLITE_OK)// 1. Open The DataBase.
    {
        if (sqlite3_prepare_v2(feedbackAndQueryTypesDB, [query3 UTF8String], -1, &statement, NULL) == SQLITE_OK)// 2. Prepare the query
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                // [app.feedOrQueryDetailMessageArray addObject:[NSString stringWithUTF8String:message]];
                //                departmentId=[NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                transferStatus=sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            //NSLog(@"Can't preapre query due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    else
    {
        //NSLog(@"can't open db due error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        //NSLog(@"statement is finalized");
    }
    else
        // NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {}
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        //NSLog(@"db is closed");
    }
    else
    {
        // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    
    return transferStatus;

}


-(void)updateDepartment:(long)deptId fileName:(NSString*)fileName
{
    
    NSString *query3=[NSString stringWithFormat:@"Update CubeData set Department=%ld Where RecordItemName='%@'",deptId,fileName];
    Database *db=[Database shareddatabase];
    NSString *dbPath=[db getDatabasePath];
    sqlite3_stmt *statement;
    sqlite3* feedbackAndQueryTypesDB;
    
    
    const char * queryi3=[query3 UTF8String];
    if (sqlite3_open([dbPath UTF8String], &feedbackAndQueryTypesDB)==SQLITE_OK)
    {
        sqlite3_prepare_v2(feedbackAndQueryTypesDB, queryi3, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE)
        {
            // NSLog(@"report data inserted");
            // NSLog(@"%@",NSHomeDirectory());
            sqlite3_reset(statement);
        }
        else
        {
            // NSLog(@"%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
        }
    }
    
    else
    {
        // NSLog(@"errormsg=%s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
    if (sqlite3_finalize(statement) == SQLITE_OK)
    {
        // NSLog(@"statement is finalized");
    }
    else
        //NSLog(@"Can't finalize due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    {
    }
    
    if (sqlite3_close(feedbackAndQueryTypesDB) == SQLITE_OK)
    {
        // NSLog(@"db is closed");
    }
    else
    {
        // NSLog(@"Db is not closed due to error = %s",sqlite3_errmsg(feedbackAndQueryTypesDB));
    }
    
}


@end