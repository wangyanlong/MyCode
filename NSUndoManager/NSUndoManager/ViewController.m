//
//  ViewController.m
//  NSUndoManager
//
//  Created by 王老师 on 15/8/19.
//  Copyright (c) 2015年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) NSUndoManager *manager;
@property (assign, nonatomic) int num;

@end

@implementation ViewController

//  当进行操作时，控制器会添加一个该操作的逆操作的invocation到Undo栈中。当进行Undo操作时，Undo操作的逆操作会倍添加到Redo栈中，就这样利用Undo和Redo两个堆栈巧妙的实现撤销操作。
//  这里需要注意的是，堆栈中存放的都是NSInvocation实例

- (IBAction)add:(UIButton *)sender {
    self.num += 10;
    self.showLabel.text = [NSString stringWithFormat:@"现在的数字是:%d",self.num];
    [[self.manager prepareWithInvocationTarget:self] remove:nil];
}

- (IBAction)remove:(id)sender {
    self.num -= 10;
    self.showLabel.text = [NSString stringWithFormat:@"现在的数字是:%d",self.num];
    [[self.manager prepareWithInvocationTarget:self] add:nil];
}

- (IBAction)undo:(id)sender {
    [self.manager undo];
}

- (IBAction)redo:(id)sender {
    [self.manager redo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.manager = [[NSUndoManager alloc]init];
    [self.manager setLevelsOfUndo:3];
    
    self.num = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:self.manager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redoManagerDidUndo:) name:NSUndoManagerDidRedoChangeNotification object:self.manager];
    
}

- (void)redoManagerDidUndo:(NSNotification *)not{

}

- (void)undoManagerDidUndo:(NSNotification *)not{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
