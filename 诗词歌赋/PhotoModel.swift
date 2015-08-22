//
//  PhotoModel.swift
//  诗词歌赋
//
//  Created by Beibin Li on 8/22/15.
//  Copyright © 2015 Beibin Li. All rights reserved.
//

import UIKit
import CoreData


@objc(PhotoModel)
class PhotoModel : NSManagedObject {
	@NSManaged var name:String?
	@NSManaged var path:String?
	
	@NSManaged var score:Int
	
}

