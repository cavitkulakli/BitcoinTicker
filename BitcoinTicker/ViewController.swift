//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Cavit KULAKLI on 29.11.2018.
//  Copyright © 2018 Cavit KULAKLI. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class ViewController: UIViewController{
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var selectedSymbol : String = "$"
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getBitcoinPriceForCurrency(url : "\(baseURL)AUD")
    }

   
    func getBitcoinPriceForCurrency(url : String) {
        self.bitcoinPriceLabel.text = "Getting price..."
        Alamofire.request(url, method: .get)
         .responseJSON { response in
            if response.result.isSuccess {
                print("Succesly getting bitcoin price for selected currency")
                let bitcoinPriceJSON : JSON = JSON(response.result.value)
                
                self.updateBitcoinPrice(json : bitcoinPriceJSON)
            } else {
                print("Error: \(response.result.error)")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
            
        }
    }
    
    func updateBitcoinPrice(json : JSON){
        if let bitcoinPrice = json["averages"]["day"].double{
            bitcoinPriceLabel.text = "\(selectedSymbol) \(bitcoinPrice)";
        }else{
            bitcoinPriceLabel.text = "Bitcoin Price Unavailable"
        }
    }
    

    




}

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        
        selectedSymbol = currencySymbolArray[row]
        
        getBitcoinPriceForCurrency(url: finalURL)
    }
}
