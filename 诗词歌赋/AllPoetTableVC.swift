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
	var navigationViewController: UIViewController?
	@IBOutlet var segmentControl: ADVSegmentedControl!
	

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PoetCell");
		table.dataSource = self
		table.delegate = self
		table.backgroundColor = .clearColor()
		
		
		
		segmentControl.items = ["诗名排序", "诗人排序", "内容排序"]
		segmentControl.font = UIFont(name: "Avenir-Black", size: 13)
		segmentControl.unselectedLabelColor = .lightGrayColor()
		segmentControl.selectedLabelColor = .whiteColor()
		segmentControl.borderColor = .whiteColor()
		segmentControl.thumbColor = .orangeColor()
		segmentControl.selectedIndex = 1
		segmentControl.addTarget(self, action: "segmentValueChanged:", forControlEvents: .ValueChanged)
		
		load_poets()
	}
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func load_poets() {
		let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context:NSManagedObjectContext =  appDel.managedObjectContext
		
		let f_request = NSFetchRequest(entityName: "PoetDB")
		let fetch_result:[AnyObject] = try! context.executeFetchRequest(f_request)
		self.poets = fetch_result as! [PoetModel]
		
		segmentValueChanged(self)
	}
	
	
	
	// MARK: - Table View
	
	
	// for segue
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		// the above line must be deleted!!!
		
		self.poet = self.poets[ indexPath.row ]
		
		
		
		self.slideMenuController()?.changeMainViewController(self.navigationViewController!, close: true)
		let nvc = self.slideMenuController()?.mainViewController as! UINavigationController
		
		
		let controller = nvc.topViewController as! ViewController
		controller.poet = self.poet
		controller.load_poet(false) // re-draw the lines
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return poets.count
	}
	
	
	//set table element
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		// Value1 corresponding to right details, which should be set in storyboard
		let cell: UITableViewCell? = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "PoetCell")
		
		let poet = poets[indexPath.row] as PoetModel
		
		if poet.score > 0 {
			cell!.textLabel!.text = String( poet.title + "♥️" )
		}else if poet.score < 0 {
			cell!.textLabel!.text = String( poet.title + "💔" )
		} else {
			cell!.textLabel!.text = poet.title // set the cell title
		}
		
		
		cell!.textLabel!.textAlignment = NSTextAlignment.Left
		cell!.textLabel!.textColor = UIColor.blackColor()
		cell!.textLabel!.backgroundColor = UIColor.clearColor()
		cell!.backgroundColor = .clearColor()
		cell!.textLabel!.font = UIFont(name: "Helvetica", size: 18)
		
		
		cell!.textLabel!.textColor = .whiteColor()
		
		cell!.detailTextLabel?.text = poet.author
		
		return cell!
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false iff you do not want the specified item to be editable.
		return false
	}
	
	

// MARK: - Segment Control
	
	func segmentValueChanged(sender: AnyObject?){
		let choice = segmentControl.selectedIndex
		
		switch choice {
		case 0:
			self.poets.sortInPlace({ self.chinese_compare( $0.title, $1.title) })
		case 1:
			self.poets.sortInPlace({ self.chinese_compare( $0.author, $1.author) })
		case 2:
			self.poets.sortInPlace({ self.chinese_compare( $0.context, $1.context) })
		default:
			print("Error! the selected index is \(choice)")
		}
		
		table.reloadData()
	}
	
	
	// return true iff x > y in Chinese (localizedCompare) Order
	func chinese_compare(x: String, _ y: String) -> Bool {
		let rst =  x.localizedCompare( y )
		
		switch rst {
		case .OrderedDescending:
			return false
		case .OrderedSame:
			return false
		case .OrderedAscending:
			return true
		}
	}
	
}