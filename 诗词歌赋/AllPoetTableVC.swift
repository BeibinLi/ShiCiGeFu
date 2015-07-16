//
//  AllPoetTableVC.swift
//  诗词歌赋
//
//  Created by Beibin Li on 15/7/16.
//  Copyright © 2015年 Beibin Li. All rights reserved.
//

import Foundation

import UIKit
import CoreData


class AllPoetTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate  {
    
    @IBOutlet var table: UITableView!
    var poets = [PoetModel]()
    var poet:PoetModel? // store the poet we are going to display

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PoetCell");
        table.dataSource = self
        table.delegate = self

        load_poets()
    }
    
    
    func load_poets() {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext =  appDel.managedObjectContext
        
        let f_request = NSFetchRequest(entityName: "PoetDB")
        
        
        do{
            let fetch_result:[AnyObject] = try! context.executeFetchRequest(f_request)
            
            self.poets = fetch_result as! [PoetModel]
        }catch {
            print("Could not load the data of poets!")
        }
        
  
    }
    
    
    
    // MARK: - Table View
    
    
    // for segue
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        println(indexPath)
        //        println(indexPath.row)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // the above line must be deleted!!!
        
        self.poet = self.poets[ indexPath.row ]
        
        
        
        performSegueWithIdentifier("showPoet", sender: cell)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPoet" {
            let controller = segue.destinationViewController as! ViewController
            controller.poet = self.poet
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poets.count
    }
    
    
    //set table element
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("PoetCell", forIndexPath: indexPath) as UITableViewCell
        
        
        let poet = poets[indexPath.row] as PoetModel
        
        
        var text = poet.author
        
        
        // 我们定义 5 在此，因为诗人名字最多 四个字。 五个字的 space 给了诗人名字，外加一个额外的空格
        let white_space:Int = 5 - text.length
        text += (white_space * 2) * String(" ")
        
        
        
//              The following 4 lines are great, But have bugs in UIView build-in class
//                      So, depricated
//        let label1: UILabel = UILabel(frame: cell.frame)
//        label1.text = poet.title
//        label1.textAlignment = NSTextAlignment.Right
//        cell.contentView.addSubview(label1 as UIView)
        
        
        cell.textLabel!.text = text + poet.title // set the cell title
        cell.textLabel!.textAlignment = NSTextAlignment.Left
        
        
        cell.textLabel!.textColor = UIColor.blackColor()
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = .clearColor()
        cell.textLabel!.font = UIFont(name: "Helvetica", size: 18)

        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false iff you do not want the specified item to be editable.
        return false
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == .Delete {
            
            //            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            //            let context:NSManagedObjectContext =  appDel.managedObjectContext
            //
            //            context.deleteObject(objects[indexPath.row] as! NSManagedObject)
            //
            //            objects.removeAtIndex(indexPath.row)
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //
            //            do {
            //                try context.save()
            //            } catch _ {
            //            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            
        }
    }
    

    
    
    

}