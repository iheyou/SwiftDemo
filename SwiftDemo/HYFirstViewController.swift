   //
//  ViewController.swift
//  UITableView
//
//  Created by hy on 2016/11/3.
//  Copyright © 2016年 hy.com. All rights reserved.
//

import UIKit
   
var myTableView : UITableView!
var kWidth = UIScreen.main.bounds

class HYFirstViewController: UIViewController {
    
    let hycore = HYCoreDataTool.shareInstance()
    let hydata = HYDATA()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        let rightButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(clicked))
        self.navigationItem.setRightBarButton(rightButton, animated: true)
        myTableView = UITableView.init(frame: CGRect(x:0, y: 64, width:kWidth.width, height:kWidth.height-64), style: .plain)
        myTableView.delegate = self
        myTableView.dataSource = self
        view = myTableView
        self.generalCityDics()
        myTableView .reloadData()
        
    }
    
    var citis = [String]()
    var titles = [String]()
    var cityDics = [String:[String]]()
    /**
     生成字典
     */
    func generalCityDics(){
        let allResults = self.hydata.getPerson(entity: "Person")
        for p in allResults{
            self.citis.append("\(p)")
        }
        for city in citis{
            //将城市转成拼音  然后取第一个字母 然后大写
            let key = (city.toPinYin()[city.toPinYin().startIndex].description as NSString).uppercased
            //判断cityDics是否已经存在此key
            if var cityValues = cityDics[key]{
                //拿出values 把city添加进去
                cityValues.append(city)
                //重新赋值
                cityDics[key] = cityValues
                
            }else{
                //第一次赋值
                titles.append(key)
                cityDics[key] = [city]
            }
            //排序
            titles = titles.sorted(by:){ $0<$1 }    
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HYFirstViewController:UITableViewDelegate,UITableViewDataSource {
    //加载数据源
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.cityDics[self.titles[indexPath.section]]![indexPath.row]
        //设置字体大小
        cell?.textLabel?.font = UIFont.init(name: "cell字体大小", size: 30)
        //设置字体颜色
        cell?.textLabel?.textColor = UIColor.blue
        return cell!
    }
    
    //设置每组cell个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityDics[self.titles[section]]!.count
    }
    
    //设置组数
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    
    //设置组头标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titles[section]
    }
    
    //设置索引标题
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.titles
    }
    
    //设置行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //设置组头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //选中cell触发
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //允许编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //设置编辑样式 向左滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: 1)!
    }
    
    //删除cell时触发
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let deleteName: String
        deleteName = self.cityDics[self.titles[indexPath.section]]![indexPath.row]

        self.citis .removeAll()
        self.hydata.removePerson(entity: "Person", name: deleteName)
        self.titles.removeAll()
        self.cityDics.removeAll()
        self.generalCityDics()
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity,200,
                                                       50, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            cell.layer.transform = CATransform3DIdentity
            }, completion: nil)
    }

}

extension HYFirstViewController {
    func clicked() {
    
        let alert = UIAlertController.init(title: "添加联系人", message: nil, preferredStyle: .alert)
        let alertHint = UIAlertController.init(title: "已存在", message: nil, preferredStyle: .alert)
        
        alert.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "名称"
        }
        
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (UIAlertAction) in
            
            let name = alert.textFields!.first!
            var str: String?
            str = name.text
            var num = 0
            for obj in self.citis {
                if obj == str {
                    num += 1
                }
            }
            
            if num >= 1 {
                self.present(alertHint, animated: true, completion: nil)
            } else {
                self.hydata.storePerson(name: str!)
    
                self.cityDics.removeAll()
                self.titles.removeAll()
                self.citis.removeAll()
                self.generalCityDics()
                myTableView .reloadData()
            }
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        let hintAction = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alertHint.addAction(hintAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
    
extension String {
    func toPinYin() -> String {
        let mutableString = NSMutableString(string:self)
        //把汉字转换为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        //去掉空格
        return (string.description as NSString).replacingOccurrences(of: "",with:"")
    }
}
   
