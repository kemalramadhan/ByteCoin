

import Foundation

struct CoinModel {
    let time: String
    let crypto: String
    let currency: String
    let price: Double
    
    var stringPrice: String {
        return NSString(format: "%.2f", price) as String
    }
    
}
