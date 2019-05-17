//
//  Classes.swift
//  NoticeToolDemo
//
//  Created by 孙先华 on 2018/8/30.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.
//

import Foundation
import UIKit


//*****************提示框控件**********
//可定制的提示框
class RemindView: UIView {
    
    
    let maxWidth  :CGFloat = UIScreen.main.bounds.width * 0.7
    let maxHeight :CGFloat = 200
    
    /// 定义回调
    typealias CallbackValue=()->Void
    /// 声明闭包
    var chooesCallbackValue:CallbackValue?
    //回调方法
    func clickCallback(value:CallbackValue?){
        chooesCallbackValue = value //返回值
    }
    
    var remindButton = UIButton()
    
    var remindLabel = UILabel()
    var remindView  :UIView?
    var remindBackView = UIView()
    
    
    
    init(remindView :UIView?,noticeString :String,frame :CGRect){
        
        super.init(frame: frame)
        self.remindView = remindView
        
        self.creatViews(noticeString: noticeString)
    }
    
    
    
    func creatViews(noticeString :String){
        
        self.addSubview(remindBackView)
        remindBackView.backgroundColor     = UIColor.darkGray
        remindBackView.layer.cornerRadius  = 5.0
        remindBackView.layer.masksToBounds = true
        
        remindLabel.textColor     = UIColor.white
        remindLabel.font          = UIFont.systemFont(ofSize: 15)
        remindLabel.numberOfLines = 0
        remindBackView.addSubview(remindLabel)
        remindLabel.textAlignment = .center
        remindLabel.text = noticeString
        remindBackView.addSubview(remindLabel)
        
        
        
        //布局
        var remindBackViewSize :CGSize = CGSize.init(width: 0, height: 0)
        
        //计算label 的 size
        let remindLabelWidth  = CGFloat(noticeString.count * 18) > 50.0 ? CGFloat(noticeString.count * 18) : 50.0
        let remindLabelHeight = noticeString.getLabHeigh(font: UIFont.systemFont(ofSize: 15), width: remindLabelWidth).height + 20.0
        
        
        remindBackViewSize.height = remindView == nil ? remindLabelHeight : (40 + remindLabelHeight)
        
        //计算长度
        remindBackViewSize.width = remindBackViewSize.width <= self.maxWidth ? remindLabelWidth : self.maxWidth
        remindBackViewSize.height = remindBackViewSize.height <= self.maxHeight ? remindBackViewSize.height : self.maxHeight
        
        
        self.remindBackView.frame = CGRect.init(x: 0, y: 0, width: remindBackViewSize.width, height: remindBackViewSize.height)
        self.remindBackView.center = self.center
        self.remindLabel.frame = CGRect.init(x: 0, y: remindBackViewSize.height - remindLabelHeight, width: remindBackViewSize.width, height: remindLabelHeight)
        
        
        if remindView != nil {
            
            self.remindBackView.addSubview(remindView!)
            remindView!.frame = CGRect.init(x: 0, y: 10, width: 40, height: 40)
            remindView!.center.x = self.remindBackView.bounds.width/2.0
        }
        
        
        
        //添加点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        
    }
    
    @objc private func tapAction(){
        
        guard let block = chooesCallbackValue else {
            return
        }
        
        block()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



//******************提示框的类型******************
enum RemindType :Int{
    case success_remind = 0
    case error_remind   = 1
    case notice_remind  = 2
}

class RemindTypeClass {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    //绘制提示框上的图标
    class func draw(_ type: RemindType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .error_remind:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .success_remind:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .notice_remind:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        RemindTypeClass.draw(RemindType.success_remind)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        RemindTypeClass.draw(RemindType.error_remind)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        RemindTypeClass.draw(RemindType.notice_remind)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}

