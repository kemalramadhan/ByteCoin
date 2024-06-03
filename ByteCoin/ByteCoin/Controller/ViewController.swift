

import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.coinDelegate = self
        
    }
    
}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinDelegate
extension ViewController: CoinDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = coin.stringPrice
            self.currencyLabel.text = coin.currency
            print(coin.stringPrice)
            print(coin.currency)
        }
        
    }
    
    func didFailWithError(_ error: any Error) {
        print(error)
    }
}
