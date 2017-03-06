//
//  MomentsCell.m
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsCell.h"
#import "MomentsModel.h"
#import "CommentsModel.h"
#import "Config.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+LXAdd.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "Config.h"
#import "User.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "AppDelegate.h"
#import "UUInputAccessoryView.h"
#import "MomentsViewController.h"
#import "XWScanImage.h"
@interface MomentsCell ()
@end

@implementation MomentsCell{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *contentLabel;
    
    UIButton *avatarButton;
    UIImageView *cornerImage;
    
    UILabel *commentNumLabel;
    UIButton *commentButton;
    UIImageView *commentImage;
    
    UIImageView *photoImg1;
    UIImageView *photoImg2;
    UIImageView *photoImg3;
    UIImageView *photoImg4;
    
    UIButton *deleteSay;
    UIButton *deleteComment;
    
    UIImageView *commentBackground;
    UILabel *commentLabel;
    UIImageView *userCollegeImage;
    UILabel *userCollegeLabel;
    UILabel *commentUsernameLabel;
    UIImageView *commentBackground2;
    UILabel *commentsTimeLabel;
    
    User *user;
    double sumHeight;
    int comments_i;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSDictionary *User_Data=[defaults objectForKey:@"User"];
        user=[User yy_modelWithJSON:User_Data];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)draw{
    sumHeight=0.0;
    /**用户昵称*/
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYReal(60), 0, SYReal(200),SYReal(50))];
    nameLabel.textColor=[UIColor colorWithRed:4/255.0 green:213/255.0 blue:192/255.0 alpha:1.0];
    nameLabel.text=_data.username;
    [self.contentView addSubview:nameLabel];
    /**发布时间*/
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYReal(60),SYReal(20),SYReal(400) ,SYReal(50))];
    timeLabel.text=_data.created_on;
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:9];
    timeLabel.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    [self.contentView addSubview:timeLabel];
    /**头像按钮*/
    avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.frame = CGRectMake(SYReal(15), SYReal(13), SYReal(35), SYReal(35));
    avatarButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    avatarButton.clipsToBounds = YES;
    [avatarButton addTarget:self action:@selector(btnAvatar) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:avatarButton];
    /**头像图片*/
    cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SYReal(37),SYReal(37))];
    cornerImage.center = avatarButton.center;
    [cornerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.head_pic_thumb]] placeholderImage:[self circleImage:[UIImage imageNamed:@"img_defalut"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (![[NSString stringWithFormat:API_IMG,_data.head_pic_thumb] isEqualToString:INDEX]) {
            cornerImage.image=[self circleImage:image];
        }
    }];
    [self.contentView addSubview:cornerImage];
    /**说说内容*/
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines=0;
    contentLabel.font=[UIFont systemFontOfSize:15];
    contentLabel.textColor=[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    contentLabel.text=_data.content;
    contentLabel.frame=CGRectMake(SYReal(20), SYReal(60),_data.textWidth,_data.textHeight);
    [self.contentView addSubview:contentLabel];
    /**图片*/
    sumHeight+= SYReal(70)+_data.textHeight;
    if (_data.pics.count!=0) {
        //[self loadPhoto];
    }
    sumHeight+=_data.photoHeight;
    /**评论图片*/
    commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(365), SYReal(6)+sumHeight,SYReal(15),SYReal(16))];
    commentImage.image=[UIImage imageNamed:@"comment"];
    [self.contentView addSubview:commentImage];
    /**学院图片*/
    userCollegeImage = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(20), SYReal(8)+sumHeight,SYReal(13),SYReal(13))];
    userCollegeImage.image=[UIImage imageNamed:@"icon_not_locationed"];
    [self.contentView addSubview:userCollegeImage];
    /**学院*/
    userCollegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYReal(35),SYReal(5)+sumHeight, SYReal(150),SYReal(20))];
    userCollegeLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    userCollegeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    userCollegeLabel.text=_data.dep_name;
    [self.contentView addSubview:userCollegeLabel];
    /**评论按钮*/
    commentButton = [[UIButton alloc] init];
    commentButton.frame=CGRectMake(SYReal(360), SYReal(5)+sumHeight, SYReal(40), SYReal(20));
    [commentButton addTarget:self action:@selector(btnComment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentButton];
    /**评论图片*/
    commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(365), SYReal(6)+sumHeight,SYReal(15),SYReal(16))];
    commentImage.image=[UIImage imageNamed:@"comment"];
    [self.contentView addSubview:commentImage];
    /**评论数*/
        commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYReal(385),SYReal(5)+sumHeight, SYReal(18),SYReal(18))];
        commentNumLabel.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        commentNumLabel.text=[NSString stringWithFormat:@"%d",(short)_data.commentsModelArray.count];
        [self.contentView addSubview:commentNumLabel];
    /**删除说说按钮*/
    if ([user.user_id isEqualToString:_data.user_id]) {
        deleteSay = [[UIButton alloc] initWithFrame:CGRectMake(SYReal(320), sumHeight, SYReal(30),SYReal(30))];
        [deleteSay setTitle:@"删除" forState:UIControlStateNormal];
        deleteSay.titleLabel.font=[UIFont systemFontOfSize: 12.0];
        [deleteSay setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        [deleteSay addTarget:self action:@selector(btnDeleteSay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteSay];
    }
    /**评论*/
    sumHeight+=SYReal(10);
    [self loadComments];
}
-(void)loadComments{
    double sumCommentsHeight=0.0;
    for (int i=0; i<_data.commentsModelArray.count; i++) {
        /**评论背景*/
        CommentsModel *commentsModel=_data.commentsModelArray[i];
        commentBackground =[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(20), SYReal(5)+sumHeight+SYReal(23)+sumCommentsHeight, SYReal(374), SYReal(25)+commentsModel.commentsHeight)];
        commentBackground.backgroundColor=[UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
        [self.contentView addSubview:commentBackground];
        /**评论*/
        commentLabel =[[UILabel alloc]initWithFrame:CGRectMake(SYReal(30),SYReal(5)+sumHeight+SYReal(28)+sumCommentsHeight,SYReal(COMMENTS_WEIGHT), commentsModel.commentsHeight)];
        commentLabel.numberOfLines=0;
        commentLabel.text=commentsModel.comment;
        commentLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:13];
        [self.contentView addSubview:commentLabel];
        /**评论用户昵称*/
        commentUsernameLabel =[[UILabel alloc]initWithFrame:CGRectMake(SYReal(30), SYReal(5)+sumHeight+SYReal(28)+sumCommentsHeight+commentsModel.commentsHeight+SYReal(5),  SYReal(354), SYReal(10))];
        commentUsernameLabel.text=commentsModel.username;
        commentUsernameLabel.textColor=[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        commentUsernameLabel.font=[UIFont boldSystemFontOfSize:8];
        [self.contentView addSubview:commentUsernameLabel];
        /**评论发布时间*/
        commentsTimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(SYReal(310)+SYReal(15),SYReal(5)+sumHeight+SYReal(28)+sumCommentsHeight+commentsModel.commentsHeight+SYReal(5),  SYReal(80), SYReal(10))];
        commentsTimeLabel.text=commentsModel.created_on;
        commentsTimeLabel.font=[UIFont systemFontOfSize:9];
        commentsTimeLabel.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
        [self.contentView addSubview:commentsTimeLabel];
        /**删除评论按钮*/
        if ([user.user_id isEqualToString:commentsModel.user_id]) {
            comments_i=i;
            deleteComment = [[UIButton alloc] initWithFrame:CGRectMake(SYReal(290), SYReal(5)+sumHeight+SYReal(20)+sumCommentsHeight+commentsModel.commentsHeight+SYReal(5), SYReal(25),SYReal(25))];
            deleteComment.backgroundColor=[UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
            [deleteComment setTitle:@"删除" forState:UIControlStateNormal];
            deleteComment.titleLabel.font=[UIFont systemFontOfSize: 10.0];
            [deleteComment setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
            [deleteComment addTarget:self action:@selector(btnDeleteComment) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:deleteComment];
        }
        /**评论间隔*/
        commentBackground2 =[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(20), SYReal(5)+sumHeight+SYReal(23)+sumCommentsHeight+SYReal(25)+commentsModel.commentsHeight, SYReal(374),SYReal(1))];
        commentBackground2.backgroundColor=[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
        [self.contentView addSubview:commentBackground2];
        sumCommentsHeight+=SYReal(25)+commentsModel.commentsHeight+SYReal(1);
    }
}
-(void)loadPhoto{
    if (_data.pics.count==0) {
        return;
    }
    if (_data.pics.count==1) {
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,_data.photoHeight*1.77, _data.photoHeight);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg1];
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg1 addGestureRecognizer:tapGestureRecognizer1];
        [photoImg1 setUserInteractionEnabled:YES];
        
    }else if (_data.pics.count==2){
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg1];
        photoImg2=[[UIImageView alloc] init];
        photoImg2.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[1]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg2];
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg1 addGestureRecognizer:tapGestureRecognizer1];
        [photoImg1 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg2 addGestureRecognizer:tapGestureRecognizer2];
        [photoImg2 setUserInteractionEnabled:YES];
        
    }else if (_data.pics.count==3){
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight/2);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg1];
        photoImg2=[[UIImageView alloc] init];
        photoImg2.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight/2);
        [photoImg2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[1]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg2];
        photoImg3=[[UIImageView alloc] init];
        photoImg3.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight+_data.photoHeight/2,SYReal(184), _data.photoHeight/2);
        [photoImg3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[2]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg3];
       
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg1 addGestureRecognizer:tapGestureRecognizer1];
        [photoImg1 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg2 addGestureRecognizer:tapGestureRecognizer2];
        [photoImg2 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg3 addGestureRecognizer:tapGestureRecognizer3];
        [photoImg3 setUserInteractionEnabled:YES];
    }else if (_data.pics.count==4){
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight/2);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg1];
        photoImg2=[[UIImageView alloc] init];
        photoImg2.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight/2);
        [photoImg2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[1]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg2];
        photoImg3=[[UIImageView alloc] init];
        photoImg3.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight+_data.photoHeight/2,SYReal(184), _data.photoHeight/2);
        [photoImg3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[2]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg3];
        photoImg4=[[UIImageView alloc] init];
        photoImg4.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight+_data.photoHeight/2,SYReal(184), _data.photoHeight/2);
        [photoImg4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[3]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg4];
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg1 addGestureRecognizer:tapGestureRecognizer1];
        [photoImg1 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg2 addGestureRecognizer:tapGestureRecognizer2];
        [photoImg2 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg3 addGestureRecognizer:tapGestureRecognizer3];
        [photoImg3 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [photoImg4 addGestureRecognizer:tapGestureRecognizer4];
        [photoImg4 setUserInteractionEnabled:YES];
    }
}
#pragma mark - 按钮事件
-(void)btnAvatar{
    if ([Config getIs]==1) {
        return;
    }
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_USER,_data.user_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content.count!=0) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     [defaults synchronize];
                     [Config setIs:1];
                     MomentsViewController *Say      = [[MomentsViewController alloc] init];
                     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
                     
                 }else{
                 }
             }
             else{
                 
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             
         }];
}
-(void)btnComment{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_CREATE_COMMENT,user.studentKH,[defaults objectForKey:@"remember_code_app"],_data.moments_id];
    [UUInputAccessoryView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
        configer.keyboardType = UIKeyboardTypeDefault;
        configer.content = @"";
        configer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }block:^(NSString * _Nonnull contentStr) {
        // code
        if (contentStr.length == 0) return ;
        // NSLog(@"%@",contentStr);
        // 1.创建AFN管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 4.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 2.利用AFN管理者发送请求
        NSDictionary *params = @{
                                 @"comment" : contentStr
                                 };
        //NSLog(@"评论请求地址%@",Url_String);
        [MBProgressHUD showMessage:@"发表中" toView:self.contentView];
        [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *Msg=[response objectForKey:@"msg"];
            if ([Msg isEqualToString:@"ok"])   {
                [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                [MBProgressHUD showSuccess:@"评论成功"];
            }
            else if ([Msg isEqualToString:@"令牌错误"]){
                [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                [MBProgressHUD showError:@"登录过期，请重新登录"];}
            else{
                [MBProgressHUD hideHUDForView:self.contentView animated:YES];
                [MBProgressHUD showError:Msg];}
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.contentView animated:YES];
            [MBProgressHUD showError:@"网络错误"];
        }];
    }];
    
}
-(void)btnDeleteComment{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    CommentsModel *commentsModel=_data.commentsModelArray[comments_i];
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_COMMENT_DELETE,user.studentKH,[defaults objectForKey:@"remember_code_app"],commentsModel.comment_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 [MBProgressHUD showSuccess:@"删除成功,请重新刷新"];
             }
             else{
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             [MBProgressHUD showError:@"网络错误"];
         }];
    
}
-(void)btnDeleteSay{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_DELETE,user.studentKH,[defaults objectForKey:@"remember_code_app"],_data.moments_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 [MBProgressHUD showSuccess:@"删除成功,请重新刷新"];
             }
             else{
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             [MBProgressHUD showError:@"网络错误"];
         }];
    
}

-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

-(UIImage*) circleImage:(UIImage*) image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(0, 0, image.size.width , image.size.height );
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
@end
