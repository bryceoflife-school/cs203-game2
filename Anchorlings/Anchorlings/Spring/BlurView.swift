//
//  BlurView.swift
//  Overlap
//
//  Created by Bryce Daniel on 8/9/14.
//  Copyright (c) 2014 Bryce Daniel. All rights reserved.
//

import UIKit

func insertBlurView (view: UIView, style: UIBlurEffectStyle) {
    view.backgroundColor = UIColor.clearColor()
    
    var blurEffect = UIBlurEffect(style: style)
    var blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    view.insertSubview(blurEffectView, atIndex: 0)
    
}
