//
//  library_extension.swift
//  诗词歌赋
//
//  Created by Beibin Li on 15/7/12.
//  Copyright © 2015年 Beibin Li. All rights reserved.
//

import Foundation


extension String {
    
    func find(c:Character) -> Int {
        
        for(var i = 0; i < self.characters.count; i++){
            let index = advance(self.startIndex, i)
            
            if(self[index] == c) {
                return i
            }
        }
        
        return -1
    }
    
    
    subscript(integerIndex: Int) -> Character
        {
            let index = advance(startIndex, integerIndex)
            return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String
        {
            let start = advance(startIndex, integerRange.startIndex)
            let end = advance(startIndex, integerRange.endIndex)
            let range = start..<end
            return self[range]
    }
    
    
    // return the substring [start, end)
    func substring(var start:Int, var _ end:Int) -> String {
        end = min( end, self.characters.count )
        start = max(0, start)
        
        if(start > end) {
            print("Cannot get the substring! The end index is smaller than the start index")
        }
        
        return self.substringWithRange(Range<String.Index>(
                    start: advance(self.startIndex, start),
                        end: advance(self.startIndex, end)))
    }
    
    
    var length:Int {
        get{
            return self.characters.count
        }
    }

    
}


func * (left:Int, right:String) -> String {
    var rst = ""
    
    if left <= 1 { return right }// do nothing
    
    for _ in 1...left {
        rst += right
    }
    
    return rst
}

func * (inout left: String, right: Int) -> String {
    return right * left
}
