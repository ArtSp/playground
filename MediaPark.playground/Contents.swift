
import Foundation

//MARK: - Demo 1:
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

//MARK: - Demo 2:
func demo2(){
    
    func printCommonPrefix(for texts: [String]){
        let commonPrefix = texts.reduce(texts.first!) { result, nextText in
            result.commonPrefix(with: nextText)
        }
        print("\"\(commonPrefix)\" is a common prefix for: \(texts)")
    }
    
    printCommonPrefix(for: ["market", "maxima", "mama"])
    printCommonPrefix(for: ["sale", "safe", "sun"])
}

//MARK: - Demo 3:
func demo3(){
    
    func getLastWordCharacterCount(from text: String) -> Int {
        text.split(separator: " ").last?.count ?? 0
    }

    let text = "Today is sunny"
    let count = getLastWordCharacterCount(from: text)

    print("In \"\(text)\" last word character count is \(count)")
}

//MARK: - Demo 4:
func demo4(){
    
    var items = [1,1,3,4,5,5]
    
    print("Before removing duplicates : \(items.sorted())")
    items.removeDuplicates()
    print("After removing duplicates : \(items.sorted())")
    
}

extension Array where Self.Element: Equatable {
    
    // I would implement like Array(Set(<sequence>)) but Set cannot be used in our case.
    mutating func removeDuplicates() {
        var copy = self
        var uniqueElements = [Element]()
        
        while copy.count > 0 {
            let uniqueElement = copy.first!
            copy.removeAll(where: { $0 == uniqueElement})
            uniqueElements.append(uniqueElement)
        }
        
        self = uniqueElements
    }
}

//MARK: - Demo 5:
func demo5(){
    let excelRows = ["A","B","C","Z","AA","AB","ABC","BAB"].compactMap{ ExcelNumber($0) }
    excelRows.forEach{ print("\($0.value) -> \($0.toInt())") }
}

struct ExcelNumber {
    
    static let supportedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let radix = supportedCharacters.count
    
    let value: String
    
    func toInt() -> Int {
        var result = 0
        for item in value.reversed().enumerated() {
            
            let supported = Self.supportedCharacters
            let charIndex = supported.firstIndex(of: item.element)!
            let charValue = supported.distance(from: supported.startIndex, to: charIndex) + 1
            
            result += Int(pow(Double(Self.radix), Double(item.offset))) * charValue
       
        }
        return result
    }
    
    init?(_ value: String) {
        guard value.allSatisfy({ Self.supportedCharacters.contains($0) }) else { return nil }
        self.value = value
    }
}

//MARK: - Demo 6:
func demo6(){
    let numbers = [1, 5, 7, 16, 32, 88, 121, 1000, 2020]
    numbers.forEach{ print("\($0) : \($0.asRomanString())") }
}

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

//MARK: - Demo 7:
func demo7(){
    
    func printDistance(from: String, to: String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let fromDate = formatter.date(from: from),
              let toDate = formatter.date(from: to)
            else {
            fatalError("Wrong date format")
        }
        
        let distanceInMinutes = abs(fromDate.distance(to: toDate)) / 60
        print("Distance between \(from) and \(to) == \(distanceInMinutes) minutes")
    }
    
    let firstTest  = (from:"13:45",to: "12:45")
    let secondTest = (from:"13:45",to: "14:00")
    
    printDistance(from: firstTest.from, to: firstTest.to)
    print("---")
    printDistance(from: secondTest.from, to: secondTest.to)
    
}

//MARK: - Demo 8:
func demo8(){
    
    func proceedInvestment(stock: [Int]) -> Int {
        
        var earned = 0
        var purchasedStock: Int?
        
        func sell(for sellPrice: Int){
            guard let purchasePrice = purchasedStock else { fatalError("Nothing to sell") }
            let transactionEarn = sellPrice - purchasePrice
            earned += transactionEarn
            purchasedStock = nil
            print("Purchased for:\(purchasePrice), Sold for:\(sellPrice), Earned: \(transactionEarn)")
        }
        
        func buy(_ investment: Int){
            guard purchasedStock == nil else { fatalError("Should sell before buy") }
            purchasedStock = investment
        }
        
        var stock = stock
        while !stock.isEmpty {
            
            let investment = stock.remove(at: 0)
            
            var shouldInvest: Bool {
                guard stock.count > 0 else {return false}
                return investment < stock[0]
            }
            
            if let _ = purchasedStock {
                if !shouldInvest { sell(for: investment) }
            } else {
                if shouldInvest { buy(investment) }
            }
            
        }
        
        return earned
    }
    
    let testCase1 = [1, 4, 5, 6, 2, 8]
    let testCase2 = [6, 3, 3, 6, 2, 9, 1]
    
    print("Stock: \(testCase1)")
    print("Earned Total: \(proceedInvestment(stock: testCase1))")
    print("---")
    print("Stock: \(testCase2)")
    print("Earned Total: \(proceedInvestment(stock: testCase2))")
}

//MARK: - Main
let tasks: [() -> Void] = [demo1,demo2,demo3,demo4,demo5,demo6,demo7,demo8]

//tasks.enumerated().forEach { item in
//    print( "\n\n\nCase \(item.offset + 1) ------------------------------\n\n\n")
//    item.element()
//}

tasks[4]()

