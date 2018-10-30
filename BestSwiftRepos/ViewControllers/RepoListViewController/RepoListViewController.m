//
//  RepoListViewController.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "RepoListViewController.h"
#import "ListCell.h"
#import "Repository.h"
#import "UserDefaultsManager.h"
#import "DataManager.h"
#import "ActivitiesListViewController.h"


@interface RepoListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) BOOL isTableStartLoading;
@end


@implementation RepoListViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataTable.rowHeight = 100.0f;
    
    [self addObservers];
    
    [[DataManager shared] getRepositoriesByPage:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isTableStartLoading = YES;
    
    double delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.isTableStartLoading = NO;
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}
#pragma mark -


#pragma mark - addObservers
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRepositories:)
                                                 name:@"reposResult"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReposAlert:)
                                                 name:@"showRepositoryAlert"
                                               object:nil];
}
#pragma mark -


#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell"
                                                                 forIndexPath:indexPath];
    
    Repository *repoObject = self.dataArray[indexPath.row];

    [cell setCellData:repoObject];
    
    if (!self.isTableStartLoading) {
        if (indexPath.row == 0) {
            [[DataManager shared] getRepositoriesByPage:1];         // Refresh first page by scroll to top
        } else if (indexPath.row == self.dataArray.count - 1) {
            int64_t totalRepos = [[UserDefaultsManager shared] getTotalRepositories];
            if (self.dataArray.count < totalRepos) {   // Download sentinel
                [[DataManager shared] getRepositoriesByPage:0];         // Load next page by scroll to down;
            } else {
                [self showAlertMessage:@"You download all popular repositoriries for Swift language."];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowCommits" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -


#pragma mark - NSNotification methods
- (void)receiveRepositories:(NSNotification *)sender {
    NSArray *reposArray = sender.userInfo[@"result"];
    if (reposArray) {
        self.dataArray = reposArray;
        [self.dataTable reloadData];
    }
}

- (void)showReposAlert:(NSNotification *)sender {
    NSString *alertMessage = sender.userInfo[@"alert"];
    if (alertMessage) {
        [self showAlertMessage:alertMessage];
    }
}
#pragma mark -


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *receivedSegueId = segue.identifier;
    
    if ([receivedSegueId isEqualToString:@"ShowCommits"]) {
        Repository *selectedRepo = self.dataArray[self.dataTable.indexPathForSelectedRow.row];
        NSString *fullTitle = selectedRepo.fullTitle;
        
        ActivitiesListViewController *activListVC = (ActivitiesListViewController *)segue.destinationViewController;

        if (fullTitle) {
            activListVC.repoFullTitle = fullTitle;
        }
    }
}
#pragma mark -

@end
