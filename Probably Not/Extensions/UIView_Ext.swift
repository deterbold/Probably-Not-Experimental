//
//  UIView_Ext.swift
//  Probably Not
//
//  Created by Miguel Sicart on 23/01/2020.
//  Copyright © 2020 playable_systems. All rights reserved.
//

import Foundation
import UIKit
import Swift


//https://stackoverflow.com/questions/3073520/animate-text-change-in-uilabel

extension UIView
{
    func fadeTransition(_ duration:CFTimeInterval)
    {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
