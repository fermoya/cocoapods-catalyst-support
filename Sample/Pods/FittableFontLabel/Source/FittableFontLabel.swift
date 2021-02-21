//
//  FittableFontLabel.swift
//
// Copyright (c) 2016 Tom Baranes (https://github.com/tbaranes)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

// An UILabel subclass allowing you to automatize the process of adjusting the font size.
@IBDesignable
open class FittableFontLabel: UILabel {

    // MARK: Properties

    /// If true, the font size will be adjusted each time that the text or the frame change.
    @IBInspectable public var autoAdjustFontSize: Bool = true

    /// The biggest font size to use during drawing. The default value is the current font size
    @IBInspectable public var maxFontSize: CGFloat = CGFloat.nan

    /// The scale factor that determines the smallest font size to use during drawing. The default value is 0.1
    @IBInspectable public var minFontScale: CGFloat = CGFloat.nan

    /// UIEdgeInset
    @IBInspectable public var leftInset: CGFloat = 0
    @IBInspectable public var rightInset: CGFloat = 0
    @IBInspectable public var topInset: CGFloat = 0
    @IBInspectable public var bottomInset: CGFloat = 0

    // MARK: Properties override

    open override var text: String? {
        didSet {
            adjustFontSize()
        }
    }

    open override var frame: CGRect {
        didSet {
            adjustFontSize()
        }
    }

    // MARK: Private

    var isUpdatingFromIB = false

    // MARK: Life cycle

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        isUpdatingFromIB = autoAdjustFontSize
        adjustFontSize()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        isUpdatingFromIB = autoAdjustFontSize
        adjustFontSize()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if !isUpdatingFromIB {
            adjustFontSize()
        }
        isUpdatingFromIB = false
    }

    // MARK: Insets

    open override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

}

// MARK: Helpers

extension FittableFontLabel {

    private func adjustFontSize() {
        if autoAdjustFontSize {
            fontSizeToFit(maxFontSize: maxFontSize, minFontScale: minFontScale)
        }
    }
}
