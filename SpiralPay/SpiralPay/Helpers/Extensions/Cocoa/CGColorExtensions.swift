//
//  CGColorExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 03/02/2018.
//  Copyright © 2018 omaralbeik. All rights reserved.
//

#if os(macOS)
	import Cocoa
#else
	import UIKit
#endif


public extension CGColor {
	
	#if !os(macOS)
	/// SwifterSwift: UIColor.
	public var uiColor: UIColor? {
		return UIColor(cgColor: self)
	}
	#endif
	
	#if os(macOS)
	/// SwifterSwift: NSColor.
	public var nsColor: NSColor? {
		return NSColor(cgColor: self)
	}
	#endif
	
}
