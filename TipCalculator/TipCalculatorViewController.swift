/// Copyright (c) 1 Reiwa Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class TipCalculatorViewController: UIViewController {
  let defaultBill = 0.0
  let defaultTipPercent = 0.18

  var bill: Double
  var tipPercent: Double

  @IBOutlet var billTextField: UITextField!
  @IBOutlet var tipPercentTextField: UITextField!
  @IBOutlet var tipTextField: UITextField!
  @IBOutlet var totalTextField: UITextField!

  required init?(coder aDecoder: NSCoder) {
    self.bill = defaultBill
    self.tipPercent = defaultTipPercent
    super.init(coder: aDecoder)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.bill = defaultBill
    self.tipPercent = defaultTipPercent
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
}

extension TipCalculatorViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    // Only allow one decimal separator in bill input
    let decimalSeparator = Locale.current.decimalSeparator ?? "."
    let text = textField.text ?? ""
    if text.contains(decimalSeparator), string == decimalSeparator {
      return false
    }
    return true
  }

  @IBAction func textFieldDidChange(_ sender: UITextField) {
    let input = sender.text ?? ""
    switch sender {
    case billTextField:
      bill = billFrom(input)
    case tipPercentTextField:
      tipPercent = tipPercentFrom(input)
    default:
      break
    }
    let tipTotal = calculateTip(bill: bill, tipPercent: tipPercent)
    tipTextField.text = String(tipTotal)
    let billTotal = calculateBillTotal(bill: bill, tip: tipTotal)
    totalTextField.text = String(billTotal)
  }

  private func billFrom(_ input: String) -> Double {
    return Double(input) ?? defaultBill
  }

  private func tipPercentFrom(_ input: String)-> Double {
    guard let value = Double(input) else {
      return defaultTipPercent
    }
    return value / 100.0
  }

  private func calculateTip(bill: Double, tipPercent: Double) -> Double {
    return (bill * tipPercent).roundedToTwoDecimals()
  }

  private func calculateBillTotal(bill: Double, tip: Double) -> Double {
    return (bill + tip).roundedToTwoDecimals()
  }
}
