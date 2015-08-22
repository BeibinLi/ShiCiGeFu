//
//  CommentModel.swift
//  诗词歌赋
//
//  Created by Beibin Li on 8/22/15.
//  Copyright © 2015 Beibin Li. All rights reserved.
//



import UIKit
import CoreData


@objc(CommentModel)
class CommentModel : NSManagedObject {
	@NSManaged var comment:String?
	@NSManaged var time:String?
	@NSManaged var username:String?

	
	@NSManaged var score:Int
	
}

