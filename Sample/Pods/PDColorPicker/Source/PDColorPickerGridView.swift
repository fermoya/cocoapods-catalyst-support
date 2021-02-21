//
//  PDColorPickerGridView.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

protocol PDColorPickerGridDelegate: class {
  func colorChanged(to newColor: PDColor)
}

protocol PDColorPickerGridDataSource: class {
  func selectedHueForColorPicker() -> CGFloat?
}

class PDColorPickerGridView: UIView {
  
  // MARK: - Gesture Recognizer
  
  lazy var panRecognizer: PDPanGestureRecognizer = {
    return PDPanGestureRecognizer(target: self, action: #selector(colorDragged(_:)))
  }()
  
  lazy var tapRecognizer: PDTapGestureRecognizer = {
    return PDTapGestureRecognizer(target: self, action: #selector(colorTapped(_:)))
  }()
  
  // MARK: - Properties
  
  weak var delegate: PDColorPickerGridDelegate?
  weak var dataSource: PDColorPickerGridDataSource?
  
  var currentColor: PDColor? {
    didSet { setSliderCircle() }
  }
  
  var selectedHue: CGFloat? {
    didSet {
      guard let selectedHue = selectedHue else { return }
      backgroundColor = UIColor(hue: selectedHue, saturation: 1, brightness: 1, alpha: 1)
    }
  }
  
  // MARK: - Slider Properties
  
  lazy var sliderCircle: UIView = {
    let circle = UIView()
    circle.layer.borderColor = UIColor.black.cgColor
    circle.layer.borderWidth = 2.0
    circle.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    circle.alpha = 0
    return circle
  }()
  
  lazy var sliderCircleX: NSLayoutConstraint = {
    let constraint = NSLayoutConstraint(item: self.sliderCircle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 100)
    return constraint
  }()
  
  lazy var sliderCircleY: NSLayoutConstraint = {
    let constraint = NSLayoutConstraint(item: self.sliderCircle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 100)
    return constraint
  }()
  
  let sliderSize: CGFloat = 25
  let visibilityOffset: CGFloat = 60
  let circleGrowthScale: CGFloat = 3
  
  // MARK: - Initializer
  
  init() {
    super.init(frame: .zero)
    
    if #available(iOS 11.0, *) {
      accessibilityIgnoresInvertColors = true
    }
    
    addGestureRecognizer(panRecognizer)
    addGestureRecognizer(tapRecognizer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  
  var initialViewLoad = true
  override func layoutSubviews() {
    super.layoutSubviews()
    
    setupGradient()
    
    if initialViewLoad {
      addSubview(sliderCircle)
      sliderCircle.anchor(height: sliderSize, width: sliderSize)
      addConstraints([sliderCircleX, sliderCircleY])
      
      layoutIfNeeded()
      sliderCircle.layer.cornerRadius = sliderCircle.frame.width / 2
      setSliderCircle()
      
      initialViewLoad = false
    }
  }
  
  // MARK: - Setup
  
  var saturationGradient = CAGradientLayer()
  var brightnessGradient = CAGradientLayer()
  
  func setupGradient() {
    saturationGradient.removeFromSuperlayer()
    brightnessGradient.removeFromSuperlayer()
    
    saturationGradient = gradientLayerWithEndPoints(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), endColor: .white)
    brightnessGradient = gradientLayerWithEndPoints(CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1), endColor: .black)
    
    layer.addSublayer(saturationGradient)
    layer.addSublayer(brightnessGradient)
    
    bringSubviewToFront(sliderCircle)
  }
  
  private func gradientLayerWithEndPoints(_ start: CGPoint, _ end: CGPoint, endColor: UIColor) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    
    gradientLayer.frame = self.bounds
    gradientLayer.colors = [UIColor.clear.cgColor, endColor.cgColor]
    
    gradientLayer.startPoint = start
    gradientLayer.endPoint = end
    
    return gradientLayer
  }
  
  // MARK: - Gesture
  
  @objc func colorDragged(_ recognizer: PDPanGestureRecognizer) {
    let pos = recognizer.location(in: self)
    let comps = colorComponents(at: pos)
    let sliderCenter = constrainPosition(pos, toBounds: bounds)
    
    delegate?.colorChanged(to: comps)
    sliderCircle.backgroundColor = comps.uiColor
    
    switch recognizer.state {
    case .began:
      animateCircleSlider(.grow)
    case .changed:
      sliderCircleX.constant = sliderCenter.x
      sliderCircleY.constant = sliderCenter.y - visibilityOffset
    case .ended:
      sliderCircle.backgroundColor = UIColor.white.withAlphaComponent(0.6)
      animateCircleSlider(.shrink)
    default:
      break
    }
  }
  
  @objc func colorTapped(_ recognizer: PDTapGestureRecognizer) {
    let pos = recognizer.location(in: self)
    let comps = colorComponents(at: pos)
    let sliderCenter = constrainPosition(pos, toBounds: bounds)
    
    delegate?.colorChanged(to: comps)
    sliderCircle.backgroundColor = comps.uiColor
    
    animateCircleSlider(.grow)
    
    sliderCircleX.constant = sliderCenter.x
    sliderCircleY.constant = sliderCenter.y - visibilityOffset
    
    sliderCircle.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    animateCircleSlider(.shrink)
  }
  
  // MARK: - Slider Management
  
  enum FadeMode { case `in`, out }
  
  func fadeSlider(_ mode: FadeMode) {
    UIView.animate(withDuration: 0.25) {
      self.sliderCircle.alpha = (mode == .in) ? 1 : 0
    }
  }
  
  func setSliderCircle() {
    guard let currentColor = currentColor else { return }
    
    sliderCircleX.constant = (1 - currentColor.s) * bounds.width
    sliderCircleY.constant = (1 - currentColor.b) * bounds.height
    
    sliderCircle.setNeedsLayout()
  }
  
  func constrainPosition(_ pos: CGPoint, toBounds rect: CGRect) -> CGPoint {
    let x = min(max(pos.x, 0), rect.width)
    let y = min(max(pos.y, 0), rect.height)
    
    return CGPoint(x: x, y: y)
  }
  
  enum CircleSliderAnimationType: Int {
    case grow = -1, shrink = 1
  }
  
  func animateCircleSlider(_ type: CircleSliderAnimationType) {
    let sliderOffsetDirection: CGFloat = CGFloat(type.rawValue)
    
    // if sliderOffsetDirection = 1, scale = circleGrowthScale, otherwise scale = circleGrowthScale ^ -1
    let scale = pow(circleGrowthScale, -sliderOffsetDirection)
    
    let transform = sliderCircle.transform.scaledBy(x: scale, y: scale)
    sliderCircleY.constant += visibilityOffset * sliderOffsetDirection
    
    UIView.animate(withDuration: 0.25, animations: {
      self.sliderCircle.transform = transform
      self.layoutIfNeeded()
    })
  }
  
  func colorComponents(at point: CGPoint) -> PDColor {
    let s = min(max(bounds.width - point.x, 0) / bounds.width, 1)
    let b = min(max(bounds.height - point.y, 0) / bounds.height, 1)
    
    return PDColor(h: dataSource?.selectedHueForColorPicker() ?? 1, s: s, b: b, a: 1)
  }
  
}
