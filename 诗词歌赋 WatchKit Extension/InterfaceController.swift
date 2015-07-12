//
//  InterfaceController.swift
//  诗词歌赋 WatchKit Extension
//
//  Created by Beibin Li on 15/7/11.
//  Copyright © 2015年 Beibin Li. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var poet_title: WKInterfaceLabel!
    
    @IBOutlet var author: WKInterfaceLabel!

    @IBOutlet var like_button: WKInterfaceButton!
    
    @IBOutlet var context_label: WKInterfaceLabel!
    
    var like = false

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        poet_title.setText( "思乡" )
        poet_title.setTextColor( UIColor.blueColor() )
        
        author.setText( "李白" )
//        context_label.setAttributedText( NSAttributedString(string: "床前明月光，\n疑似地上霜，\n举头望明月，\n低头思故乡") )

        context_label.setText("床前明月光，\n疑似地上霜，\n举头望明月，\n低头思故乡。")
        
        
        
        
        config_button()
        
        
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func config_button() {
        if like{
            like_button.setTitle("💔 不喜欢")
        }else{
            like_button.setTitle("♥️ 喜欢")
        }
    }
    

    
}
