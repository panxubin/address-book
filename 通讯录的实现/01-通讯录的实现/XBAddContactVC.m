//
//  XBAddContactVC.m
//  01-通讯录的实现
//
//  Created by panxubin on 16/9/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

#import "XBAddContactVC.h"
#import "Contact+CoreDataProperties.h"
#import "CoreDataTool.h"



@interface XBAddContactVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@end

@implementation XBAddContactVC
- (IBAction)cancelButton:(id)sender {
    
    //返回原来的界面
    [self.navigationController popViewControllerAnimated:YES];
}

//先实现给通讯录添加数据的功能
- (IBAction)uodateContanct:(id)sender {
    
    if ([self checkTextField] == NO) {
        return;
    }
    
    //创建一个模型对象
    Contact *tanct = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:kXBCoreDataStackManager.managedObjectContext];
    
    tanct.name = self.nameText.text;
    tanct.phoneNum = self.phoneNum.text;
    tanct.namePinYin = [CommonTool getPinYinFromString:tanct.name];
    tanct.sectionName = [[tanct.namePinYin substringFromIndex:1] uppercaseString];
    
    [kXBCoreDataStackManager save];
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(BOOL)checkTextField
{
    if(self.nameText.text.length == 0)
    {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"姓名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    }
    else if ([ZxkRegular regularPhone:self.phoneNum.text] == NO)
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
