//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
//导入头文件


@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  [self updateUIState];
  // handle text changes for both text fields
//  [self.usernameTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
//  [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
  // initially hide the failure message
    
  self.signInService = [RWDummySignInService new];
  self.signInFailureText.hidden = YES;
    
#if false
    
//  [self.usernameTextField.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
#elseif false
    //添加过滤信息
    
//    [[self.usernameTextField.rac_textSignal filter:^BOOL(id value) {
//        NSString *result = value;
//        return result.length > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"文本框中的信息是%@",x);
//    }];
    
#else
    
//    [[[self.usernameTextField.rac_textSignal map:^id(id value) {
//        NSString *result = value; //隐式转换
//        return @(result.length);
//    }] filter:^BOOL(NSNumber *value) {
//        return value.integerValue > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"当前文本的长度是%@",x);
//    }];
    
#endif
    
    //创建两个信号
    RACSignal * validUserNameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *value) {
        return @([self isValidUsername:value]);
    }];
    
    RACSignal * validPassWordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *value) {
        return @([self isValidPassword:value]);
    }];
    
    RAC(self.usernameTextField,backgroundColor) =  [validUserNameSignal map:^id(NSNumber *value) {
        return value.boolValue ? [UIColor blueColor]:[UIColor redColor];
    }];
    
    RAC(self.passwordTextField,backgroundColor) = [validPassWordSignal map:^id(NSNumber *value) {
        return  value.boolValue ? [UIColor blueColor] : [UIColor redColor];
    }];
    
    //登录信号
    RACSignal * signinSignal = [RACSignal combineLatest:@[validUserNameSignal,validPassWordSignal] reduce:^id(NSNumber * validUser,NSNumber * validPass){
        return @([validUser boolValue] && [validPass boolValue]);
    }];
    
    //订阅信息，或者说是绑定方法
    [signinSignal subscribeNext:^(NSNumber *enable) {
        self.signInButton.enabled = [enable boolValue];
    }];
    
    //事件控制信号
    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"输出的是什么内容%@",x);
        //显示的是Button的信息
    }];
    
    //把事件控制信号转换为登录信号
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        //附加操作
        self.signInButton.enabled = NO;
        self.signInFailureText.hidden = YES;
    }]flattenMap:^id(id value) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *x) {
        NSLog(@"登录结果是%@",x);
        self.signInButton.enabled = YES;
        BOOL success = x.boolValue;
        self.signInFailureText.hidden = success;
        if (success){
            [self performSegueWithIdentifier:@"signInSuccess" sender:self];
        }
    }];
    
     
    //根据上一步信号的返回值，利用map重新转换为uicolor的类型
#if false
//    [[validUserNameSignal map:^id(NSNumber *value) {
//        return value.boolValue ? [UIColor blueColor]:[UIColor redColor];
//    }] subscribeNext:^(UIColor *x) {
//        self.usernameTextField.backgroundColor = x;
//    }];
//    
//    [[validPassWordSignal map:^id(NSNumber *value) {
//        return  value.boolValue ? [UIColor blueColor] : [UIColor redColor];
//    }] subscribeNext:^(UIColor *x) {
//        self.passwordTextField.backgroundColor = x;
//    }];
    
#endif
    
}

- (BOOL)isValidUsername:(NSString *)username {
  return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
  return password.length > 3;
}

-(RACSignal *)signInSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

//- (IBAction)signInButtonTouched:(id)sender {
//  // disable all UI controls
//  self.signInButton.enabled = NO;
//  self.signInFailureText.hidden = YES;
//  
//  // sign in
//  [self.signInService signInWithUsername:self.usernameTextField.text
//                            password:self.passwordTextField.text
//                            complete:^(BOOL success) {
//                              self.signInButton.enabled = YES;
//                              self.signInFailureText.hidden = success;
//                              if (success) {
//                                [self performSegueWithIdentifier:@"signInSuccess" sender:self];
//                              }
//                            }];
//
//}
//这里的performSegueWithIdentifier是执行的action方法，并非是响应式的

// updates the enabled state and style of the text fields based on whether the current username
// and password combo is valid
//- (void)updateUIState {
////  self.usernameTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
////  self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//  self.signInButton.enabled = self.usernameIsValid && self.passwordIsValid;
//}

//- (void)usernameTextFieldChanged {
//  self.usernameIsValid = [self isValidUsername:self.usernameTextField.text];
//  [self updateUIState];
//}
//
//- (void)passwordTextFieldChanged {
//  self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
//  [self updateUIState];
//}

@end
