//
//  PDColor.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/8/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

import UIKit

/// Provides a convenient wrapper for colors to be represented as
///   a set of hue, saturation, brightness, and alpha values.
///
/// Convenience methods for accessing the `UIColor`, RGB, and hexadecimal
///   representations are also provided.
public struct PDColor {
  
  /// Hue -- values are constrained to be between 0.0 and 1.0.
  public var h: CGFloat
  /// Saturation -- values are constrained to be between 0.0 and 1.0.
  public var s: CGFloat
  /// Brightness -- values are constrained to be between 0.0 and 1.0.
  public var b: CGFloat
  /// Alpha -- values are constrained to be between 0.0 and 1.0.
  public var a: CGFloat
  
  /// The `UIColor` representation of the `PDColor`.
  public var uiColor: UIColor {
    return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
  }
  
  /// The RGB representation of the `PDColor`.
  public var rgba: (r: CGFloat, b: CGFloat, g: CGFloat, a: CGFloat) {
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0
    
    uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return (r: r, b: b, g: g, a: a)
  }
  
  /**
   Initializes a `PDColor` from a `UIColor`.
   
   - parameter color: The `UIColor` to be used to initialize the `PDColor`.
   */
  public init(color: UIColor) {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    
    self.h = h
    self.s = s
    self.b = b
    self.a = a
  }
  
  /**
   Initializes a `PDColor` from a `String`.
   
   - parameter string: The `String` to be used to initialize the `PDColor`.
   The string should be of the form `"<hue>,<saturation>,<brightness>,<alpha>"`,
   where the values are between 0.0 and 1.0 (and the `< >` are omitted).
   The `<alpha>` value is optional and defaults to 1.0.
   
   Example:
   
   ```
   let color = PDColor(string: "0.5,0.75,0.33,1.0")
   
   // alpha defaults to 1.0
   let color = PDColor(string: "0.5,0.75,0.33")
   ```
   */
  public init?(string: String) {
    let components = string.components(separatedBy: ",")
    
    if components.count >= 3 {
      if let h = Double(components[0]), let s = Double(components[1]), let b = Double(components[2]) {
        self.h = CGFloat(h)
        self.s = CGFloat(s)
        self.b = CGFloat(b)
      } else {
        return nil
      }
      
      if components.count == 4, let a = Double(components[3]) {
        self.a = CGFloat(a)
      } else {
        a = 1
      }
    } else {
      return nil
    }
  }
  
  /**
   Initializes a `PDColor` from hue, saturation, brightness, and alpha values directly.
   All four values are constrained to be between 0.0 and 1.0.
   
   - parameters:
   - h: Hue
   - s: Saturation
   - b: Brightness
   - a: Alpha -- the default value is 1.0
   */
  public init(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat = 1) {
    self.h = h
    self.s = s
    self.b = b
    self.a = a
  }
  
  // MARK: - Utilities
  
  /// The hexadecimal representation of the `PDColor`.
  ///
  /// Examples:
  ///   - `#000000` : black
  ///   - `#ff0000` : red
  ///   - `#00ff00` : green
  ///   - `#0000ff` : blue
  ///   - `#ffffff` : white
  public var hex: String {
    let rgba = self.rgba
    
    let rr = (Int)(rgba.r * 255) << 16
    let gg = (Int)(rgba.g * 255) << 8
    let bb = (Int)(rgba.b * 255) << 0
    
    let rgb = rr | gg | bb
    
    return String(format: "#%06x", rgb)
  }
  
  /**
   A color that is appropriate to display as the foreground
   assuming that the `PDColor` is the background color. This convenience property
   returns a color that is visible when superimposed on the current value of the
   `PDColor`.
   
   The returned value is white if `PDColor` is dark, and black if `PDColor` is light.
   This property is computed based on the "luma" of the associated red, green, and blue values.
   
   See [https://en.wikipedia.org/wiki/HSL_and_HSV#Lightness](https://en.wikipedia.org/wiki/HSL_and_HSV#Lightness)
   for more information.
   */
  public var appropriateForegroundColor: UIColor {
    let rgba = self.rgba
    let level = 1 - (0.299 * rgba.r + 0.587 * rgba.g + 0.114 * rgba.b)
    
    return (level < 0.5) ? .black : .white
  }
  
}

// MARK: - CustomStringConveritble
extension PDColor: CustomStringConvertible {
  public var description: String {
    return "\(h),\(s),\(b),\(a)"
  }
}
