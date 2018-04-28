
import Foundation

extension Double {
    func toFormatedString() -> String {
        // 60分を超えるものについては追加で記述が必要
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter.string(from: Date(timeIntervalSinceReferenceDate: self))
    }
}
