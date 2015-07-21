//
//  FontHelper.swift
//  诗词歌赋
//
//  Created by Beibin Li on 7/21/15.
//  Copyright © 2015 Beibin Li. All rights reserved.
//

import UIKit

// STXINGKA.tff   华文行楷   STXingKai
// STXINWEI.tff   华文新魏   STXinWei


private let DEFAULT_FONT = "Helvetica"
private let USER_FONT = "Font"



// Return the UIFont by user's preference
func font(size:Int, is_bold: Bool) -> UIFont {
	
	// safe check the NSUserDefault font name
	let font_name = get_font_name(
				NSUserDefaults.standardUserDefaults().stringForKey( USER_FONT ),
				is_bold: is_bold )
	
	return UIFont(name: font_name, size: CGFloat(size) )!
}


// Set UIFont
func set_font(font: String) {
	// We can ignore safe check here. 
	// It's redundant, because we will check everytime we access the font
	
	NSUserDefaults.standardUserDefaults().setValue(font, forKey: USER_FONT )
	NSUserDefaults.standardUserDefaults().synchronize();
}


// Helper function: Return the Font name
private func get_font_name(font_name: String?, is_bold:Bool = false) -> String {
	
	if let font = font_name {
		
		// the reason we use Swtich statement here is to safe check the font setting 
		// for users. If NSUserDefaults stores a trash value, we will set it to default
		switch font {
		case "Helvetica":
			if is_bold {
				return "Helvetica-bold"
			}else{
				return "Helvetica"
			}
		case "STXingKai":
			return "STXingKai"
		case "STXinWei":
			return "STXinWei"
		default:
			return DEFAULT_FONT
		}
	}else{
		// if parameter is nil, return default font
		return DEFAULT_FONT
	}
	
}

// Print all availabel font names
private func list_all_fonts() {
	for x in UIFont.familyNames() {
		print(x)
	}
}
