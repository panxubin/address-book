//
//  XBContactListVC.m
//  01-通讯录的实现
//
//  Created by panxubin on 16/9/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

#import "XBContactListVC.h"
#import "CoreDataTool.h"
#import "XBEdictContactVC.h"
#import "CommonTool.h"


@interface XBContactListVC ()<NSFetchedResultsControllerDelegate,UISearchBarDelegate>

@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
@property(assign,nonatomic)BOOL isTrash;


@end

@implementation XBContactListVC

-(void)viewDidLoad
{
    NSLog(@"%@",NSHomeDirectory());
    
    [self addSearchBar];
}

///添加搜索栏
-(void)addSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

//实现搜索功能
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   //文本框内容发生改变的时候调用该方法
    searchText = [[CommonTool getPinYinFromString:searchText]lowercaseString];
    
    ///有文字的时候添加谓词
    if (searchText.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS %@ || self.namePinYin CONTAINS %@ || self.phoneNum CONTAINS %@",searchText,searchText,searchText];
        
        self.fetchedResultsController.fetchRequest.predicate = predicate;
    }else{
        self.fetchedResultsController.fetchRequest.predicate = nil;
    }
    
    ///文字改变的时候就马上执行查询，用户不需要点击搜索按钮就能进行搜索
    
    [self.fetchedResultsController performFetch:nil];
    ///刷新界面
    [self.tableView reloadData];
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    ///创建请求
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Contact"];
    ///设置请求排序器
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"namePinYin" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:kXBCoreDataStackManager.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    ///执行查询
    [_fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];
    
    return _fetchedResultsController;
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isTrash == YES) {
        return 0;
    }else{
        return self.fetchedResultsController.sections.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///获取到对象
    if (_isTrash == NO) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        //获取模型
        Contact *contact = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = contact.name;
        cell.detailTextLabel.text = contact.phoneNum;
        
        return cell;
    }else{
    
        return nil;
    }
 
}

///添加删除功能
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.fetchedResultsController.sectionIndexTitles[section];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return @"删除";
}

///通过下标获取到要删除的文件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ///获取index
    Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ///删除数据
    [kXBCoreDataStackManager.managedObjectContext deleteObject:contact];

    [kXBCoreDataStackManager save];
}

#pragma mark -NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath
{
    ///获取当前tableView组的数量
    NSInteger sectionNum = self.tableView.numberOfSections;
    
    //获取NSFetchedResultsController组的数量,如果和tableView组的数量不相等，就表示有新的数据插入
    NSInteger fetchSection = self.fetchedResultsController.sections.count;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            
            //插入数据
            [self.tableView beginUpdates];
            if (sectionNum != fetchSection) {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
            }else{
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            [self.tableView reloadData];
            ///tableView有开始更新，就有结束更新
            ///不能没有结束更新
            [self.tableView endUpdates];
            break;
            
            case NSFetchedResultsChangeDelete:
            [self.tableView beginUpdates];
            if (sectionNum != fetchSection) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
            }else{
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
                [self.tableView endUpdates];
            break;
            
            case NSFetchedResultsChangeMove:
            [self.tableView reloadData];
            break;
            
            case NSFetchedResultsChangeUpdate:
            //刷新数据
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
            break;
            
        default:
            break;
    }
}

///跳转控制器
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   //添加控制器
    if ([segue.identifier isEqualToString:@"XBEdictContactVC"]) {
        
        XBEdictContactVC *ediVC = (XBEdictContactVC *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ediVC.contact = contact;
    }

}

- (IBAction)trashData:(id)sender {
    
    ///删除文件的方法
    
    NSBatchDeleteRequest *batchRequest = [[NSBatchDeleteRequest alloc]initWithFetchRequest:[[NSFetchRequest alloc]initWithEntityName:@"Contact"]];
    //执行批量删除文件的请求
    [kXBCoreDataStackManager.persistentStoreCoordinator executeRequest:batchRequest withContext:kXBCoreDataStackManager.managedObjectContext error:nil];
    self.fetchedResultsController = nil;
    
    [self.tableView reloadData];
}


@end







