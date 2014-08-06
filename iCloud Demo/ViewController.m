//
//  ViewController.m
//  iCloud Demo
//
//  Created by Florian BUREL on 05/08/2014.
//  Copyright (c) 2014 Florian BUREL. All rights reserved.
//

#import "ViewController.h"
#import "ICloudService.h"
#import "NoteDocument.h"

@interface ViewController () <UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;
@property (weak, nonatomic) ICloudService * service;
@property (strong, nonatomic) NSMutableArray * noteDocuments;

@end

@implementation ViewController

#pragma mark - lazy getters

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (ICloudService *)service
{
    return [ICloudService sharedInstance];
}

- (NSMutableArray *)noteDocuments
{
    if(!_noteDocuments)
    {
        _noteDocuments = [[NSMutableArray alloc]init];
    }
    return _noteDocuments;
}


- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    
    [self.service retrieveUserAccountToken:^(BOOL hasAccount, BOOL accountHasChanged) {
        if(hasAccount)
        {
            
            NSLog(@"Account found!");
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"iCloud est necessaire pour fonctionner"
                                      message:@"So go and get it"
                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteDocuments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * customCellIdentifier = @"Cell";
    
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:customCellIdentifier];
    }
    
    cell.textLabel.text = @"yep";
    
    return cell;
    
    
}

@end
