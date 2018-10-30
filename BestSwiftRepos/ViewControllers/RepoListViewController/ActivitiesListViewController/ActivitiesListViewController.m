//
//  ActivitiesListViewController.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "ActivitiesListViewController.h"
#import "ActivityCell.h"
#import "Commit.h"
#import "DataManager.h"


@interface ActivitiesListViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation ActivitiesListViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataTable.rowHeight = 80.0f;
    
    [self addObservers];

    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *titlesArray = [self.repoFullTitle componentsSeparatedByString:@"/"];
    self.title = [titlesArray lastObject];
    
    [[DataManager shared] getCommitsForRepo:self.repoFullTitle];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}
#pragma mark -


#pragma mark - addObservers
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCommtits:)
                                                 name:@"commitsResult"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCommitAlert:)
                                                 name:@"showCommitAlert"
                                               object:nil];
}
#pragma mark -


#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:@"ActivityCell"
                                                                 forIndexPath:indexPath];
    
    Commit *commitObject = self.dataArray[indexPath.row];
    
    [cell setCellData:commitObject];
    
    return cell;
}
#pragma mark -


#pragma mark - NSNotification methods
- (void)receiveCommtits:(NSNotification *)sender {
    NSArray *reposArray = sender.userInfo[@"result"];
    if (reposArray) {
        self.dataArray = reposArray;
        [self.dataTable reloadData];
    }
}

- (void)showCommitAlert:(NSNotification *)sender {
    NSString *alertMessage = sender.userInfo[@"alert"];
    if (alertMessage) {
        [self showAlertMessage:alertMessage];
    }
}
#pragma mark -

@end
