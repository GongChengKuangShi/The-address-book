//
//  LGUIView.m
//  酷炫的通讯录
//
//  Created by xrh on 2017/10/20.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import "LGUIView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LGUIView ()

@end

@implementation LGUIView

- (instancetype)initWithFrame:(CGRect)frame indexArray:(NSArray *)array {
    if (self = [super initWithFrame:frame]) {
        self.indexArray = [NSArray arrayWithArray:array];
        
        CGFloat height = self.frame.size.height / self.indexArray.count;
        for (int i = 0; i < array.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * height, self.frame.size.width, height)];
            label.text = [self.indexArray objectAtIndex:i];
            label.tag = TAG + i;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT_SIZE;
            label.textColor = STR_COLOR;
            [self addSubview:label];
      
            _number = label.font.pointSize;
        }
        [self addSubview:self.animationLabel];
    }
    return self;
}

#pragma mark -- 选中后显示在中间的Label
- (UILabel *)animationLabel {
    if (!_animationLabel) {
        _animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(-WIDTH/2 + self.frame.size.width/2, 100, 60, 60)];
        _animationLabel.layer.masksToBounds = YES;
        _animationLabel.layer.cornerRadius = 5.0f;
        _animationLabel.backgroundColor = [UIColor orangeColor];
        _animationLabel.textColor = [UIColor whiteColor];
        _animationLabel.alpha = 0;
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        _animationLabel.font = [UIFont systemFontOfSize:18];
    }
    return _animationLabel;
}

#pragma mark 数组中选中的元素
- (void)animationWithSection:(NSInteger)section {
    self.selectedBlock(section);
    
    _animationLabel.text = [self.indexArray objectAtIndex:section];
    _animationLabel.alpha = 1.0f;
}

#pragma mark -- 滑动停止的时候所定格的位置
- (void)panAnimationFinish {
    
    CGFloat height = self.frame.size.height/self.indexArray.count;
    for (int i = 0; i < self.indexArray.count; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:TAG + i];
        [UIView animateWithDuration:0.2 animations:^{
            label.center = CGPointMake(self.frame.size.width/2, i * height + height/2);
            label.font = FONT_SIZE;
            label.alpha = 1.0;
            label.textColor = STR_COLOR;
        }];
    }
    
    [UIView animateWithDuration:1 animations:^{
        self.animationLabel.alpha = 0;
    }];
}

#pragma mark -- 在滑动的时候
- (void)panAnimationBeginWithTouchers:(NSSet <UITouch *> *)toucher {
    UITouch *touch = [toucher anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat height = self.frame.size.height / self.indexArray.count;
    
    for (int i = 0; i < self.indexArray.count; i ++) {
        UILabel *label = (UILabel *)[self viewWithTag:TAG + i];
        //如果是在范围内的索引
        if (fabs(label.center.y - point.y) <= ANIMATION_HEIGHT) {
            [UIView animateWithDuration:0.2 animations:^{
                //通过勾股定律算出x轴的坐标
                label.center = CGPointMake(label.bounds.size.width / 2 - sqrt(fabs(pow(ANIMATION_HEIGHT, 2) - pow(fabs(label.center.y - point.y), 2))) , label.center.y);
                //字体的大小也根据点击位置的距离进行变化
                label.font = [UIFont systemFontOfSize:_number + (ANIMATION_HEIGHT - fabs(label.center.y - point.y)) * FONT_RATE];
                //设置点击锁定哪个label（按照label的大小适量调整）离谁最近，就是选中谁
                if (fabs(label.center.y - point.y) * ALPHA_RATE <= 0.08) {
                    //选中的索引进行单独设置
                    label.textColor = MARK_COLOR;
                    label.alpha = 1.0;
                    [self animationWithSection:i];
                    
                    //判断在范围内的所有label，如果不是当前选中的的label，则进行宁外的设置
                    for (int j = 0; j < self.indexArray.count; j++) {
                        UILabel *label = (UILabel *)[self viewWithTag:TAG + j];
                        if (i != j) {
                            label.textColor = STR_COLOR;
                             label.alpha = fabs(label.center.y - point.y) * ALPHA_RATE;
                        }
                    }
                }
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                //没有在范围内的索引则保持不变
                label.center = CGPointMake(label.bounds.size.width / 2, i * height + height/2);
                label.font = FONT_SIZE;
                label.alpha = 1.0;
            }];
        }
    }
}

#pragma mark -- 页面的点击手势
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationBeginWithTouchers:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationBeginWithTouchers:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationFinish];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationFinish];
}

- (void)selectIndexBlock:(MyBlock)block {
    self.selectedBlock = block;
}

@end
