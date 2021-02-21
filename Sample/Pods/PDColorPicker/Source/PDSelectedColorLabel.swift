//
//  PDSelectedColorLabel.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/31/18.
//

import UIKit

class PDSelectedColorLabel: UILabel {
  
  init() {
    super.init(frame: .zero)
    
    clipsToBounds = true
    textAlignment = .center
    
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.black.cgColor
    
    isUserInteractionEnabled = true
    
    if #available(iOS 11.0, *) {
      accessibilityIgnoresInvertColors = true
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
