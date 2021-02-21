//
//  PDColor+NamedColors.swift
//  PDColorPicker
//
//  Created by Paolo Di Lorenzo on 8/28/17.
//  Copyright © 2017 Paolo Di Lorenzo. All rights reserved.
//

public extension PDColor {
  /// Convenient representation of the red `PDColor`.
  ///
  /// Its values are `(1.0, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var red: PDColor {
    return PDColor(h: 1, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the orange `PDColor`.
  ///
  /// Its values are `(30/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var orange: PDColor {
    return PDColor(h: 30/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the yellow `PDColor`.
  ///
  /// Its values are `(60/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var yellow: PDColor {
    return PDColor(h: 60/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the yellow-green `PDColor`.
  ///
  /// Its values are `(90/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var yellowGreen: PDColor {
    return PDColor(h: 90/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the green `PDColor`.
  ///
  /// Its values are `(120/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var green: PDColor {
    return PDColor(h: 120/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the cyan `PDColor`.
  ///
  /// Its values are `(180/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var cyan: PDColor {
    return PDColor(h: 180/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the azure `PDColor`.
  ///
  /// Its values are `(210/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var azure: PDColor {
    return PDColor(h: 210/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the blue `PDColor`.
  ///
  /// Its values are `(240/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var blue: PDColor {
    return PDColor(h: 240/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the purple `PDColor`.
  ///
  /// Its values are `(270/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var purple: PDColor {
    return PDColor(h: 270/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the magenta `PDColor`.
  ///
  /// Its values are `(300/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var magenta: PDColor {
    return PDColor(h: 300/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the pink `PDColor`.
  ///
  /// Its values are `(330/360, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var pink: PDColor {
    return PDColor(h: 330/360, s: 1, b: 1, a: 1)
  }
  
  /// Convenient representation of the white `PDColor`.
  ///
  /// Its values are `(0.0, 0.0, 1.0, 1.0)` in the HSBA representation.
  static var white: PDColor {
    return PDColor(h: 0, s: 0, b: 1, a: 1)
  }
  
  /// Convenient representation of the black `PDColor`.
  ///
  /// Its values are `(0.0, 1.0, 1.0, 1.0)` in the HSBA representation.
  static var black: PDColor {
    return PDColor(h: 0, s: 0, b: 0, a: 1)
  }
}
