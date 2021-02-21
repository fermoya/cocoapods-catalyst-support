//
//  PDColorPickerSliderView.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

protocol PDColorPickerSliderDelegate: class {
  func hueChanged(to newHue: CGFloat)
}

class PDColorPickerSliderView: UIView {
  
  // MARK: - Gesture Recognizer
  
  lazy var panRecognizer: PDPanGestureRecognizer = {
    return PDPanGestureRecognizer(target: self, action: #selector(colorDragged(_:)))
  }()
  
  lazy var tapRecognizer: PDTapGestureRecognizer = {
    return PDTapGestureRecognizer(target: self, action: #selector(colorTapped(_:)))
  }()
  
  // MARK - Properties
  
  weak var delegate: PDColorPickerSliderDelegate?
  
  var currentHue: CGFloat? {
    didSet {
      if let currentHue = currentHue { delegate?.hueChanged(to: currentHue) }
      setHueSlider()
    }
  }
  
  var borderWidth: CGFloat = 4 {
    didSet { setNeedsDisplay() }
  }
  
  // MARK: - Slider Properties
  
  var elementSize: CGFloat = 1 {
    didSet { setNeedsDisplay() }
  }
  
  let sliderOffset: CGFloat = 3
  
  lazy var hueSlider: UIView = {
    let slider = UIView()
    slider.layer.borderColor = UIColor.black.cgColor
    slider.layer.borderWidth = 1.0
    slider.backgroundColor = UIColor.white.withAlphaComponent(0.75)
    return slider
  }()
  
  lazy var sliderX: NSLayoutConstraint = {
    let constraint = NSLayoutConstraint(item: self.hueSlider, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 100)
    return constraint
  }()
  
  var sliderHalfWidth: CGFloat {
    return hueSlider.bounds.width / 2
  }
  
  // MARK: - Initializer
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .clear
    
    if #available(iOS 11.0, *) {
      accessibilityIgnoresInvertColors = true
    }
    
    addGestureRecognizer(panRecognizer)
    addGestureRecognizer(tapRecognizer)
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.4
    layer.shadowRadius = 10
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  
  var initialViewLoad = true
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if initialViewLoad {
      addSubview(hueSlider)
      hueSlider.anchor(top: topAnchor, bottom: bottomAnchor, width: 8)
      addConstraint(sliderX)
      
      layoutIfNeeded()
      hueSlider.layer.cornerRadius = hueSlider.frame.width / 2
      setHueSlider()
      
      initialViewLoad = false
    }
  }
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    for x in stride(from: CGFloat(borderWidth), to: rect.width - borderWidth, by: elementSize) {
      let hue = hueAtPosition(x, containingRect: bounds)
      let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
      
      context?.setFillColor(color.cgColor)
      context?.fill(CGRect(x: x, y: borderWidth, width: elementSize, height: bounds.height - 2 * borderWidth))
    }
  }
  
  // MARK: - Gesture
  
  @objc func colorDragged(_ sender: UIPanGestureRecognizer) {
    let pos = sender.location(in: self)
    
    switch sender.state {
    case .changed:
      currentHue = hueAtPosition(pos.x, containingRect: bounds)
      sliderX.constant = constrainPosition(pos, toBounds: bounds)
    default:
      break
    }
  }
  
  @objc func colorTapped(_ sender: UITapGestureRecognizer) {
    let pos = sender.location(in: self)
    
    currentHue = hueAtPosition(pos.x, containingRect: bounds)
    sliderX.constant = constrainPosition(pos, toBounds: bounds)
  }
  
  // MARK: - Slider Management
  
  func setHueSlider() {
    guard let hue = currentHue else { return }
    sliderX.constant = borderWidth + hue * (bounds.width - 2 * borderWidth)
  }
  
  func constrainPosition(_ pos: CGPoint, toBounds rect: CGRect) -> CGFloat {
    let maximum = rect.width - borderWidth
    let minimum = borderWidth
    
    return max(min(pos.x, maximum), minimum)
  }
  
  func hueAtPosition(_ x: CGFloat, containingRect: CGRect) -> CGFloat {
    return min(max(x / (containingRect.width - 2 * borderWidth), 0), 1)
  }
  
}
