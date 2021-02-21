//
//  PDBouncyButton.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class PDBouncyButton: UIButton, Bounceable {
  
  let bounceScale: CGFloat = 0.9
  let bounceDuration: TimeInterval = 0.15
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    bounceIn(at: bounceScale, with: bounceDuration)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    bounceOut(with: bounceDuration)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    bounceOut(with: bounceDuration)
  }
  
}


protocol Bounceable {}

extension Bounceable where Self: UIView {
  func bounceIn(at scale: CGFloat, with duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
  }
  
  func bounceOut(with duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.transform = .identity
    }
  }
}

