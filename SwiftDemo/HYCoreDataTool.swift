//
//  HYCoreDataTool.swift
//  Swift实践Demo
//
//  Created by hy on 2016/11/6.
//  Copyright © 2016年 hy.com. All rights reserved.
//

import UIKit
import CoreData

class HYCoreDataTool: NSObject {
    
    var _context:NSManagedObjectContext?
    class func shareInstance()->HYCoreDataTool {
        let hycore = HYCoreDataTool()
        return hycore
    }
    
    func openCoreData(resource:String){
        //拿到资源文件
        let filePath = Bundle.main.url(forResource: resource, withExtension: "momd");
        
        if filePath == nil{
            return;
        }
        //读取数据模型
        let model = NSManagedObjectModel.init(contentsOf: filePath!)!;
        
        //根据model初始化数据助理
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model);
        //将数据模型存储到沙盒路径下
        let path = NSHomeDirectory().appending("/Documents/CoreData.db")
        //准尉url类型的路径
        let url = URL.init(fileURLWithPath: path);
        
        let store = try?coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: "", at: url, options: nil);
        if store == nil {
            //数据库存储异常
            print("数据存储异常");
        }
        
        _context = NSManagedObjectContext.init(concurrencyType:NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType);
        _context?.persistentStoreCoordinator = coordinator;
    }
    
    //加载所有数据
    func getCoredata(entity:String) -> [NSManagedObject]?? {
        let fetchRequest = NSFetchRequest<NSManagedObject>.init()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: _context!)
        fetchRequest.sortDescriptors?.append(NSSortDescriptor.init(key: "name", ascending: true))
        
        let fetchedObjects = try?_context?.fetch(fetchRequest)
        return fetchedObjects
    }
    
    //插入数据
    func insertData(entyName:String,dic:NSDictionary) {
        
        let object = NSEntityDescription.insertNewObject(forEntityName: entyName, into: _context!);
        
        let keyArr = dic.allKeys;
        print(keyArr)
        for i in 0 ..< keyArr.count {
            
            let key = keyArr[i];
            let value = dic.object(forKey: key);
            object.setValue(value, forKey: key as! String);
            print("\(value)")
        }
        _context?.insert(object);
    }
    
    //查询
    func squaryData(entyName:String,predStr:String) -> [NSManagedObject]?? {
        let request = NSFetchRequest<NSManagedObject>.init()
        request.entity = NSEntityDescription.entity(forEntityName: entyName, in: _context!)
        let cate = NSPredicate.init()
        request.predicate = cate
        
        let objectArr = try?_context?.fetch(request)
        return objectArr
        
    }
}
