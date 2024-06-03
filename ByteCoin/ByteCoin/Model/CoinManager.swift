

import Foundation
import UIKit

protocol CoinDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    var delegate: UIPickerViewDelegate?
    var coinDelegate: CoinDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0E2BA705-EA37-4184-8C92-7F914A76231D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let reqURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: reqURL)
        
    }
    
    // method used for perform a request to the API for the crypto information
    func performRequest(with urlString: String) {
        
        // 1. Create a URL for the city that user input.
        if let url = URL(string: urlString) {
            
            // 2. Create a URL Session, object for the request (like a browser who's requesting our search)
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task, initiate an object (like a browser) and give it a task, in this case the task will be fetch a data ("dataTask") with url.
            let task = session.dataTask(with: url) { data, response, error in
                // when the data is already fetched, it will check whether there is error or not
                if error != nil {
                    coinDelegate?.didFailWithError(error!)
                    return
                }
                
                // if there is no error and data can be fetched (not nil), data will be encoded into string.
                if let safeData = data {
                    if let coin = self.parseJSON(coinData: safeData) {
                        coinDelegate?.didUpdatePrice(self, coin: coin)
                    }
                }
                
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let time = decodedData.time
            let crypto = decodedData.asset_id_base
            let currency = decodedData.asset_id_quote
            let price = decodedData.rate
            
            let coin = CoinModel(time: time, crypto: crypto, currency: currency, price: price)
            return coin
            
        }
        
        catch {
            coinDelegate?.didFailWithError(error)
            return nil
        }
    }
    
    
}
