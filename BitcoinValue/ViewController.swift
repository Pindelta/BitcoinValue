//
//  ViewController.swift
//  BitcoinValue
//
//  Created by Osmani Perez on 10/13/19.
//  Copyright © 2019 Osmani Perez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let pickerViewData = ["USD", "EUR", "JPY", "GBP", "CAD", "AUD"]
    let currencySymData = ["$", "€", "¥", "£", "$", "$"]
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var finalURL = ""
    var currencySym = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + pickerViewData[row]
        getBitcoinData(url: finalURL)
        currencySym = currencySymData[row]
    }
    
    func getBitcoinData(url: String){
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess {
                let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            }
            else {
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateBitcoinData(json: JSON) {
        if let priceResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySym)\(priceResult)"
        }
        else {
            bitcoinPriceLabel.text = "Price unavailable"
        }
    }
}

