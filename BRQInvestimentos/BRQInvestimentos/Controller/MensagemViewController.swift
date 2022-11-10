import Foundation
import UIKit

class MensagemViewController: UIViewController {
    
    @IBOutlet weak var botaoHome: UIButton!
    @IBOutlet weak var mensagemLabel: UILabel!
    
    // Variáveis
    var mensagem: String?
    var precoTotal = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mensagem = mensagem else {return}
        mensagemLabel.text = mensagem
        
        estilizacaoBotao() // botaoHome
        
    }
    
    func estilizacaoBotao() {
        botaoHome.layer.cornerRadius = 20
    }
    
    // Botão Home
    @IBAction func botaoHomePressionado(_ sender: Any) {
        guard let storyboard = storyboard,
              let cambioHomeController = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController,
              let navigationController = navigationController else { return }
        
        navigationController.popToRootViewController(animated: true)
    }
}
