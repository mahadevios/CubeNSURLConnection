//
//  DownloadMetaDataJob.m
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "DownloadMetaDataJob.h"
#include <sys/xattr.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

/*================================================================================================================================================*/

@implementation DownloadMetaDataJob
@synthesize downLoadEntityJobName;
@synthesize requestParameter;
@synthesize downLoadResourcePath;
@synthesize downLoadJobDelegate;
@synthesize httpMethod;

@synthesize addTrintsAfterSomeTimeTimer;
@synthesize currentSaveTrintIndex;
@synthesize isNewMatchFound;
@synthesize dataArray;
-(id) initWithdownLoadEntityJobName:(NSString *) jobName withRequestParameter:(id) localRequestParameter withResourcePath:(NSString *) resourcePath withHttpMethd:(NSString *) httpMethodParameter
{
    self = [super init];
    if (self)
    {
        self.downLoadResourcePath = resourcePath;
        //self.requestParameter = localRequestParameter;
        self.downLoadEntityJobName = [[NSString alloc] initWithFormat:@"%@",jobName];
        self.httpMethod=httpMethodParameter;
        self.dataArray=localRequestParameter;
        self.isNewMatchFound = [NSNumber numberWithInt:1];
    }
    return self;
}

/*================================================================================================================================================*/

#pragma mark -
#pragma mark StartMetaDataDownload
#pragma mark -

-(void)startMetaDataDownLoad
{
    [self sendNewRequestWithResourcePath:downLoadResourcePath withRequestParameter:dataArray withJobName:downLoadEntityJobName withMethodType:httpMethod];
}


-(void) sendNewRequestWithResourcePath:(NSString *) resourcePath withRequestParameter:(NSMutableArray *)array withJobName:(NSString *)jobName withMethodType:(NSString *) httpMethodParameter
{
    responseData = [NSMutableData data];
    
//    NSArray *params = [self.requestParameter objectForKey:REQUEST_PARAMETER];
//    
//    NSMutableString *parameter = [[NSMutableString alloc] init];
//    for(NSString *strng in params)
//    {
//        if([[params objectAtIndex:0] isEqualToString:strng]) {
//            [parameter appendFormat:@"%@", strng];
//        } else {
//            [parameter appendFormat:@"&%@", strng];
//        }
//    }
    
    NSString *webservicePath = [NSString stringWithFormat:@"%@/%@",BASE_URL_PATH,resourcePath];
   // NSString *webservicePath = [NSString stringWithFormat:@"%@/%@?%@",BASE_URL_PATH,resourcePath,parameter];

    NSURL *url = [[NSURL alloc] initWithString:[webservicePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [request setHTTPMethod:httpMethodParameter];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError* error;
    
    //NSData *ciphertext = [RNEncryptor e
//    NSString* str=[NSString stringWithFormat:@"%@",array];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *encryptedData = [RNEncryptor encryptData:data
//                                        withSettings:kRNCryptorAES256Settings
//                                            password:SECRET_KEY
//                                               error:&error];
//    NSString *encString = [encryptedData base64EncodedStringWithOptions:0];
    
    NSDictionary* dic=[array objectAtIndex:0];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:&error];
    
    
    [request setHTTPBody:requestData];
//    NSError* error;
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:&error];


    
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"%@",urlConnection);
}




/*================================================================================================================================================*/

#pragma mark -
#pragma mark - URL connection callbacks
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    statusCode = (int)[httpResponse statusCode];
    ////NSLog(@"Status code: %d",statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSLog(@"%@",data);
    
	[responseData appendData:data];
}


- (NSString *)shortErrorFromError:(NSError *)error
{
   
    return [error localizedDescription];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed %@",error.description);
    NSLog(@"%@ Entity Job -",self.downLoadEntityJobName);
    
    
    if ([self.downLoadEntityJobName isEqualToString:CHECK_DEVICE_REGISTRATION])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ////NSLog(@"Success");
    
    NSError *error;
//    NSDictionary *response1 = [NSJSONSerialization JSONObjectWithData:responseData
//                                                                 options:NSUTF8StringEncoding
//                                                                   error:&error];
    
    
    NSString *encryptedResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSUTF8StringEncoding
                                                               error:&error];
    
    
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encryptedResponse options:0];
            NSData* data=[decodedData AES256DecryptWithKey:SECRET_KEY];
            NSString* responseString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *response;
    if (responseString!=nil)
    {
        responseString=[responseString stringByReplacingOccurrencesOfString:@"True" withString:@"1"];
        responseString=[responseString stringByReplacingOccurrencesOfString:@"False" withString:@"0"];
        
        NSData *responsedData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        response = [NSJSONSerialization JSONObjectWithData:responsedData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];

    }
    
//    NSString *response1 = [NSJSONSerialization JSONObjectWithData:responseData
//                                                             options:NSJSONReadingAllowFragments
//                                                               error:&error];
//    NSData *decryptedData = [RNDecryptor decryptData:responseData
//                                        withSettings:kRNCryptorAES256Settings
//                                            password:SECRET_KEY
//                                               error:&error];
//    NSString *encString = [decryptedData base64EncodedStringWithOptions:0];
    //NSLog(@"Job Name = %@ Response %@",self.downLoadEntityJobName,response);
    //NSLog(@"%@",response);
    
//    if ([self.downLoadEntityJobName isEqualToString:CHECK_DEVICE_REGISTRATION])
//    {
//        if (response != nil)
//        {
//            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_DEVICE_REGISTRATION object:response];
//                
//                
//            }else
//            {
//                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//            }
//        }else
//        {
//            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//        }
//    }
 
  



if([self.downLoadEntityJobName isEqualToString:CHECK_DEVICE_REGISTRATION])

{
    
    if (response != nil)
    {
//        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:response1 options:0];
//        NSData* data=[decodedData AES256DecryptWithKey:SECRET_KEY];
//        NSString* responseString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        responseString=[responseString stringByReplacingOccurrencesOfString:@"True" withString:@"1"];
//        responseString=[responseString stringByReplacingOccurrencesOfString:@"False" withString:@"0"];
//
//        NSData *responsedData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responsedData
//                                                                                options:NSJSONReadingAllowFragments
//                                                                                  error:&error];
        
        NSLog(@"%@",error);
//        const unsigned char *ptr = [data bytes];
//        
//        for(int i=0; i<[data length]; ++i) {
//            unsigned char c = *ptr++;
//            NSLog(@"char=%c hex=%x", c, c);
//        }
//
//        NSArray* arrayOfStrings = [strr componentsSeparatedByString:@","];
//
//        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayOfStrings options:NSJSONWritingPrettyPrinted error:&error];
//        NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//
//        NSString* sdf=[strr stringByReplacingOccurrencesOfString:@"," withString:@";"];
//        
//        NSData* dataone=[sdf dataUsingEncoding:NSUTF8StringEncoding];
//        
//       
//
//        id json = [NSJSONSerialization JSONObjectWithData:dataone options:NSJSONReadingAllowFragments error:nil];

       // NSString* sttt=[jsonResponse valueForKey:@"code"];
        NSString* code=[response objectForKey:RESPONSE_CODE];
        NSString* pinVerify=[response objectForKey:RESPONSE_PIN_VERIFY];

        
        if ([code intValue]==401 && [pinVerify intValue]==0)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_DEVICE_REGISTRATION object:response];
            
            
        }
        else
        if ([code intValue]==200 && [pinVerify intValue]==0)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_DEVICE_REGISTRATION object:response];
            
            
        }
        else
        if ([code intValue]==200 && [pinVerify intValue]==1)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_DEVICE_REGISTRATION object:response];
            
            
        }
        else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Can't connect to the sever, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}




if ([self.downLoadEntityJobName isEqualToString:AUTHENTICATE_API])
{
    
    if (response != nil)
    {
    [response objectForKey:@"code"];
        if ([[response objectForKey:@"code"]intValue]==200)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTHENTICATE_API object:response];
            
            
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AUTHENTICATE_API object:response];

        }
    }else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}
//
//
if ([self.downLoadEntityJobName isEqualToString:ACCEPT_PIN_API])
{
    
    if (response != nil)
    {
        
        if ([[response objectForKey:@"code"]intValue]==200)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCEPT_PIN_API object:response];
            
            
        }
        else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}
//
if ([self.downLoadEntityJobName isEqualToString:VALIDATE_PIN_API])
{
    
    if (response != nil)
    {
        
        if ([[response objectForKey:@"code"]intValue]==200)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VALIDATE_PIN_API object:response];
            
            
        }else
            if ([[response objectForKey:@"code"]intValue]==401)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VALIDATE_PIN_API object:response];
        }
    }else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}
//
//
if ([self.downLoadEntityJobName isEqualToString:DICTATIONS_INSERT_API])
{
    
    if (response != nil)
    {
        
        if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DICTATIONS_INSERT_API object:response];
            
            
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}
    
    if ([self.downLoadEntityJobName isEqualToString:DATA_SYNCHRONISATION_API])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DATA_SYNCHRONISATION_API object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
//
    
//    if ([self.downLoadEntityJobName isEqualToString:FILE_UPLOAD_API])
//    {
//        
//        if (response != nil)
//        {
//            
//            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FILE_UPLOAD_API object:response];
//                
//                
//            }else
//            {
//                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//            }
//        }else
//        {
//            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//        }
//    }

    
    if ([self.downLoadEntityJobName isEqualToString:PIN_CANGE_API])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"]intValue]==200)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PIN_CANGE_API object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Pin changed failed, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"Something went wrong, Something went wrong, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }


}

@end

/*================================================================================================================================================*/
