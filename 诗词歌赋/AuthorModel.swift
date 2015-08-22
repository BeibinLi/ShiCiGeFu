//
//  AuthorModel.swift
//  诗词歌赋
//
//  Created by Beibin Li on 15/7/13.
//  Copyright © 2015年 Beibin Li. All rights reserved.

import UIKit
import CoreData


@objc(AuthorModel)
class AuthorModel : NSManagedObject {
    @NSManaged var name:String?
	@NSManaged var story:String?
	@NSManaged var year:String?

	
	@NSManaged var score:Int
}


