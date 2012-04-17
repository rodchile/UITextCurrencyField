//
//  ViewController.m
//  UITextCurrencyView
//
//  Created by Rodrigo Garcia on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Formatter.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated{
    if([[Formatters currencyFormatter] maximumFractionDigits] > 0){
        [currencyBox setText:@"0.00"];
    } else {
        [currencyBox setText:@"0"];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableCharacterSet *numberSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [numberSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet *nonNumberSet = [numberSet invertedSet];
    
    BOOL result = NO;
    
    if([string length] == 0){ 
        result = YES;
    }
    else{
        if([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0){
            result = YES;
        }
    }
    
    if(result){
        NSMutableString* mstring = [[textField text] mutableCopy];
        
        if([string length] > 0){
            [mstring insertString:string atIndex:range.location];
        }
        else {
            [mstring deleteCharactersInRange:range];
        }
        
        NSLocale* locale = [NSLocale currentLocale];
        NSString *localCurrencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
        NSString *localGroupingSeparator = [locale objectForKey:NSLocaleGroupingSeparator];
        
        NSString* clean_string = [[mstring stringByReplacingOccurrencesOfString:localGroupingSeparator 
                                                                     withString:@""]
                                  stringByReplacingOccurrencesOfString:localCurrencySymbol 
                                  withString:@""];
        
        if([[Formatters currencyFormatter] maximumFractionDigits] > 0){
            NSMutableString *mutableCleanString = [clean_string mutableCopy];
            
            if([string length] > 0){
                NSRange theRange = [mutableCleanString rangeOfString:@"."];
                [mutableCleanString deleteCharactersInRange:theRange];
                [mutableCleanString insertString:@"." atIndex:(theRange.location + 1)];
                clean_string = mutableCleanString;
            }
            else {
                [mutableCleanString insertString:@"0" atIndex:0];
                NSRange theRange = [mutableCleanString rangeOfString:@"."];
                [mutableCleanString deleteCharactersInRange:theRange];
                [mutableCleanString insertString:@"." atIndex:(theRange.location - 1)];
                clean_string = mutableCleanString;
            }
        }
        
        NSNumber* number = [[Formatters basicFormatter] numberFromString: clean_string];
        NSMutableString *numberString = [[[Formatters currencyFormatter] stringFromNumber:number] mutableCopy];
        [numberString deleteCharactersInRange:NSMakeRange(0, 1)];
        [textField setText:numberString];
    }
    return NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
