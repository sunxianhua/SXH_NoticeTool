//
//  SXH_SwiftNoticeTool.swift
//  CoreDataTestProject
//
//  Created by 孙先华 on 2018/8/28.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//  用于做提示的工具类

import Foundation
import UIKit

class SXH_SwiftNoticeTool: NSObject {
    
    static var theWindows :[UIView] = Array()
    static var falgeTag :Int = 1000
    static var theAutoClear :Bool = true
    
    
    //MARK:------------常用的一些提示方法 自动消失的弹框---------------
    //普通的 短暂提示
    static func showRemindText(text :String,callBlock :(()->Void)?){
        
        _ = SXH_SwiftNoticeTool().showNoticeImage(imageName: nil, noticeString: text, superView: nil, autoClear: true, autoClearTime: 1.5, callBlock: callBlock)
      
    }
    
    
    //显示网络请求等待菊花圈
    static func showWaitNotice(text :String,clickBlock :(()->Void)?){
        
        SXH_SwiftNoticeTool.showWaitNoticeView(noticeString: text, superView: nil).clickCallback {
            //点击回调
            SXH_SwiftNoticeTool.clearView(superView: nil)
            guard let block = clickBlock else {
                return
            }
            block()
        }
    }
    
    
    //成功提示
    static func showSuccessNotice(text :String,callBlock :(()->Void)?){
        
        _ = SXH_SwiftNoticeTool().showRemindTypeView(remindType: .success_remind, noticeString: text, superView: nil, autoClear: true, autoClearTime: 1.5, callBlock: callBlock)
    }
    
    //错误提示
    static func showErrorNotice(text :String,callBlock :(()->Void)?){
        _ = SXH_SwiftNoticeTool().showRemindTypeView(remindType: .error_remind, noticeString: text, superView: nil, autoClear: true, autoClearTime: 1.5, callBlock: callBlock)
    }
    
    //警告提示
    static func showInforNotice(text :String,callBlock :(()->Void)?){
        
        _ = SXH_SwiftNoticeTool().showRemindTypeView(remindType: .notice_remind, noticeString: text, superView: nil, autoClear: true, autoClearTime: 1.5, callBlock: callBlock)
    }
    
    
    //显示提示界面，不自动消失，有点击回调(点击后当前提示语消失)
    static func showTextRemindView(imageName :String?,noticeString :String,superView :UIView?,clickBlock :(()->Void)?){

        //出现提示界面
        let noticeTool = SXH_SwiftNoticeTool()
        noticeTool.showNoticeImage(imageName: imageName, noticeString: noticeString, superView: superView, autoClear: false, autoClearTime: nil, callBlock: nil).clickCallback {

            //点击回调
            SXH_SwiftNoticeTool.clearView(superView: superView)
            guard let block = clickBlock else {
                return
            }
            block()
        }
    }

    
    
    
    //有 成功/失败/警告 类型标志的 提示框，不自动消失，带点击事件
    static func showRemindNoticeTypeView(remindType :RemindType,noticeString :String,superView :UIView?,autoClearTime :Double?,callBlock :(()->Void)?){
        _ = SXH_SwiftNoticeTool().showRemindTypeView(remindType: remindType, noticeString: noticeString, superView: superView, autoClear: (autoClearTime != nil), autoClearTime: autoClearTime, callBlock: callBlock)
    }
    
    
    
    
    
    
    
    //MARK:--------可用于自定义弹框的一些方法----------
    
    /*
                              传入图片名的提示语
     imageName :提示语图片名
     noticeString :提示语
     superView  :提示控件父视图  ---  如果该值为空，则会将提示控件覆盖到新建的window上面
     autoClear  :是否自动消失
     autoClearTime :显示时长
     callBlock  : 显示完后的回调 -- 时间走完后的自动回调
     
     */
    func showNoticeImage(imageName :String?,noticeString :String,superView :UIView?,autoClear :Bool,autoClearTime :Double?,callBlock :(()->Void)?) ->RemindView{
        
        
        let imageView :UIImageView? = imageName == nil ? nil : UIImageView.init(image: UIImage.init(named: imageName!))
        
        //有父视图 superView  则直接在父视图上添加
        let remindView :RemindView!
        if let view = superView {
            
            remindView = RemindView.init(remindView: imageView, noticeString: noticeString, frame: view.bounds)
            remindView.tag = SXH_SwiftNoticeTool.falgeTag
            
            superView!.addSubview(remindView)
        }else{
            
            //没有则新建一个最上层窗口，添加提示控件
            let window             = UIWindow.init(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.clear
            window.windowLevel     = UIWindowLevelAlert
            window.isHidden        = false
    
            remindView = RemindView.init(remindView: imageView, noticeString: noticeString, frame: UIScreen.main.bounds)
            
            window.addSubview(remindView)
    
            SXH_SwiftNoticeTool.theWindows.append(window)
        }
        
        
        //消失并返回
        if !autoClear {
            return remindView
        }

        let time = autoClearTime == nil ? 1.0 : autoClearTime!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {

            SXH_SwiftNoticeTool.clearView(superView: superView)
        }
        
        
        return remindView
    }
    
    
    
    /*
     传入提示语类型的提示框
     
     imageName :提示语图片名
     noticeString :提示语
     superView  :提示控件父视图  ---  如果该值为空，则会将提示控件覆盖到新建的window上面
     autoClear  :是否自动消失
     autoClearTime :显示时长
     callBlock  : 显示完后的回调 -- 时间走完后的自动回调
     
     */
    func showRemindTypeView(remindType :RemindType,noticeString :String,superView :UIView?,autoClear :Bool,autoClearTime :Double?,callBlock :(()->Void)?) ->RemindView{
        
        //获取类型视图
        var image = UIImage()
        switch remindType {
        case .success_remind:
            image = RemindTypeClass.imageOfCheckmark
        case .error_remind:
            image = RemindTypeClass.imageOfCross
        case .notice_remind:
            image = RemindTypeClass.imageOfInfo
        }
        let imageView = UIImageView.init(image: image)
        
        
        //有父视图 superView  则直接在父视图上添加
        let remindView :RemindView!
        if let view = superView {
            
            remindView = RemindView.init(remindView: imageView, noticeString: noticeString, frame: view.bounds)
            superView!.addSubview(remindView)
        }else{
            
            //没有则新建一个最上层窗口，添加提示控件
            let window             = UIWindow.init(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.clear
            window.windowLevel     = UIWindowLevelAlert
            window.isHidden        = false
            
            remindView = RemindView.init(remindView: imageView, noticeString: noticeString, frame: UIScreen.main.bounds)
            window.addSubview(remindView)
            
            SXH_SwiftNoticeTool.theWindows.append(window)
        }
        remindView.tag = SXH_SwiftNoticeTool.falgeTag
        remindView.chooesCallbackValue = callBlock
        
        
        //消失并返回
        if !autoClear {
            return remindView
        }
        
        let time = autoClearTime == nil ? 1.0 : autoClearTime!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            
            SXH_SwiftNoticeTool.clearView(superView: superView)
            if callBlock != nil {
                callBlock!()
            }
            
        }
        
        return remindView
    }
    
    
    
    
    //等待菊花圈
    class func showWaitNoticeView(noticeString :String,superView :UIView?) ->RemindView{
        
        let activityview = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50.0, height: 50.0))
        activityview.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityview.startAnimating()
        
        let backView :UIView!
        if let view = superView {
            backView = view
            
        }else{
            
            //没有则新建一个最上层窗口，添加提示控件
            let window             = UIWindow.init(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.clear
            window.windowLevel     = UIWindowLevelAlert
            window.isHidden        = false
            
            SXH_SwiftNoticeTool.theWindows.append(window)
            backView = window
            

        }
        
        let remindView = RemindView.init(remindView: activityview, noticeString: noticeString, frame: backView.bounds)
        backView.addSubview(remindView)
        remindView.tag = SXH_SwiftNoticeTool.falgeTag
        
        return remindView
        
    }
    
    
    
    //清除提示界面
    class func clearView(superView :UIView?){
    
        if let view = superView {
            
            let array = view.subviews
            guard let index = (array.index { (item) -> Bool in
                return item.tag == SXH_SwiftNoticeTool.falgeTag
            }) else {
                return
            }
            array[index].isHidden = true
            array[index].removeFromSuperview()
            
            
        }else{
        
            for item in SXH_SwiftNoticeTool.theWindows {
                
                item.isHidden = true
                item.removeFromSuperview()
            }
            
        }
        
    }
    
}











