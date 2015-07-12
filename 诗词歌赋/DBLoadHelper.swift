//
//  DBLoadHelper.swift
//  诗词歌赋
//
//  Created by Beibin Li on 15/7/12.
//  Copyright © 2015年 Beibin Li. All rights reserved.
//

import Foundation
import CoreData
import UIKit


func load_db_in_frist_launch() {
    let poet_load = "poet_1.0_loaded"
    
    
    if( !NSUserDefaults.standardUserDefaults().boolForKey(poet_load) ) {
        print("Loading data from .txt file ... ")
        load_file_from_bundle("shici")

        NSUserDefaults.standardUserDefaults().setBool(true, forKey: poet_load)
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    // else, we are good, do nothing
}



func load_file_from_bundle(filename:String) {
    let filePath = NSBundle.mainBundle().pathForResource(filename,ofType:"txt")
    
    if( filePath == nil ){
        print("Cannot load script from Bundle!")
        return
    }
    
    do{
        let data = try NSData(contentsOfFile:filePath!, options:NSDataReadingOptions.DataReadingUncached)
        let text = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        print(text)
        
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext =  appDel.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("PoetDB", inManagedObjectContext: context)
        
        let newItem:PoetModel = PoetModel(entity: entity!,  insertIntoManagedObjectContext: context)
        newItem.author = "李白"
        try context.save()

    }catch{
        print("Error: Cannot find the data in the file!")
    }

}


