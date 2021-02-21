//
//  PDPanGestureRecognizer.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/13/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

/// A testable subclass of `UIPanGestureRecognizer`.
class PDPanGestureRecognizer: UIPanGestureRecognizer {
  
  let testTarget: Any?
  let testAction: Selector?
  
  var testState: UIGestureRecognizer.State?
  var testLocation: CGPoint?
  var testTranslation: CGPoint?
  
  // MARK: - Overrides
  
  override init(target: Any?, action: Selector?) {
    testTarget = target
    testAction = action
    super.init(target: target, action: action)
  }
  
  override var state: UIGestureRecognizer.State {
    get {
      if let testState = testState {
        return testState
      }
      
      return super.state
    }
    set {
      super.state = newValue
    }
  }
  
  override func location(in view: UIView?) -> CGPoint {
    if let testLocation = testLocation {
      return testLocation
    }
    
    return super.location(in: view)
  }
  
  override func translation(in view: UIView?) -> CGPoint {
    if let testTranslation = testTranslation {
      return testTranslation
    }
    
    return super.translation(in: view)
  }
  
  // MARK: - Test Touches
  
  func performTouch(location: CGPoint?, translation: CGPoint?, state: UIGestureRecognizer.State) {
    testLocation = location
    testTranslation = translation
    testState = state
    
    if let action = testAction {
      (testTarget as AnyObject).perform(action, on: .current, with: self, waitUntilDone: true)
    }
  }
  
}
