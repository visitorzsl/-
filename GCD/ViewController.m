//
//  ViewController.m
//  GCD
//
//  Created by 大大赵 on 2017/9/19.
//  Copyright © 2017年 赵世礼. All rights reserved.
//

#import "ViewController.h"
#import "ZSLCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController
{
    UITableView *_tableView;
    NSArray *_timeArr;//时间数据
    NSArray *_numberArr;//作为每个时间在线程的编号
    NSMutableDictionary *_dataDict;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ZSLCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
    
    
  //数据
    _timeArr = @[@"130",@"180",@"200",
                   @"12",@"65",@"430",
                   @"89",@"43",@"320",@"120"];
    _numberArr = @[@"a",@"b",@"c",
                   @"d",@"e",@"f",
                   @"g",@"h",@"i",@"j"];
    _dataDict = [[NSMutableDictionary alloc] init];
    
    [self getTimeStrWith:_timeArr and:_numberArr];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timeArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSLCell *cell = [ZSLCell initWith:tableView];
    
    cell.cellID = _numberArr[indexPath.row];
    
    cell.timeLabel.text = [_dataDict objectForKey:cell.cellID];
    
    return cell;
}

-(void)getTimeStrWith:(NSArray *)timeArr and:(NSArray *)numberArr{
    
    dispatch_queue_t queue = dispatch_queue_create("zsl", DISPATCH_QUEUE_CONCURRENT);
    
    [_timeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block int timeout = [_timeArr[idx] intValue]; //转化倒计时
        
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if (timeout<=0) {//倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_dataDict setObject:@"停止秒杀" forKey:numberArr[idx]];
                    [_tableView reloadData];
                });
            }else{
                int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%d分%.2d秒后停止秒杀",minutes,seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_dataDict setObject:strTime forKey:numberArr[idx]];
                     [_tableView reloadData];
                });
                timeout--;
            }
            
        });
        dispatch_resume(_timer);
    }];
    
}

//- (void) appWillEnterForegroundNotification{
//    UIApplication*   app = [UIApplication sharedApplication];
//    __block    UIBackgroundTaskIdentifier bgTask;
//    //申请一个后台执行的任务 大概10分钟 如果时间更长的话需要借助默认音频等
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];
//
//}


//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
