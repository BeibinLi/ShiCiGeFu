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
        
        clear_DB()
        load_file_from_bundle("shici")

        
        // Override the syntax
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: poet_load)
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    // else, we are good, do nothing
    
    
    
    // to delete the following three lines??? debug use only
//    clear_DB()
//    load_file_from_bundle("shici")
//    debug_DB()
}



func load_file_from_bundle(filename:String) {
    let filePath = NSBundle.mainBundle().pathForResource(filename,ofType:"txt")
    
    if( filePath == nil ){
        print("Cannot load script from Bundle!")
        return
    }
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext =  appDel.managedObjectContext
    
    let entity = NSEntityDescription.entityForName("PoetDB", inManagedObjectContext: context)

    var authors = Set<String>() //Set of all the authors
    
    do{
        let data = try NSData(contentsOfFile:filePath!, options:NSDataReadingOptions.DataReadingUncached)
        let text = NSString(data: data, encoding: NSUTF8StringEncoding) as! String

        // parse whole file into array
        let text_array:[String] = split(text.characters){$0 == "\n"}.map(String.init)
        
        var is_a_poet = false
        var temp_title = "", temp_author = ""
        
        
        
        for(var i=0; i<text_array.count; i++){
            
            if(is_a_poet){  // 知道这一行是 诗 的内容。
                let newItem:PoetModel = PoetModel(entity: entity!,  insertIntoManagedObjectContext: context)
                newItem.author = temp_author
                newItem.title = temp_title
                newItem.context = text_array[i]
                newItem.score = 0
                
                authors.insert(temp_author)
                
                try context.save()
                is_a_poet = false
            }else{
                let line = text_array[i]
                let find = line.find(":")
                if( find == -1 ) {
                    // empty line. do nothing
                }else{
                    is_a_poet = true
                    temp_author = line.substring(0, find)
                    temp_title = line.substring(find + 1, line.length )
                }
                
            }
        }

    }catch{
        print("Error: Cannot find the data in the file! or Could not save the Database")
    }
    



    // Store the AuthorDB
//    do{
//        let author_entity = NSEntityDescription.entityForName("AuthorDB", inManagedObjectContext: context)
//        
//        for author in authors{
////            let newAuthor:PoetModel = PoetModel(entity: entity!,  insertIntoManagedObjectContext: context)
////            newAuthor.author = temp_author
//            
//            try context.save()
//
//        }
//    }catch{
//        print("Error: Cannot save database!")
//    }

}



// Print in "" JSON file format
func debug_DB() {
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext =  appDel.managedObjectContext
    
    let f_request = NSFetchRequest(entityName: "PoetDB")
    
    let objects:[AnyObject] = try! context.executeFetchRequest(f_request)

    
    
    print(objects.count)
    
    
    print("{\"poet\":[")
    
    for obj in objects{
        
        if let poet = obj as? PoetModel {
            var output = "{\n\t\"author:\":\""
            output += poet.author
            output += "\", \n\t\"title\":\""
            output += poet.title
            output += "\", \n\t\"context\":\""
            output += poet.context
            output += "\"\n}, \n"
            print(output)
        }
    }
    
    print("]}")
}

func clear_DB() {
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext =  appDel.managedObjectContext
    
    let f_request = NSFetchRequest(entityName: "PoetDB")
    
    let objects:[AnyObject] = try! context.executeFetchRequest(f_request)
    
    do {
        for obj in objects {
            context.deleteObject(obj as! NSManagedObject)
            try context.save()
        }
    } catch {
        print("Error occured when clearing the database!")
    }
}

