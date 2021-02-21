//
//  UIView+Layout.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
extension UIView {
  
  /**
   Provides a convenient method for anchoring the receiver to other
   anchors within its view hierarchy. All parameters have default values of
   `nil` or `0` so only the desired constraints need be provided.
   
   This method should only be called *after* the receiver has been added to its superview,
   otherwise an exception may be thrown.
   
   This method automatically sets `translatesAutoresizingMaskIntoConstraints` to `false` on
   the receiver.
   
   All parameters are optional and are set to sensible defaults if ignored (e.g. `nil` or `0`).
   
   Example:
   
   ```
   // in a UIView subclass:
   let aView = UIView()
   addSubview(aView)
   // sets aView to be positioned 10 points from the
   //   containing view's left anchor
   aView.anchor(left: self.leftAnchor, leftConstant: 10)
   ```
   
   - parameter left: The anchor to pin the left side of the receiver to.
   - parameter right: The anchor to pin the right side of the receiver to.
   - parameter top: The anchor to pin the top side of the receiver to.
   - parameter bottom: The anchor to pin the bottom side of the receiver to.
   - parameter leftConstant: The number of points of spacing given to the left side (increases to the right).
   - parameter rightConstant: The number of points of spacing given to the right side (increases to the left).
   - parameter topConstant: The number of points of spacing given to the top side (increases down).
   - parameter bottomConstant: The number of points of spacing given to the bottom side (increases up).
   - parameter height: The fixed height in points.
   - parameter width: The fixed width in points.
   */
  func anchor(left: NSLayoutXAxisAnchor? = nil,
              right: NSLayoutXAxisAnchor? = nil,
              top: NSLayoutYAxisAnchor? = nil,
              bottom: NSLayoutYAxisAnchor? = nil,
              leftConstant: CGFloat = 0,
              rightConstant: CGFloat = 0,
              topConstant: CGFloat = 0,
              bottomConstant: CGFloat = 0,
              height: CGFloat = 0,
              width: CGFloat = 0) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let left = left {
      leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
    }
    
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
    }
    
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
    }
    
    if width > 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height > 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
  
  func anchorFill(view: UIView? = nil) {
    guard let view = view ?? superview else {
      fatalError("No view provided, and a superview doesn't exist. Be sure to add the view as a subview before calling anchorFill().\n\n")
    }
    
    anchor(left: view.leftAnchor, right: view.rightAnchor, top: view.topAnchor, bottom: view.bottomAnchor)
  }
  
}
