import Foundation
import UIKit

class MensagemViewController: UIViewController {
    
    @IBOutlet weak var botaoHome: UIButton!
    @IBOutlet weak var mensagemLabel: UILabel!
    
    // Variáveis
    var mensagem: String?
    var precoTotal = Double()
    var carteira: Carteira?
    
    // CambioViewController
    var acaoBotaoMensagem: String = ""
    var campoQuantidadeMensagem: Int = 0
    var siglaMoedaMensagem: String = ""
    var moedaSelecionadaMensagem: Currency?
    var precoTransacaoMensagem: String = ""
    var nomeMoedaMensagem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        estilizacaoBotaoHome() // Bordas
        
        guard let nomeMoedaMensagem = moedaSelecionadaMensagem?.name else {return}
        
        mensagemLabel.text = "Parabéns! Você acabou de \(acaoBotaoMensagem) \(campoQuantidadeMensagem) \(siglaMoedaMensagem) - \(nomeMoedaMensagem), totalizando \(precoTransacaoMensagem)"
    }
    
    // MARK: - Botão Home
    @IBAction func botaoHomePressionado(_ sender: Any) {
        guard let storyboard = storyboard,
              let cambioHomeController = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController,
              let navigationController = navigationController else { return }
        
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - Estilização
    func estilizacaoBotaoHome() {
        botaoHome.layer.cornerRadius = 20
    }
}
