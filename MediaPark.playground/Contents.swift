import UIKit

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
    
    struct WorkHours: Codable {
        let from: String
        let to: String
    }
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

//enum WeekDay: Int, CaseIterable {
//    case monday, tuesday, wednesday, thursday, friday, saturay, sunday
//}

//MARK: - Demo 1:

func demo1(){

    func showWorkHours(for shop: Shop){
        let displayText = String()
        
        print("\(shop.name) (\(shop.adress))")
        print(displayText)
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

//MARK: - Demo 3:

//MARK: - Demo 4:

//MARK: - Demo 5:

//MARK: - Demo 6:

///Task 6
///
///Integer to Roman number converter. Write a function that takes an Int as parameter and returns Roman number.
func demo6(){
    let numbers = [1, 5, 16, 32, 88, 121, 1000, 2020]
    numbers.forEach{ print("\($0) : \($0.asRomanString())") }
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

//MARK: - Demo 8:

//MARK: - MAIN

//demo1()
demo6()
