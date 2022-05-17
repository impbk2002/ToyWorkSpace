//
//  CalendarGridConfiguration.swift
//  
//
//  Created by pbk on 2022/05/17.
//

import Foundation
import SwiftUI

public struct CalendarGridConfiguration {
    var grid = GridItem()
    var weekSymbol = SymbolLength.basic
    var monthSymbol = SymbolLength.basic
    
    enum SymbolLength:Hashable {
        case basic
        case short
        case veryShort
    }
    
    

}

extension CalendarGridConfiguration.SymbolLength {
    
    var weekSymbolPath:KeyPath<Calendar,[String]> {
        switch self {
        case .basic:
            return \.standaloneWeekdaySymbols
        case .short:
            return \.shortStandaloneWeekdaySymbols
        case .veryShort:
            return \.veryShortStandaloneWeekdaySymbols
        }
    }
    
    var monthSymbolPath:KeyPath<Calendar,[String]> {
        switch self {
        case .basic:
            return \.standaloneMonthSymbols
        case .short:
            return \.shortStandaloneMonthSymbols
        case .veryShort:
            return \.veryShortStandaloneMonthSymbols
        }
    }
    
}
