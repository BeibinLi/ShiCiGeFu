//
//  PoetModel.swift
//  诗词歌赋
//
//  Created by Beibin Li on 15/7/12.
//  Copyright © 2015年 Beibin Li. All rights reserved.
//

import UIKit
import CoreData


@objc(PoetModel)
class PoetModel : NSManagedObject {
    @NSManaged var author:String
    @NSManaged var title:String
    @NSManaged var context:String
    
    @NSManaged var img:String?
    @NSManaged var score:Int
}


