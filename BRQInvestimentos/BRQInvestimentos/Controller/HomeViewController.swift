import Foundation
import UIKit

class HomeViewController: UITableViewController {
    
    let URLApi = "https://api.hgbrasil.com/finance?array_limit=1&fields=only_results,currencies&key=57edaf28"
    let carteira = Carteira()
    var moedas = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requisicaoAPI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return moedas.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let espacoEntreCelulas: CGFloat = 24
        
        return espacoEntreCelulas
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cabecalho = UIView()
        cabecalho.backgroundColor = UIColor.black
        
        return cabecalho
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celulaView = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath) as? CelulaHome else { fatalError() }
        
        adicionandoLabels(celulaView, for: indexPath)
        celulaView.celulaView.valoresCelula()
        
        return celulaView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard,
              let navigationController = navigationController else {return}
        
        if let cambioViewController = storyboard.instantiateViewController(withIdentifier: "CambioViewController") as? CambioViewController {
            cambioViewController.moedaSelecionada = moedas[indexPath.section] //Moeda Selecionada
            cambioViewController.carteira = carteira // Carteira
            
            //Celula
            guard let celula = tableView.cellForRow(at: indexPath) as? CelulaHome,
                  let siglaMoeda = celula.siglaLabel.text else {return}
            cambioViewController.siglaMoeda = siglaMoeda
            
            navigationController.pushViewController(cambioViewController, animated: true)
        }
    }
    
    //MARK: - Criação da celula da tabela
    
    func adicionandoLabels(_ celula: CelulaHome, for indexPath: IndexPath) {
        let moeda = moedas[indexPath.section]
        switch moeda.name {
        case "Dollar":
            celula.siglaLabel.text = "USD"
        case "Euro":
            celula.siglaLabel.text = "EUR"
        case "Pound Sterling":
            celula.siglaLabel.text = "GBP"
        case "Argentine Peso":
            celula.siglaLabel.text = "ARS"
        case "Canadian Dollar":
            celula.siglaLabel.text = "CAD"
        case "Australian Dollar":
            celula.siglaLabel.text = "AUD"
        case "Japanese Yen":
            celula.siglaLabel.text = "JPY"
        case "Renminbi":
            celula.siglaLabel.text = "CNY"
        case "Bitcoin":
            celula.siglaLabel.text = "BTC"
        default:
            break
        }
        
        celula.porcentagemLabel.text = moeda.variationString
        celula.porcentagemLabel.corLabel(variacaoPorcentagem: moeda.variation)
    }
}
