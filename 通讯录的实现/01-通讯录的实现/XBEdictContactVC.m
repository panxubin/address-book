//
//  XBEdictContactVC.m
//  01-通讯录的实现
//
//  Created by panxubin on 16/9/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

#import "XBEdictContactVC.h"
#import "ZxkRegular.h"
#import "CommonTool.h"
#import "CoreDataTool.h"

@interface XBEdictContactVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextFile;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextFIle;

@end

@implementation XBEdictContactVC

///获取传递过来的数据，将数据展示在textFile中
-(void)viewDidLoad
{
    self.nameTextFile.text = self.contact.name;
    self.phoneNumTextFIle.text = self.contact.phoneNum;
}

//点击按钮保存的时候
- (IBAction)saveBtn:(id)sender {
    
    if ([self checkTextField] == NO) {
        return;
    }
    
    self.contact.name = self.nameTextFile.text;
    self.contact.phoneNum = self.phoneNumTextFIle.text;
    
    self.contact.namePinYin = [CommonTool getPinYinFromString:self.nameTextFile.text];
    //分组信息
    self.contact.sectionName = [[self.contact.namePinYin substringFromIndex:1]uppercaseString];
    
    ///保存数据后，返回到原来的控制器
    [kXBCoreDataStackManager save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkTextField
{
    if(self.nameTextFile.text.length == 0)
    {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"姓名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    }
    else if ([ZxkRegular regularPhone:self.phoneNumTextFIle.text] == NO)
    {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    }
    else
        return YES;
}



@end
