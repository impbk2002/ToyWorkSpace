//
//  CalendarGridView.swift
//  DemoToycraft (iOS)
//
//  Created by pbk on 2022/05/17.
//

import SwiftUI
import Foundation

struct CalendarGridView<DateView>: View where DateView: View {
    @Environment(\.calendar) private var calendar
    @Environment(\.timeZone) private var timeZone
    @Environment(\.locale) private var locale
    @State private var loadedDates:Set<Date> = []
    @State private var currentPage:Date
    
    let interval:DateInterval
    
    @ViewBuilder
    let content: (Date) -> DateView
    
    init(interval:DateInterval = .init(start: .now, end: .distantFuture), @ViewBuilder content:@escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
        _currentPage = .init(initialValue: interval.start)
    }

    private var titleFormatter:Formatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    private var calendarId:String {
        "\(calendar.identifier)"
    }
    
    var body: some View {
        VStack {
            HStack{
                Button {
                    guard let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentPage),
                          interval.contains(prevMonth)
                    else { return }
                    withAnimation(.easeOut){
                        currentPage = prevMonth
                    }
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .contentShape(Rectangle())
                }.buttonStyle(.plain)

                VStack {
                    Text(currentPage, formatter: titleFormatter)
                    Text(calendarId)
                }
                
                Button {
                    guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentPage),
                          interval.contains(nextMonth)
                    else { return }
                    withAnimation(.easeIn) {
                        currentPage = nextMonth
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .contentShape(Rectangle())
                    
                }.buttonStyle(.plain)
            }
            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack{
                        ForEach(monthList, id: \.self) { month in
                            CalendarMonthView(month: month.date, content: content)
                                .id(month).frame(width: proxy.size.width, height: proxy.size.height)
                        }
                    }
                }
            }
                
        }
    }
    
    var currentDateBinding:Binding<Date> {
        .init {
            currentPage
        } set: { newValue, tran in
            guard interval.contains(newValue) else {
                currentPage = currentPage
                return
            }
            currentPage = newValue
        }

    }


    private var years:[DateCellComponent] {

        var dateArray = [interval.start]
        calendar.enumerateDates(startingAfter: interval.start, matching: .init(month: 1, day: 1, hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { result, _, stop in
            guard let date = result else { return }
            if date < interval.end {
                dateArray.append(date)
            } else {
                stop = true
            }
        }
        return dateArray.map{ DateCellComponent.init(date: $0, component: .year)}
    }

    private func months(for year:Date) -> [DateCellComponent] {
        guard let yearInterval = calendar.dateInterval(of: .year, for: year),
              let firstWeekOfYear = calendar.dateInterval(of: .weekOfYear, for: yearInterval.start),
              let lastWeekOfYear = calendar.dateInterval(of: .weekOfYear, for: yearInterval.end)
        else { return [] }
        var dateArray = [yearInterval.start]
        dateArray.reserveCapacity(12)
        calendar.enumerateDates(startingAfter: firstWeekOfYear.start, matching: .init(day: 1, hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { result, _, stop in
            guard let date = result else { return }
            if date < lastWeekOfYear.end {
                dateArray.append(date)
            } else {
                stop = true
            }
        }
        
        return dateArray.map{ DateCellComponent(date: $0, component: .month)}
    }
    
    private var monthList:[DateCellComponent] {
        Set(years.map(\.date).map(months(for:)).reduce([], +).map(\.date)).sorted().map{ DateCellComponent(date: $0, component: .month)}
    }

}



struct CalendarMonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) private var calendar
    @Environment(\.timeZone) private var timeZone
    @Environment(\.locale) private var locale
    var grid = GridItem()
    let month:Date
    @ViewBuilder
    let content: (Date) -> DateView
    var interval:DateInterval?
    

    
    var body: some View {
        LazyVGrid(columns: Array(repeating: grid, count: calendar.weekdaySymbols.count)) {
            Section {
                ForEach(days(for: month), id: \.self) { dayDate in
                    let day = dayDate.date
                    if calendar.isDate(day, equalTo: month, toGranularity: .month) {
                        content(day).id(dayDate)

                    } else {
                        content(day).hidden()
                    }
                }
            } header: {
                HStack{
                    ForEach(weekDayIndex, id: \.self) { symbol in
                        HStack {
                            Spacer()
                            Text(calendar.weekdaySymbols[symbol])
                            Spacer()
                        }
                    }
                    
                }
            }.animation(.spring(), value: month)

        }

    }
    
    private var weekDayIndex:[Int] {
        guard calendar.firstWeekday > 0 && calendar.weekdaySymbols.count >= calendar.firstWeekday else {
            return calendar.weekdaySymbols.indices.map{ $0 - 1 }
        }
        let prefixToSendBack:[Int]
        let suffixToSendFront:[Int]

        if calendar.firstWeekday > 0 && calendar.firstWeekday <= calendar.weekdaySymbols.count {
            prefixToSendBack = Array(calendar.weekdaySymbols.indices.prefix(calendar.firstWeekday - 1))
            suffixToSendFront = Array(calendar.weekdaySymbols.indices.suffix(calendar.weekdaySymbols.count - prefixToSendBack.count))
        } else {
            prefixToSendBack = []
            suffixToSendFront = calendar.weekdaySymbols.indices.map{ $0 }
        }
       return suffixToSendFront + prefixToSendBack
    }
    
    private func days(for month:Date) -> [DateCellComponent] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        var dateArray = [monthFirstWeek.start]
        dateArray.reserveCapacity(31)
        calendar.enumerateDates(startingAfter: monthFirstWeek.start, matching: .init(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { result, _, stop in
            guard let date = result else { return }
            if date < monthLastWeek.end {
                dateArray.append(date)
            } else {
                stop = true
            }
        }
        return dateArray.map{DateCellComponent(date: $0, component: .day)}
    }
}


struct CalendarGridView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarGridView { date in
            let formatter1:DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd"
                return formatter
            }()

            Text(date, formatter: formatter1)//.foregroundColor(.red)
        }
//        .transformEnvironment(\.calendar) { calendar in
//            calendar = .init(identifier: .iso8601)
//
//            calendar.firstWeekday = 3
//            calendar.locale = .autoupdatingCurrent
////            calenar.firstWeekday = 1
//        }
    }
}

struct DateCellComponent: Hashable {
    var date:Date
    var component:Calendar.Component
}
