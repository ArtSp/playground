import UIKit

//MARK: - Demo 1:

struct WeekDayInterval: Hashable, Comparable {
    
    let start: WeekDay
    let end: WeekDay
    
    static func < (lhs: WeekDayInterval, rhs: WeekDayInterval) -> Bool {
        lhs.start < rhs.start
    }
    
    static func > (lhs: WeekDayInterval, rhs: WeekDayInterval) -> Bool {
        lhs.start > rhs.start
    }
}

enum WeekDay: Int, CaseIterable, Comparable {
    
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    static func < (lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    static func > (lhs: WeekDay, rhs: WeekDay) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
    
    var nextDay: WeekDay? { WeekDay(rawValue: rawValue + 1) }
    var previousDay: WeekDay? { WeekDay(rawValue: rawValue - 1) }
    
    func distanceTo(_ weekDay: WeekDay) -> Int {
        weekDay.rawValue - rawValue
    }
    
    var romanString: String { rawValue.asRomanString() }
}

typealias WorkSchedule = Shop.WorkSchedule
typealias WorkHours = Shop.WorkHours

struct Shop: Codable {
    let name: String
    let adress: String
    let workSchedule: WorkSchedule
    
    struct WorkSchedule: Codable {
        let monday: WorkHours?
        let tuesday: WorkHours?
        let wednesday: WorkHours?
        let thursday: WorkHours?
        let friday: WorkHours?
        let saturay: WorkHours?
        let sunday: WorkHours?
    }
    
    struct WorkHours: Codable, Equatable, Hashable {
        let from: String
        let to: String
    }
}

extension Shop.WorkSchedule {
    
    func toList(removeDuplicates: Bool = false) -> [WorkHours?] {
        let items = [monday,tuesday,wednesday,thursday,friday,saturay,sunday]
        if removeDuplicates {
            return Array(Set(items))
        } else {
            return items
        }
    }
    
    func toDictionary() -> [WeekDay:WorkHours?] {
        
        var map = [WeekDay:WorkHours?]()
        
        map[.monday] = monday
        map[.tuesday] = tuesday
        map[.wednesday] = wednesday
        map[.thursday] = thursday
        map[.friday] = friday
        map[.saturday] = saturay
        map[.sunday] = sunday
        
        return map
    }
}

///Task 1
///
///We have theoretical shop object with working hours for each day. Demo object structure is provided below, image if this is the data we received from BE and we have to work with it. “WorkHours” is optional because if it is that means shop is not working that day, otherwise we would have some formatted date, like “10:00", “16:30”, etc...
///Your main task is to display shops working hours sorted by weekdays and time.
///If several days in succession have exact same time, those days should be grouped together (Monday-Wednesday in the example below).
///If shop is closed then instead of time show “Closed”
func demo1(){

    func showWorkHours(for shop: Shop){
        
        let schedulesMap = shop.workSchedule.toDictionary()
        var sortedSchedules = [WeekDayInterval:WorkHours?]()
        
        func getDayRanges(for hours: WorkHours?) -> [WeekDayInterval]{
            
            var intervals = [WeekDayInterval]()
            
            var keys = schedulesMap.filter { _, workHours in
                workHours == hours
            }.keys.sorted(by: < )
            
            while keys.count > 0 {
                let start = keys.first!
                var end = start
                for key in keys {
                    switch end.distanceTo(key) {
                    case 1:
                        end = key
                    case let (i) where i > 1:
                        break
                    default:
                        continue
                    }
                }
                
                keys.removeFirst(start.distanceTo(end) + 1)
                intervals.append(WeekDayInterval(start: start, end: end))
            }
            
            return intervals
            
        }
        
        func printSchedule(_ schedule: WeekDayInterval){
            
            var scheduleRangeString: String {
                schedule.start.distanceTo(schedule.end) < 1 ? schedule.start.romanString :
                    String(format: "%@-%@",arguments: [schedule.start.romanString,schedule.end.romanString] )
            }
            
            var workHoursRangeString: String {
            
                guard let hours = sortedSchedules[schedule]! else { return "Closed" }
                return String(format: "%@-%@",arguments: [hours.from,hours.to] )
            }
            
            print("\(scheduleRangeString)\t\(workHoursRangeString)")
        }
        
        for workHours in shop.workSchedule.toList(removeDuplicates: true){
            getDayRanges(for: workHours).forEach{ sortedSchedules[$0] = workHours }
        }

        print("\(shop.name) (\(shop.adress))\n")
        sortedSchedules.keys.sorted(by: <).forEach{ printSchedule($0) }
        print("\n---***---\n")
    }
    
    do {
        let filePath = Bundle.main.path(forResource: "shops", ofType: "json")!
        let fileData = FileManager.default.contents(atPath: filePath)!

        let shops = try JSONDecoder().decode([Shop].self, from: fileData)
        
        shops.forEach{ showWorkHours(for: $0) }
        
    } catch {
        print(error)
    }
}
//MARK: - Demo 2:

func demo2(){
    let texts = ["two","twelve","twenty"]
    
    let commonPrefix = texts.reduce(texts.first!) { result, nextText in
        result.commonPrefix(with: nextText)
    }
    
    print("\"\(commonPrefix)\" is a common prefix for: \(texts)")
    
}
//MARK: - Demo 3:

//MARK: - Demo 4:

//MARK: - Demo 5:

//MARK: - Demo 6:

enum RomanNumber: String, CaseIterable {
    case M, CM, D, CD, C, XC, L, XL, X, IX, V, IV, I
    
    var intValue: Int {
        switch self {
        case .M : return 1000
        case .CM: return 900
        case .D : return 500
        case .CD: return 400
        case .C : return 100
        case .XC: return 90
        case .L : return 50
        case .XL: return 40
        case .X : return 10
        case .IX: return 9
        case .V : return 5
        case .IV: return 4
        case .I : return 1
        }
    }
}

extension Int {
    
    func asRomanString() -> String {
        
        assert(self > 0, "Roman number must be > 0")
        
        var value = self
        var roman = ""
        
        for romanNumber in RomanNumber.allCases {
            while (value >= romanNumber.intValue) {
                value -= romanNumber.intValue
                roman += romanNumber.rawValue
            }
        }
        
        return roman
    }
}

///Task 6
///
///Integer to Roman number converter. Write a function that takes an Int as parameter and returns Roman number.
func demo6(){
    let numbers = [1, 5, 7, 16, 32, 88, 121, 1000, 2020]
    numbers.forEach{ print("\($0) : \($0.asRomanString())") }
}

//MARK: - Demo 7:

//MARK: - Demo 8:

//MARK: - MAIN

let tasks: [() -> Void] = [demo1,demo2,demo6]

tasks[1]()
