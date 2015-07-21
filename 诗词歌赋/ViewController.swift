//
//  ViewController.swift
//  诗词歌赋
//
//  Created by Beibin Li on 15/7/11.
//  Copyright © 2015年 Beibin Li. All rights reserved.
//

import UIKit
import CoreData
import Darwin


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate  {

	
    @IBOutlet var table: UITableView!
    var lines = [String]()
    var poet:PoetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        load_db_in_frist_launch() // in DBLoadHelper.swift class
        load_introduction()
        
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell");
        table.dataSource = self
        table.delegate = self
        
        table.alpha = 0.7
        
        load_poet( ) // load a new poet if needed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: Helpers
    
    @IBAction func next_poet(sender: AnyObject) {
        load_poet(true)
    }
    
    
    // Load a new poet into self.poet if needed
    // otherwise, do nothing
    func load_poet( need_new_poet:Bool = false ) {
        lines.removeAll()
        
        if need_new_poet || self.poet == nil {
            // get a random poet
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context:NSManagedObjectContext =  appDel.managedObjectContext
            
            let f_request = NSFetchRequest(entityName: "PoetDB")
            
            let poets:[AnyObject] = try! context.executeFetchRequest(f_request)
            
            repeat {
                let num = Int( arc4random() ) % poets.count
                // unsigned random number with upper bound poets.count, rst in [0, poet.count)
                self.poet = poets[num] as? PoetModel
                
                print(poet)
                
            } while self.poet == nil || self.poet!.score < 0
        }
        
        
        // We are sure self.poet is not nil now
        lines.append( self.poet!.title )
        lines.append( self.poet!.author )
        
        let context_array = split( self.poet!.context.characters)
            {   (c:Character)->Bool in
                return c=="，" || c == "。" || c == "？" || c == "！" }.map(String.init)
        
        
        lines += context_array // union two arrays
        
        
        table.reloadData() // call build-in function to reload the whole data
    }
    
	
    func load_introduction() {
        
        let introduction = "introduction_0.1"
        
        
        if( !NSUserDefaults.standardUserDefaults().boolForKey(introduction) ) {
            print("Loading data from .txt file ... ")
            
            clear_DB()
            load_file_from_bundle("shici")
            
            let item1 = RMParallaxItem(image: UIImage(named: "img1")!, text: "随时感悟诗词歌赋")
            let item2 = RMParallaxItem(image: UIImage(named: "img2")!, text: "用心体会世间万物")
            let item3 = RMParallaxItem(image: UIImage(named: "img3")!, text: "让灵魂跟上肉体的步伐")
            let item4 = RMParallaxItem(image: UIImage(named: "img4")!, text: "让经典与您随影随行")
            
            let rmParallaxViewController = RMParallax(items: [item1, item2, item3, item4], motion: false)
            rmParallaxViewController.completionHandler = {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    rmParallaxViewController.view.alpha = 0.0
                })
            }
            
            // Adding parallax view controller.
            self.addChildViewController(rmParallaxViewController)
            self.view.addSubview(rmParallaxViewController.view)
            rmParallaxViewController.didMoveToParentViewController(self)
            
            // Override the syntax
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: introduction)
            NSUserDefaults.standardUserDefaults().synchronize();
        }
        
    }
    
    // MARK: - Table View
    
    
    // for segue
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        println(indexPath)
        //        println(indexPath.row)
        //    let cell = tableView.cellForRowAtIndexPath(indexPath)
        //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // the above line must be deleted!!!
        
        
        //    performSegueWithIdentifier("showCharacter", sender: cell)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    
    //set table element
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel!.text = lines[indexPath.row] // set the cell title
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        
        
//        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        cell.textLabel!.numberOfLines = 0 // zero means infinite
        
        
        if(indexPath.row == 0) {    // title
			cell.textLabel!.font = font(30, is_bold: true)
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.textLabel!.backgroundColor = .blueColor()
            cell.textLabel!.text =  cell.textLabel!.text!  + "标题长长长长长长长长长长长长长长长长长长长长长长长长标题"
        }else if(indexPath.row == 1){    // author
			cell.textLabel!.font = font(20, is_bold: true)
            cell.textLabel!.textColor = .whiteColor()
            cell.textLabel!.backgroundColor = .orangeColor()
        }else{
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.textLabel!.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = .clearColor()
			cell.textLabel!.font = font(18, is_bold: false)
        }
        
//        cell.textLabel!.frame = CGRectMake(0, 0, cell.widthAnchor. , CGFloat.max)
        
        
//        let label:UILabel = UILabel(frame: CGRectMake(0, 0, cell.widthAnchor, CGFloat.max))
////        let label:UILabel = cell.textLabel!
//        
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        label.sizeToFit()
//        let height = label.frame.height
//        
//        //adjust the label the the new height.
//        var newFrame = label.frame;
//        newFrame.size.height = height;
//        label.frame = newFrame;
        
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


