//
//  NumberFormatterExt.swift
//  Poovali
//
//  Copyright © 2017 Joseph Muthu. All rights reserved.
//

import Foundation
import Charts

class NumberFormatterExt : NSObject, IValueFormatter {
    let numFormatter: NumberFormatter
    
    override init() {
        numFormatter = NumberFormatter()
        numFormatter.numberStyle = NumberFormatter.Style.none
    }

    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return	numFormatter.string(from: NSNumber(floatLiteral: value))!
    }

}
