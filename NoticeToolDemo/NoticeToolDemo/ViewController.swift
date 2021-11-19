//
//  ViewController.swift
//  NoticeToolDemo
//
//  Created by 孙先华 on 2018/8/29.
//  Copyright © 2018年 سچچچچچچ. All rights reserved.

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    var cellStringArray = ["短暂的提示语","带图片文字的提示语","请求等待提示语","带类型的警告提示"]
    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creatViews()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    private func creatViews(){
        
        self.view.addSubview(tableView)
        tableView.frame      = self.view.bounds
        tableView.delegate   = self
        tableView.dataSource = self
        
        print("测试橘子");
        print("测试橘子2");
        print("测试橘子3");
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "")
        cell.textLabel?.text = cellStringArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cellStringArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch indexPath.row {
        case 0:
            SXH_SwiftNoticeTool.showRemindText(text: "提示文字", callBlock: nil)
        case 1:
            SXH_SwiftNoticeTool.showTextRemindView(imageName: "warning-icon", noticeString: cellStringArray[indexPath.row] + "\n点击消失", superView: self.view) {
                SXH_SwiftNoticeTool.clearView(superView: self.view)
            }
            
        case 2:
            
            SXH_SwiftNoticeTool.showWaitNotice(text: cellStringArray[indexPath.row] + "点击消失") {
                print("我消失了")
            }
            
        case 3:
            
            
            let block :((RemindType)->Void) = { theType in
                //2秒后自动消失
                SXH_SwiftNoticeTool.showRemindNoticeTypeView(remindType: theType, noticeString: self.cellStringArray[indexPath.row] + "点击消失", superView: self.view, autoClearTime: 2, callBlock: {
                    
                    print("消失了")
                })
                
            }
            
            
            
            let titleArray :[String] = ["成功","失败","警告"]
            let alertVC = UIAlertController.init(title: "选择提示类型", message: nil, preferredStyle: .actionSheet)
            
            for index in 0...titleArray.count - 1 {
                
                let action = UIAlertAction(title: titleArray[index], style: .default) { (action :UIAlertAction!) in
                    block(RemindType(rawValue: index)!)
                }
                alertVC.addAction(action)
                
            }
            
            self.present(alertVC, animated: true, completion: nil)
            
        default:
            print("")
        }
        

        
    }
    
}
