//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(_ error: Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D731E421-E4DE-4A71-81EA-A0184B1F4114"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)"
        performRequest(with:urlString)
    }
    
    func performRequest(with urlString: String){
       if let url = URL(string: urlString){
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
            let session  = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest, completionHandler:handle(data: response: error:))
            task.resume()
           
       }
   }
       
    func handle(data:Data?, response:URLResponse?, error:Error?){
       if error != nil{
           self.delegate?.didFailWithError(error!)
           return
       }
       
       if let safeData = data{
           if let rate = self.parseJSON(safeData){
            let coinModel = CoinModel(rate: rate)
             self.delegate?.didUpdateCoin(self, coinModel: coinModel)
           }
       }
   }

   func parseJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
        }catch{
            print(error)
           self.delegate?.didFailWithError(error)
           return nil
       }
   }
}
