//
//  Slider.swift
//  TwoSidedSlider
//
//  Created by Alex on 11.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//


import UIKit
import Foundation



class Slider {
    
    private(set) var openCount = 0
    private let time = 0.3   // in seconds
    private let maskViewTag = 200
    
     enum Status {
        case leftMenuOpened
        case free
    }
    
    private var mainView = UIView()
    private var leftConstraint = NSLayoutConstraint()
    private var leftContainer = UIView()
    private(set) var status = Status.free
    

    
    func initialize(view: UIView) {
        
        for testView in view.subviews {
            switch testView.restorationIdentifier {
                
            case String ("leftContainer")?:
                self.leftContainer = testView
                
            default:
                continue
            }
        }
        
        for constraint in view.constraints {
            switch constraint.identifier {
                
            case String ("leftConstraint")?:
                self.leftConstraint = constraint
                self.leftConstraint.constant = 0
                
            default:
                continue
            }
        }
        mainView = view
        mainView.bringSubview(toFront: leftContainer)
    }
    

    
    
    func leftMenuOpen ()  {
        if status != .free {
            return
        }
        
        let maskView = UIView()
        maskView.tag = maskViewTag
        maskView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(maskView)
        mainView.bringSubview(toFront: leftContainer)
        
        let constLeft = NSLayoutConstraint(item: maskView, attribute: .leadingMargin, relatedBy: .equal, toItem: mainView, attribute: .leadingMargin, multiplier: 1, constant: 0)
        let constRight = NSLayoutConstraint(item: maskView, attribute: .trailingMargin, relatedBy: .equal, toItem: mainView, attribute: .trailingMargin, multiplier: 1, constant: 20)
        let constTop = NSLayoutConstraint(item: maskView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: 0)
        let constBottom = NSLayoutConstraint(item: maskView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: 0)
        mainView.addConstraints([constLeft, constRight, constTop, constBottom])

        
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.time) {
                self.leftConstraint.constant = -self.mainView.frame.width
                maskView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
                self.mainView.layoutIfNeeded()
            }
        }
        status = .leftMenuOpened
        openCount += 1
    }
    
    
    func refreshForTransition(toSize: CGSize) {
        if status == .leftMenuOpened {
            self.leftConstraint.constant = -toSize.width
        }
    }
    
    
    func close() {
        switch status {
        case .free:
            return 
            
            
        case .leftMenuOpened:
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.time) {
                    self.leftConstraint.constant = 0
                    self.mainView.viewWithTag(self.maskViewTag)!.backgroundColor = UIColor.clear
                    self.mainView.layoutIfNeeded()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int (self.time*1000)), execute: {
            self.status = .free
            self.mainView.viewWithTag(self.maskViewTag)?.removeFromSuperview()
        })
    }
    
    
    
    private init () { }
    static let shared = Slider()
    
}

let slider = Slider.shared


