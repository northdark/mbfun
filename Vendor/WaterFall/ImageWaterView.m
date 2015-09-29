//
//  ImageWaterView.m
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//


#import "ImageWaterView.h"

@implementation ImageWaterView
@synthesize arrayImage;
@synthesize show;
@synthesize ismylike;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithDataArray:(NSArray*)array withFrame:(CGRect)rect withshow:(BOOL)showS withIsMyLike:(BOOL)isMyLike
{
    self = [super initWithFrame:rect];
    
    if (self) {
        
        _onDidSelectedRow= [[CommonEventHandler alloc] init];
        _onDidFavriteRow = [[CommonEventHandler alloc]init];
        
        self.arrayImage = array;
        self.show=showS;
        self.ismylike=isMyLike;
        
       [self setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
        //初始化参数
        [self initParameter];
        
    }
    return self;
}
-(void)initParameter
{
    //每一列的视图初始化
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    secondView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, 0)];

    higher = row = highValue = lower = 1;
    countImage = 0;
    
    for (int i = 0; i<self.arrayImage.count; i++) {
        //0%3=0,0-2除3也不可能大于0
        if (i/2>0 && i%2==0) {
            row++;
        }
        ImageInfo *data = (ImageInfo*)[self.arrayImage objectAtIndex:i];
        
        countImage ++;
        //添加视图
        [self addViews:data with:countImage];
        //重新设置最高和最低view
        [self setHigherAndLower];
    }
    
    [self setContentSize:CGSizeMake(WIDTH, highValue)];
    [self addSubview:firstView];
    [self addSubview:secondView];
}
-(void)addViews:(ImageInfo *)image with:(int)a
{
    //要添加到列上的图片对象
    SelfImageVIew *imageView = nil;
    //图片的高度
    float imageHeight = 0;
    //创建每列的视图填充的内容
    /*
     1、创建自定义的图片对象
     2、记住该图片的高度
     3、重新定义每列的大小，就是高度
     4、把该图片加到每列上。
     */
    //在最低的那一列添加图片
    if (self.show)
    {
        switch (lower) {
            case 1:
                imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:firstView.frame.size.height withA:a withShowHeight:YES withMyLike:self.ismylike];
                imageHeight = imageView.frame.size.height;
                firstView.frame = CGRectMake(firstView.frame.origin.x, firstView.frame.origin.y, WIDTH, firstView.frame.size.height + imageHeight);
                [firstView addSubview:imageView];
                break;
            case 2:
                imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:secondView.frame.size.height  withA:a withShowHeight:YES withMyLike:self.ismylike];
                imageHeight = imageView.frame.size.height;
                secondView.frame = CGRectMake(secondView.frame.origin.x, secondView.frame.origin.y, WIDTH, secondView.frame.size.height + imageHeight);
                [secondView addSubview:imageView];
                break;
            case 3:
                //            imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:thridView.frame.size.height  withA:a];
                //            imageHeight = imageView.frame.size.height;
                //            thridView.frame = CGRectMake(thridView.frame.origin.x, thridView.frame.origin.y, WIDTH, thridView.frame.size.height + imageHeight);
                //            [thridView addSubview:imageView];
                break;
            default:
                break;
        }
  
    }
    else
    {
        switch (lower) {
            case 1:
                imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:firstView.frame.size.height withA:a withShowHeight:NO withMyLike:self.ismylike];
                imageHeight = imageView.frame.size.height;
                firstView.frame = CGRectMake(firstView.frame.origin.x, firstView.frame.origin.y, WIDTH, firstView.frame.size.height + imageHeight);
                [firstView addSubview:imageView];
                break;
            case 2:
                imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:secondView.frame.size.height  withA:a withShowHeight:NO withMyLike:self.ismylike];
                imageHeight = imageView.frame.size.height;
                secondView.frame = CGRectMake(secondView.frame.origin.x, secondView.frame.origin.y, WIDTH, secondView.frame.size.height + imageHeight);
                [secondView addSubview:imageView];
                break;
            case 3:
                //            imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:thridView.frame.size.height  withA:a];
                //            imageHeight = imageView.frame.size.height;
                //            thridView.frame = CGRectMake(thridView.frame.origin.x, thridView.frame.origin.y, WIDTH, thridView.frame.size.height + imageHeight);
                //            [thridView addSubview:imageView];
                break;
            default:
                break;
        }
 
    }
    
       imageView.delegate = self;
}
-(void)setHigherAndLower
{
    float firstHeight = firstView.frame.size.height;
    float secondHeight = secondView.frame.size.height;
//    float thridHeight = thridView.frame.size.height;
    //比较哪一列是最高的那列，并记录最高的值highValue和最高的列higher
    if (firstHeight > highValue) {
        highValue = firstHeight;
        higher = 1;
    }else if (secondHeight > highValue){
        highValue = secondHeight;
        higher = 2;
    }
//    else if (thridHeight > highValue){
//        highValue = thridHeight;
//        higher = 3;
//    }
    //找了最低列
    if (firstHeight <=secondHeight) {
//        if (firstHeight <= thridHeight) {
//            lower = 1;
//        }else{
            lower = 1;
//        }
    }else{
//        if (secondHeight <= thridHeight) {
//            lower = 2;
//        }else{
            lower = 2;
//        }
    }
}
-(void)clickImage:(ImageInfo *)data
{
//    NSLog(@"点击了图片：%@",data);
    
    [_onDidSelectedRow fire:self eventData:data];
    
}
-(void)favriteBtnClick:(ImageInfo *)data
{
    NSLog(@"收藏");
    [_onDidFavriteRow  fire:self eventData:data];
}
//刷新瀑布流
-(void)refreshView:(NSArray*)array
{
    [firstView removeFromSuperview];
    [secondView removeFromSuperview];
    firstView = nil;
    secondView = nil;
    self.arrayImage = array;
    [self initParameter];
    
}
//加载下一页瀑布流
-(void)loadNextPage:(NSArray*)array
{
    for (int i = 0; i<array.count; i++) {
        //0%3=0,0-2除3也不可能大于0
        if (i/2>0 && i%2==0) {
            row++;
        }
        ImageInfo *data = (ImageInfo*)[array objectAtIndex:i];
        countImage++;
        //添加视图
        [self addViews:data with:countImage];
        //重新设置最高和最低view
        [self setHigherAndLower];
    }
    [self setContentSize:CGSizeMake(WIDTH, highValue)];

}
@end
