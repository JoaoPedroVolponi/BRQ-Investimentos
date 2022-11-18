import Foundation
import UIKit

class Request: UITableViewController {
    
    var moedas = [Currency]()
    //  let URLApi = "https://api.hgbrasil.com/finance?array_limit=1&fields=only_results,currencies&key=57edaf28"
    
    
    //MARK: - API (Requisição)
    //57edaf28 - chave API
    func requisicaoAPI() {
        guard let url = URL(string: "https://api.hgbrasil.com/finance?array_limit=1&fields=only_results,currencies&key=57edaf28" ) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                guard let error = error else { return }
                print(error)
                return
            }
            if let safeData = data {
                self.decoderJSON(safeData)
            }
        }
        task.resume()
    }
    
    // JSON Decoder
    func decoderJSON(_ financeData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Results.self, from: financeData)
            moedas = [
                decodedData.currencies.USD,
                decodedData.currencies.EUR,
                decodedData.currencies.ARS,
                decodedData.currencies.AUD,
                decodedData.currencies.BTC,
                decodedData.currencies.CAD,
                decodedData.currencies.CNY,
                decodedData.currencies.GBP,
                decodedData.currencies.JPY
            ]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
            return
        }
    }  
}
