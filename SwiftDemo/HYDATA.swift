//
//  HYDATA.swift
//  Swift实践Demo
//
//  Created by hy on 2016/11/6.
//  Copyright © 2016年 hy.com. All rights reserved.
//

import UIKit
import CoreData

class HYDATA: NSObject {
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // 存储数据
    func storePerson(name:String){
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue(name, forKey: "name")
        
        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
    }
    
    // 获取某一entity的所有数据
    func getPerson(entity:String) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var dataArray = [String]()
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for p in (searchResults as! [NSManagedObject]){
                dataArray.append("\(p.value(forKey: "name")!)")
            }
        } catch  {
            print(error)
        }
        return dataArray
    }
    
    //删除数据
    func removePerson(entity:String,name:String) {
        let context:NSManagedObjectContext = self.getContext()
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let fetchResult = try context.fetch(fetchReq)
            for re in (fetchResult as! [NSManagedObject]) {
                let na =  "\(re.value(forKey: "name")!)"
                if na == name {
                context.delete(re)
                }
            }
        } catch{
            print("查询失败")
        }
        //保存
        do {
            try context.save()
            print("保存成功！")
        } catch {
            fatalError("不能保存：\(error)")
        }
    }

}
