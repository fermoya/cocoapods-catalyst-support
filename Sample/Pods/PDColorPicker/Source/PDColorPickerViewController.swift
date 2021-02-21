//
//  PDColorPickerViewController.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

/// Creates a modal color picker view that allows the user
/// to select hue, saturation, and brightness values in an
/// easy to use, fast interface.
///
/// To present the view controller, execute the following
///   from the presenting view controller:
///
///     let colorPickerVC = PDColorPickerViewController { _ in
///       // handle completion
///     }
///     present(colorPickerVC, animated: true)
///
/// **Note** Dimming the presenting view controller is recommended
///   for a better appearance.
///   See the `Dimmable` protocol.
@available(iOS 9.0, *)
open class PDColorPickerViewController: UIViewController {
  
  public enum HexStringCase {
    case upper, lower
    
    @available(*, deprecated, renamed: "upper")
    case uppercase
    @available(*, deprecated, renamed: "lower")
    case lowercase
    
    func applied(to string: String) -> String {
      switch self {
      case .uppercase:
        return string.uppercased()
      case .lowercase:
        return string.lowercased()
      case .upper:
        return string.uppercased()
      case .lower:
        return string.lowercased()
      }
    }
  }
  
  private struct LocalConstants {
    static let padding: CGFloat = 8
  }
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Buttons
  
  lazy var saveButton: PDRoundedRectButton = {
    let button = PDRoundedRectButton(title: "Save", backColor: .white, foreColor: self.tintColor)
    
    button.addTarget(self, action: #selector(save), for: .touchUpInside)
    button.titleLabel?.font = boldFont
    
    return button
  }()
  
  lazy var cancelButton: PDRoundedRectButton = {
    let button = PDRoundedRectButton(title: "Cancel", backColor: .white, foreColor: .red)
    
    button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    button.titleLabel?.font = font
    
    return button
  }()
  
  // MARK: - Color Picking Views
  
  lazy var colorPickerView: PDColorPickerGridView = {
    let pickerView = PDColorPickerGridView()
    pickerView.delegate = self
    pickerView.dataSource = self
    return pickerView
  }()
  
  lazy var colorSliderView: PDColorPickerSliderView = {
    let sliderView = PDColorPickerSliderView()
    sliderView.delegate = self
    return sliderView
  }()
  
  var selectedColorLabel = PDSelectedColorLabel()
  
  // MARK: - Properties
  
  /// The tint color of the **Save** button.
  open var tintColor: UIColor {
    didSet {
      saveButton.foreColor = tintColor
    }
  }
  
  /// The background color of the view.
  /// The default value is `UIColor.lightGray`
  open var backgroundColor: UIColor = .lightGray {
    didSet {
      view.backgroundColor = backgroundColor
    }
  }
  
  /// The currently selected color of the color picker.
  open var currentColor: PDColor
  
  /// The completion handler that is called when the color picker is dismissed.
  open var completion: (PDColor?) -> ()
  
  /// Whether or not to display the hexadecimal code in the selected color preview.
  /// The default value is `true`.
  open var showHexString = true
  
  /// Whether to display the hexadecimal code in `uppercase` or `lowercase`.
  /// This property has no effect if `showHexString` is set to `false`.
  /// The default is `uppercase`.
  open var hexStringCase: HexStringCase = .upper
  
  /// Whether or not to support Smart Invert Colors on iOS 11.0+.
  /// It is highly recommended to leave this value set to the default of true as
  ///   inverted colors may cause unexpected behavior.
  open var supportSmartInvertColors = true {
    didSet {
      if #available(iOS 11.0, *) {
        selectedColorLabel.accessibilityIgnoresInvertColors = supportSmartInvertColors
        colorSliderView.accessibilityIgnoresInvertColors = supportSmartInvertColors
        colorPickerView.accessibilityIgnoresInvertColors = supportSmartInvertColors
      } else {
        print("\n\n[PDColorPicker] Warning: supportSmartInvertColors is only available on iOS 11.0 or later, be sure to check availability using #available(iOS 11.0, *).\n\n")
      }
    }
  }
  
  /// The font to be used on the **Cancel** button and color preview.
  ///
  /// The default value is the system font at size 18.
  open var font: UIFont = .systemFont(ofSize: 18) {
    didSet {
      cancelButton.titleLabel?.font = font
      selectedColorLabel.font = font
    }
  }
  
  /// The font to be used on the **Save** button.
  ///
  /// The default value is the bold system font at size 18.
  open var boldFont: UIFont = .boldSystemFont(ofSize: 18) {
    didSet {
      saveButton.titleLabel?.font = boldFont
    }
  }
  
  /// Whether or not to allow drag and drop of the color preview.
  ///
  /// The default value is `true`.
  open var allowsDragAndDrop: Bool = true {
    didSet {
      guard #available(iOS 11.0, *) else {
        print("\n\n[PDColorPicker] Warning: allowsDragAndDrop is only available on iOS 11.0 or later, be sure to check availability using #available(iOS 11.0, *).\n\n")
        return
      }
      
      if allowsDragAndDrop {
        selectedColorLabel.addInteraction(colorDragInteraction)
      } else {
        selectedColorLabel.removeInteraction(colorDragInteraction)
      }
    }
  }
  
  @available(iOS 11.0, *)
  private lazy var colorDragInteraction: UIDragInteraction = {
    return UIDragInteraction(delegate: self)
  }()
  
  // MARK: - Initializer
  
  /**
   Creates a `PDColorPickerViewController` with an initial color, a tint color for the *Save* button, and a completion callback to handle the user response.
   
   - parameter initialColor: The starting color that the color picker should be set to. This parameter can be any `UIColor`.
   The hue, saturation, and brightness values will be parsed from the given color and used to provide the starting positions of the sliders.
   The default value is `UIColor.red` which places the hue slider to the left and the saturation/brightness slider in the top left.
   - parameter tintColor: Currently this property only affects the text color of the *Save* button. The default value is `UIColor.blue`.
   - parameter completion: The completion callback that is called when the user taps *Save* or *Cancel*. The callback returns a single `PDColor?`
   parameter that contains the selected color as a `PDColor` if the user taps *Save*, or `nil` if the user taps *Cancel*.
   The default completion is a blank closure (this allows implementation after initialization if necessary).
   - parameter selectedColor: The color selected by the user when `PDColorPickerViewController` is displayed. If the user cancels, the value is `nil`.
   */
  public init(initialColor: UIColor = .red, tintColor: UIColor = .blue, completion: @escaping (_ selectedColor: PDColor?) -> () = { _ in }) {
    self.currentColor = PDColor(color: initialColor)
    self.tintColor = tintColor
    self.completion = completion
    
    super.init(nibName: nil, bundle: nil)
    
    modalPresentationStyle = .overCurrentContext
    modalPresentationCapturesStatusBarAppearance = true
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.6
    view.layer.shadowRadius = 15
    view.layer.shadowOffset = CGSize(width: 0, height: 5)
    view.backgroundColor = backgroundColor
    
    setupViews()
  }
  
  private func setupViews() {
    view.addSubview(colorPickerView)
    colorPickerView.anchor(left: view.leftAnchor, right: view.rightAnchor, top: view.topAnchor)
    
    view.addSubview(colorSliderView)
    colorSliderView.anchor(left: view.leftAnchor, right: view.rightAnchor, top: colorPickerView.bottomAnchor, leftConstant: LocalConstants.padding, rightConstant: LocalConstants.padding, topConstant: LocalConstants.padding, height: 44)
    
    let stackView = UIStackView(arrangedSubviews: [cancelButton, saveButton, selectedColorLabel])
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = LocalConstants.padding
    
    view.addSubview(stackView)
    stackView.anchor(left: view.leftAnchor, right: view.rightAnchor, top: colorSliderView.bottomAnchor, bottom: view.bottomAnchor, leftConstant: LocalConstants.padding, rightConstant: LocalConstants.padding, topConstant: LocalConstants.padding, bottomConstant: LocalConstants.padding, height: 44)
    
    view.addConstraint(
      NSLayoutConstraint(item: selectedColorLabel, attribute: .height, relatedBy: .equal, toItem: saveButton, attribute: .height, multiplier: 1, constant: 0)
    )
    
    if #available(iOS 11.0, *), allowsDragAndDrop {
      let colorDragInteraction = UIDragInteraction(delegate: self)
      selectedColorLabel.addInteraction(colorDragInteraction)
    }
  }
  
  var constraintsHaveBeenSet = false
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if !constraintsHaveBeenSet {
      updateViewFrame()
      
      selectedColorLabel.layer.cornerRadius = selectedColorLabel.frame.height / 2
      
      colorPickerView.currentColor = currentColor
      colorSliderView.currentHue = currentColor.h
      colorPickerView.fadeSlider(.in)
      
      colorChanged(to: currentColor)
      constraintsHaveBeenSet = true
    }
  }
  
  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    updateViewFrame()
  }
  
  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    updateViewFrame()
  }

  // MARK: - Button Targets

  @objc func save(_ sender: UIButton) {
    colorPickerView.fadeSlider(.out)
    
    completion(currentColor)
    dismiss(animated: true, completion: nil)
  }
  
  @objc func cancel(_ sender: UIButton) {
    colorPickerView.fadeSlider(.out)
    
    completion(nil)
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Convenience
  
  private func updateViewFrame() {
    guard let pvc = presentingViewController else { return }
    let targetWidth = pvc.view.frame.width
    let targetHeight = pvc.view.frame.height
    let goldenRatio: CGFloat = 1.618
    
    if targetWidth > targetHeight {
      view.frame.size.height = targetHeight * 0.9
      view.frame.size.width = min(targetHeight * 0.9 * goldenRatio, targetWidth * 0.9)
    } else {
      view.frame.size.width = targetWidth * 0.9
      view.frame.size.height = min(targetWidth * 0.9 * goldenRatio, targetHeight * 0.9)
    }
    
    view.frame.origin.x = targetWidth / 2 - view.frame.width / 2
    view.frame.origin.y = targetHeight / 2 - view.frame.height / 2
    
    view.layoutIfNeeded()
  }
  
}

// MARK: - PDColorPickerDataSource
@available(iOS 9.0, *)
extension PDColorPickerViewController: PDColorPickerGridDataSource {
  func selectedHueForColorPicker() -> CGFloat? {
    return currentColor.h
  }
}

// MARK: - PDColorPickerDelegate
@available(iOS 9.0, *)
extension PDColorPickerViewController: PDColorPickerGridDelegate {
  func colorChanged(to newColor: PDColor) {
    currentColor = newColor
    selectedColorLabel.backgroundColor = currentColor.uiColor
    selectedColorLabel.textColor = newColor.appropriateForegroundColor
    selectedColorLabel.text = showHexString ? hexStringCase.applied(to: newColor.hex) : ""
  }
}

// MARK: - ColorSliderDelegate
@available(iOS 9.0, *)
extension PDColorPickerViewController: PDColorPickerSliderDelegate {
  func hueChanged(to newHue: CGFloat) {
    currentColor.h = newHue
    colorPickerView.selectedHue = newHue
    
    colorChanged(to: currentColor)
  }
}

// MARK: - UIDragInteractionDelegate
@available(iOS 11.0, *)
extension PDColorPickerViewController: UIDragInteractionDelegate {
  @available(iOS 11.0, *)
  public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    let colorItemProvider = NSItemProvider(object: currentColor.uiColor)
    return [UIDragItem(itemProvider: colorItemProvider)]
  }
}
