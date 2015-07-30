//
//  RightViewController.swift
//  诗词歌赋
//
//  Created by Beibin Li on 7/24/15.
//  Copyright © 2015 Beibin Li. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RightViewController:UIViewController, UITextViewDelegate {

	@IBOutlet var note_textview: UITextView!

	var poet:PoetModel?
	var navigationViewController: UIViewController?
	static let script_placeholder = "在此输入对本诗的笔记"

	
// MARK: - UIViewController Functions
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let nvc = self.slideMenuController()?.mainViewController as! UINavigationController
		let controller = nvc.topViewController as! ViewController
		self.poet = controller.poet

		note_textview.delegate = self //setup the delegate for placeholder usage

		if let note = self.poet?.user_notes {
			note_textview.text = note
			note_textview.textColor = .blackColor()
		}else {
			set_placeholder(note_textview)
		}
	}
	
	
	override func viewDidDisappear(animated: Bool) {
		dismiss_keyboard()

		if(note_textview.text == RightViewController.script_placeholder
			|| note_textview.text.noChars() ) {
			return //如果 note 没有改变，无需储存
		}
		
		
		let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context:NSManagedObjectContext =  appDel.managedObjectContext
		
		do {
			// .user_note 和 setValue 一起用，mainViewController 无需再 fetch 一遍本诗
			self.poet?.user_notes = note_textview.text
			self.poet?.setValue( note_textview.text, forKey: "user_notes")
			
			try context.save()
		}catch let err{
			print(err)
		}
		
		super.viewDidDisappear(animated)
	}
	
	
// MARK: - UITextViewDelegate - Placeholder for textView.
// Require: UITextViewDelegate
// Invariant: 当且仅当text 为 placeholder 时，它的颜色是 灰色
	
	func set_placeholder(textView: UITextView){
		textView.text = RightViewController.script_placeholder
		textView.textColor = UIColor.lightGrayColor()
	}
	
	// when script begins editing, I will clear the placeholder and set the color to black
	func textViewDidBeginEditing(textView: UITextView) {

		// 因为我们用颜色来判断 placeholder，对颜色的处理必须异常小心
		if textView.textColor == .lightGrayColor() {
			textView.text = ""
			textView.textColor = UIColor.blackColor()
		}
	}
	
	// set the default placeholder if the script text is empty
	func textViewDidEndEditing(textView: UITextView) {
		dismiss_keyboard()

		if textView.text.noChars() {
			// if the text is empty, set_placeholder again
			set_placeholder(textView)
		}
	}
	
	
// MARK: - Helper Functions
	func dismiss_keyboard() {
		UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
		
		self.note_textview.endEditing(true)
	}
	
}