//
//  Dimmable.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

/// Provides a simple mechanism for dimming a view controller.
///
/// The intended usage of this protocol is to allow dimming of a view controller
/// so that another view controller (e.g. an alert) may be presented on top of it.
///
/// - note:
/// Be sure to carefully read the documentation for proper use of the `dim()` and
/// `undim()` methods that are implemented by this protocol. Misuse may cause issues
/// with the view hierarchy of the view controller.
public protocol Dimmable {  }

public extension Dimmable where Self: UIViewController {
  
  /// Convenience method that creates a view in frame `rect`,
  /// with color `color` and transparency `alpha`.
  private func createDimView(in superview: UIView, color: UIColor, alpha: CGFloat) -> UIView? {
    let dimView = UIView()
    
    superview.addSubview(dimView)
    dimView.anchorFill(view: superview)
    
    dimView.backgroundColor = color
    dimView.alpha = 0
    
    if #available(iOS 11.0, *) {
      dimView.accessibilityIgnoresInvertColors = true
    }
    
    return dimView
  }
  
  /**
   Dims the view controller that it is called on. If the view controller is inside a `UINavigationController`,
   `UITabBarController`, or both, the entire view will be dimmed including the navigation bar and tab bar.
   
   - warning:
   Do not add any subviews to the view controller while it is dimmed. Instead, call `undim()` on the
   view controller before adding any subviews.
   
   - parameters:
   - color: The tint color to be used in dimming. The default is `UIColor.black`.
   - alpha: The transparency level of the dim. A value of 0.0 means a completely transparent dim (no effect)
   whereas 1.0 is a completely opaque dim. The default value is 0.5.
   - speed: The animation speed of the dimming (in seconds). The default value is 0.5.
   */
  func dim(_ color: UIColor = .black, alpha: CGFloat = 0.5, speed: TimeInterval = 0.5) {
    let viewToDim: UIView
    
    if let navigationController =  navigationController {
      viewToDim = navigationController.view
    } else {
      viewToDim = self.view
    }
    
    if let dimmingView = createDimView(in: viewToDim, color: color, alpha: alpha) {
      UIView.animate(withDuration: 0.25) { dimmingView.alpha = alpha }
    }
    
    if let tabBar = tabBarController?.tabBar {
      if let tabBarDimView = createDimView(in: tabBar, color: color, alpha: alpha) {
        UIView.animate(withDuration: 0.25) { tabBarDimView.alpha = alpha }
      }
    }
  }
  
  /**
   Undims the view controller that it is called on. This method has no effect if the view controller
   has not been dimmed with `dim()` yet.
   
   - warning:
   Do not call this method unless `dim()` has been called first and the view controller has not
   been undimmed already. Calling this method when the view controller is not dimmed may cause
   issues with the view hierarchy.
   
   - parameters:
   - speed: The animation speed of the undimming (in seconds). The default value is 0.5.
   - completion: The completion handler that is called after the undimming is complete. Use this
   parameter to execute any cleanup or setup code that should be executed immediately after the
   view controller becomes visible again.
   */
  func undim(speed: TimeInterval = 0.5, completion: @escaping () -> () = {}) {
    UIView.animate(withDuration: speed, animations: {
      self.tabBarController?.tabBar.subviews.last?.alpha = 0
      
      if let navigationController = self.navigationController {
        navigationController.view.subviews.last?.alpha = 0
      } else {
        self.view.subviews.last?.alpha = 0
      }
      
      self.view.subviews.last?.alpha = 0
      
    }, completion: { _ in
      self.tabBarController?.tabBar.subviews.last?.removeFromSuperview()
      
      if let navigationController = self.navigationController {
        navigationController.view.subviews.last?.removeFromSuperview()
      } else {
        self.view.subviews.last?.removeFromSuperview()
      }
      
      completion()
    })
  }
  
}
