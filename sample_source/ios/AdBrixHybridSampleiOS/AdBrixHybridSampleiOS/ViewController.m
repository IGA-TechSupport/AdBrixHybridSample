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
    if ([[[request URL] scheme] isEqualToString:@"adbrix"])
    {
     
        NSString *pFunctionName = [[request URL] host];
        NSDictionary *adbrixEventDict = [self getURLParmaters:[request URL]];
        NSLog(@"parameters : %@", adbrixEventDict);
        
        if([pFunctionName containsString:@"fte"])
        {
            /*!
             @abstract
             first time experience의 Activity에 해당할때 호출한다.
             
             @param activityName              activity name.(mandatory)
             */
            [AdBrix firstTimeExperience: [adbrixEventDict valueForKey:@"activity"]];
        }
        else if([pFunctionName containsString:@"ret"])
        {
            /*!
             @abstract
             retension의 Activity에 해당할때 호출한다.
             
             @param activityName              activity name.(mandatory)
             */
            [AdBrix retention: [adbrixEventDict valueForKey:@"activity"]];
        }
        else if([pFunctionName containsString:@"purchase"])
        {
            NSArray* categoryList = [[adbrixEventDict valueForKey:@"category"] componentsSeparatedByString:@"."];
            NSString* categoryString[5];
            if([categoryList count] > 0)
            {
                for (int i=0; i<categoryList.count; ++i)
                {
                    categoryString[i] = categoryList[i];
                }
            }
            
            /*!
             @abstract
             purchase의 Activity에 해당할때 호출한다.
             
             @param string:orderId              order id.(mandatory)
             @param object:product              CommerceProductMedel's object.(mandatory)
             @param double:discount             value  of discount.(mandatory)
             @param double:deliveryCharge       value  of delivery charge.(mandatory)
             @param string:paymentMethod        payment method. (opnational)
             @param dictionary:atrrData         extra attrbute data. (opnational)
             */

            
            [AdBrix commercePurchase:[adbrixEventDict valueForKey:@"oid"]
             
                            /*!
                              @abstract
                              purchase의 CommerceProductMedel을 생성한다.
                              
                              @param string:productId            product id.(mandatory)
                              @param string:productName          product name.(mandatory)
                              @param double:price                value of price.(mandatory)
                              @param double:discount             value of discount.(mandatory)
                              @param int:quantity                value of quantity.(mandatory)
                              @param string:currencyString       currency.(opnational)
                              @param object:categories           AdBrixCommerceProductCategoryModel object.(opnational)
                              @param dictionary:atrrData         extra attrbute data.(opnational)
                              */
          
                             product:[AdBrix createCommerceProductModel:[adbrixEventDict valueForKey:@"pid"]
                                                            productName:[adbrixEventDict valueForKey:@"pname"]
                                                                  price:[[adbrixEventDict valueForKey:@"price"] doubleValue]
                                                               discount:0.0
                                                               quantity:[[adbrixEventDict valueForKey:@"quantity"] integerValue]
                                                         currencyString:[adbrixEventDict valueForKey:@"currency_code"]
                                      
                                                             /*!
                                                                   @abstract
                                                                   AdBrixCommerceProductCategoryModel의 AdBrixCommerceProductCategoryModel을 생성한다.
                                                                   최대 5개까지 생성할 수 있다.
                                                                   범주가 큰 카테고리부터 작은 순으로 인자를 집어넣는다
                                                              
                                                                   @param string:category1            category.(opnational)
                                                                   @param string:category2            category.(opnational)
                                                                   @param string:category3            category.(opnational)
                                                                   @param string:category4            category.(opnational)
                                                                   @param string:category5            category.(opnational)
                                                                   */
                                                               category:[AdBrixCommerceProductCategoryModel create:categoryString[0]
                                                                                                         category2:categoryString[1]
                                                                                                         category3:categoryString[2]
                                                                                                         category4:categoryString[3]
                                                                                                         category5:categoryString[4]
                                                                         ]
                                                           extraAttrsMap:nil
                                                  ]
                            discount:0.0
                      deliveryCharge:0.0
                       paymentMethod:[AdBrix paymentMethod:AdBrixPaymentCreditCard]
                            atrrData:nil];
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
