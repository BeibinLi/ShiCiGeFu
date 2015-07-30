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
	
	@IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var table: UITableView!
    var lines = [String]()
    var poet:PoetModel?
	
	static var used_images = [String]()
	
// MARK: - UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = .redColor()
		self.navigationController?.navigationBar.backgroundColor = .greenColor()
		backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill

		
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell");
        table.dataSource = self
        table.delegate = self
        table.alpha = TEXT_VIEW_TRANSPARENCY
		table.rowHeight = UITableViewAutomaticDimension
		table.estimatedRowHeight = 44.0 // 44 is the default. call this line to enable autolayout
		
        load_poet( ) // load a new poet if needed
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// extension function for UIViewController fom SlideMenuController.swift
		self.setNavigationBarItem()
	}

	
	// 每点一次喜欢按钮，评分 += 1
	@IBAction func like_button_pressed(sender: AnyObject) {
		let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context:NSManagedObjectContext =  appDel.managedObjectContext
		
		do {
			var score = self.poet!.score
			
			if score + 1 <= 100 {
				score += 1
				self.poet?.score  = score
				self.poet?.setValue( score , forKey: "score")
			}
			
			try context.save()
		}catch let err{
			print(err)
		}
	}
	
	
	@IBAction func dislike_button_pressed(sender: AnyObject) {
		
		let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context:NSManagedObjectContext =  appDel.managedObjectContext
		
		do {
			self.poet?.score = -10
			self.poet?.setValue( -10, forKey: "score")
			
			try context.save()
		}catch let err{
			print(err)
		}
		
	}
	
	@IBAction func next_poet(sender: AnyObject) {
		load_poet(true)
	}
	

	
// MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
	
    //set table element
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell

		
		/****		In Storyboard:
		1. Set the prototype cell to "Basic" mdoe
		2. Set "table.rowHeight = UITableViewAutomaticDimension", and
		   Set "table.estimatedRowHeight = 44.0" in ViewDidLoad()
		3. add "cell.textLabel!.numberOfLines = 0" below
		
		Resource: https://www.youtube.com/watch?v=0qE8olxB3Kk
		It's like magic. I don't even know why!
		*/
		
        cell.textLabel!.text = lines[indexPath.row] // set the cell title
		
		cell.textLabel!.textAlignment = .Center
		
		// Note: cell.textLable is Not the Title lable in Storyboard
		
		
        if(indexPath.row == 0) {    // title
			cell.textLabel!.font = font(30, is_bold: true)
            cell.textLabel!.textColor = UIColor.whiteColor()

			// set cell's background color rather than textLabel's color. For safety
			// Sometimes the textLabel's background color would't be loadded
			cell.backgroundColor = .blueColor()

            cell.textLabel!.text =  cell.textLabel!.text!
        }else if(indexPath.row == 1){    // author
			cell.textLabel!.font = font(20, is_bold: true)
			
			cell.backgroundColor = .orangeColor()
            cell.textLabel!.backgroundColor = .orangeColor()
        }else{
            cell.textLabel!.textColor = UIColor.blackColor()

			cell.backgroundColor = .clearColor()
			cell.textLabel!.font = font(18, is_bold: false)
        }
		
		cell.textLabel!.numberOfLines = 0

		return cell
    }
	
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false iff you do not want the specified item to be editable.
        return false
    }

	
// MARK: - Helper Functions

	// Load a new poet into self.poet if needed (by need_new_poet )
	// otherwise, re-draw lines (of the table)
	func load_poet( need_new_poet:Bool = false ) {
		lines.removeAll()
		
		if need_new_poet || self.poet == nil {
			// grab poet for self.poet
			// get a random poet
			let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
			let context:NSManagedObjectContext =  appDel.managedObjectContext
			
			let f_request = NSFetchRequest(entityName: "PoetDB")
			
			let poets:[AnyObject] = try! context.executeFetchRequest(f_request)
			
			
			assert(poets.count > 0, "Error: The poet DB is empty")
			
			repeat {
				let num = Int( arc4random() ) % poets.count
				// unsigned random number with upper bound poets.count, rst in [0, poet.count)
				self.poet = poets[num] as? PoetModel
				
			} while self.poet == nil || self.poet!.score < 0
			
		}
		
		load_image_animation()
		
		// We are sure self.poet is not nil now
		lines.append( self.poet!.title )
		lines.append( self.poet!.author )
		
		let context_array = split( self.poet!.context.characters)
			{   (c:Character)->Bool in
				return c=="，" || c == "。" || c == "？" || c == "！" }.map(String.init)
		
		
		lines += context_array // union two arrays
		table.reloadData() // call build-in function to reload the whole data
	}
	
	
	
	/*
	Load a new Background Image and Animate the transition:
	
	1. The new image has not appeared before
	2. If self.poet specified an image, use that one
	3. If used_images is nearly full, clear it.
	*/
	func load_image_animation() {
		// If poet has default img, load it; otherwise, load rand image
		var img_name = ""
		
		var image_set:[String] = BG_IMAGE_NAMES - ViewController.used_images
		if image_set.count < 5 {
			ViewController.used_images.removeAll()
			image_set = BG_IMAGE_NAMES - ViewController.used_images
		}
		
		img_name = ((self.poet?.img) != nil) ? self.poet!.img! : image_set.rand()
		
		var new_image = UIImage( named: img_name )
		
		while new_image == nil {
			img_name = image_set.rand()
			new_image = UIImage(named: img_name )
		}
		
		ViewController.used_images.append( img_name )
		
		let secondImageView = UIImageView(image: new_image )
		secondImageView.frame = view.frame
		secondImageView.alpha = 0.0
		
		// set contentMode, so the animation looks seamless
		secondImageView.contentMode = UIViewContentMode.ScaleToFill
		backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
		
		view.insertSubview(secondImageView, aboveSubview: backgroundImageView)
		
		UIView.animateWithDuration(2.0, delay: 0.1, options: .TransitionCrossDissolve, animations: {
			secondImageView.alpha = 1.0
			secondImageView.contentMode = UIViewContentMode.ScaleAspectFill
			}, completion: {_ in
				self.backgroundImageView.image = secondImageView.image
				secondImageView.removeFromSuperview()
		})
	}
	

}


