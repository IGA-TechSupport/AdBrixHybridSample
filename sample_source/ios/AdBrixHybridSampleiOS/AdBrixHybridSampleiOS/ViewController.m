//
//  ViewController.m
//  AdBrixHybridSampleiOS
//
//  Created by igaworks on 2017. 11. 7..
//  Copyright © 2017년 igaworks. All rights reserved.
//

#import "ViewController.h"
#import <IgaworksCore/IgaworksCore.h>
#import <AdBrix/AdBrix.h>
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [IgaworksCore igaworksCoreWithAppKey:@"558024754" andHashKey:@"d0ead817ff8247e0"];//DigiClock
    
    // set log level
    [IgaworksCore setLogLevel:IgaworksCoreLogTrace];
    
    NSString *urlString = @"https://s3-ap-northeast-1.amazonaws.com/static.adbrix.igaworks.com/tech_support/adbrix/hybrid_web/adbrixHybrid.html";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_igaworksWebView setDelegate:self];
    [_igaworksWebView loadRequest:urlRequest];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callObjectiveCFromJavascript
{
    NSLog(@"called objective-c from javascript");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([[[request URL] absoluteString] hasPrefix:@"adbrix:"])
    {
        NSString *requestString = [[request URL] absoluteString];
        NSArray *components = [requestString componentsSeparatedByString:@"://"];
        NSString *pDataString = [components objectAtIndex:1];
        NSString *pFunctionName;
        NSScanner *scanner = [NSScanner scannerWithString:pDataString];
        [scanner scanUpToString:@"?" intoString:&pFunctionName];
        
        NSLog(@"parameters : %@", [self getURLParmaters:[request URL]]);
        
        if([pFunctionName containsString:@"fte"])
        {
            [AdBrix firstTimeExperience: [[self getURLParmaters:[request URL]] valueForKey:@"activity"]];
        }
        else if([pFunctionName containsString:@"ret"])
        {
            [AdBrix retention: [[self getURLParmaters:[request URL]] valueForKey:@"activity"]];
        }
        else if([pFunctionName containsString:@"purchase"])
        {
            NSArray* categoryList = [[[self getURLParmaters:[request URL]] valueForKey:@"category"] componentsSeparatedByString:@"."];
            NSString* categoryString[5];
            for (int i=0; i<categoryList.count; ++i)
            {
                categoryString[i] = categoryList[i];
            }
            
            
            [AdBrix commercePurchase:[[self getURLParmaters:[request URL]] valueForKey:@"oid"] product:[AdBrix createCommerceProductModel:[[self getURLParmaters:[request URL]] valueForKey:@"pid"]
                                                                                     productName:[[self getURLParmaters:[request URL]] valueForKey:@"pname"]
                                                                                           price:[[[self getURLParmaters:[request URL]] valueForKey:@"price"] doubleValue]
                                                                                        discount:0.0
                                                                                        quantity:[[[self getURLParmaters:[request URL]] valueForKey:@"quantity"] integerValue]
                                                                                  currencyString:[[self getURLParmaters:[request URL]] valueForKey:@"currency_code"]
                                                                                        category:[AdBrixCommerceProductCategoryModel create:categoryString[0] category2:categoryString[1] category3:categoryString[2] category4:categoryString[3] category5:categoryString[4]]
                                                                                   extraAttrsMap:nil
                                                  ] discount:0.0 deliveryCharge:0.0 paymentMethod:@"" atrrData:nil];
        }
        return NO;
    }
    
    return YES;
}

-  (NSDictionary *)getURLParmaters:(NSURL *)URL
{
    NSMutableDictionary *parameters = nil;
    
    NSString *query = [URL query];
    if (query.length > 0)
    {
        NSArray *components = [query componentsSeparatedByString:@"&"];
        parameters = [[NSMutableDictionary alloc] init];
        for (NSString *component in components)
        {
            NSArray *subcomponents = [component componentsSeparatedByString:@"="];
            if(subcomponents.count == 2)
            {
                [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                               forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                [parameters setObject:@"" forKey:[component stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    
    return parameters;
}

@end
