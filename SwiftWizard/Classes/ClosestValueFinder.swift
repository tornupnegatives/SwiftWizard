// ClosestValueFinder queries the (Coding)Table and return the index of the element therein most closely related to actual
    
import Foundation

final class ClosestValueFinder {
    static func indexFor(actual: Double, table: [Double], size: Int) -> Int {
        if actual < table[0] {
            return 0
        }
        
        for i in 1..<size {
            if table[i] > actual {
                let previous: Double = table[i - 1]
                if (table[i] - actual) < (actual - previous) {
                    return i
                } else {
                    return i - 1
                }
            }
        }
        return size - 1
    }
}
