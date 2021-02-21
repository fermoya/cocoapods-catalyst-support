//
//  PDRoundedRectButton.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

class PDRoundedRectButton: PDBouncyButton {
  
  var title: String {
    didSet {
      setTitle(title, for: .normal)
      titleLabel?.sizeToFit()
    }
  }
  
  var backColor: UIColor {
    didSet { backgroundColor = backColor }
  }
  
  var foreColor: UIColor {
    didSet { setTitleColor(foreColor, for: .normal) }
  }
  
  override var intrinsicContentSize: CGSize {
    guard let labelSize = titleLabel?.intrinsicContentSize else { return .zero }
    
    return CGSize(width: labelSize.width + contentEdgeInsets.left + contentEdgeInsets.right, height: super.intrinsicContentSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
  }
  
  // MARK: - Initializer
  
  init(title: String, backColor: UIColor, foreColor: UIColor) {
    self.title = ""
    self.backColor = .black
    self.foreColor = .black
    
    super.init(frame: .zero)
    
    defer {
      self.title = title
      self.backColor = backColor
      self.foreColor = foreColor
      
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOffset = CGSize(width: 0, height: 0)
      layer.shadowOpacity = 0.6
      layer.shadowRadius = 4
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = bounds.height / 2
    contentEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
  }
  
}
