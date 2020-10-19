//
//  Double+Extension.swift
//  MediaSample
//
//  Created by Tolga Taner on 18.10.2020.
//

import Foundation


extension Double {
    var asCurreny: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return ("$" + (numberFormatter.string(from: self as NSNumber) ?? ""))
    }
}


