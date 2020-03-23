
import Foundation

struct CoinModel {
    let rate: Double
    
    var rateString: String{
        return String(format: "%.2f", rate)
    }
}
