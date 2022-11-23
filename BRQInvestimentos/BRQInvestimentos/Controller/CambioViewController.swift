import Foundation
import UIKit

class CambioViewController: UIViewController {
    
    @IBOutlet weak var viewCambio: UIView!
    
    @IBOutlet weak var siglaNomeLabel: UILabel!
    @IBOutlet weak var variacaoLabel: UILabel!
    @IBOutlet weak var precoCompraLabel: UILabel!
    @IBOutlet weak var precoVendaLabel: UILabel!
    
    @IBOutlet weak var saldoDisponivelLabel: UILabel!
    @IBOutlet weak var moedaCaixaLabel: UILabel!
    
    @IBOutlet weak var botaoVender: UIButton!
    @IBOutlet weak var botaoComprar: UIButton!
    
    @IBOutlet weak var quantidadeTextField: UITextField!
    
    var moedaSelecionada: Currency?
    var siglaMoeda = String()
    var currencyISO = String()
    var carteira: Carteira?
    var totalTransacao = Double()
    var valorDeVenda = Double()
    var valorDeCompra = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantidadeTextField.delegate = self
        
        alteracaoLabel()
        
        // Customização
        BordasView()
        BordasBotoes()
        BordasQuantidade()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    // MARK: - Alterando Labels
    func alteracaoLabel() {
        guard let moeda = moedaSelecionada,
              let carteira = carteira,
              let quantidadeDeMoedas = carteira.carteiraPessoal[siglaMoeda]  else {return}
        
        siglaNomeLabel.text = "\(siglaMoeda) - \(moeda.name)"
        
        variacaoLabel.text = moeda.variationString
        variacaoLabel.corLabel(variacaoPorcentagem: moeda.variation)  // Cor variação
        
        precoCompraLabel.text = ("Compra: " + moeda.compraString)
        
        precoVendaLabel.text = ("Venda: " + moeda.vendaString)
        
        saldoDisponivelLabel.text = ("Saldo disponível: \(carteira.saldoDisponivel)")
        
        moedaCaixaLabel.text = ("\(quantidadeDeMoedas) \(siglaMoeda) em caixa")
        
        disponibilidadeBotao(botaoComprar, carteira, moeda, iso: siglaMoeda)
        disponibilidadeBotao(botaoVender, carteira, moeda, iso: siglaMoeda)
        
        quantidadeTextField.text =  ""
    }
    
    // MARK: - Disponibilidade Botões (Habilitado / Desabilitado)
    func disponibilidadeBotao(_ botao: UIButton, _ carteira: Carteira, _ moeda: Currency, iso: String) {
        guard let moedaPrecoCompra = moeda.buy,
              let moedaEmCarteira = carteira.carteiraPessoal[iso],
              let stringQuantidadeTextField = quantidadeTextField.text else { return }
        
        var precoTotal = Double()
        var quantidadeInserida = Int()
        
        if let IntQuantidadeInserida = Int(stringQuantidadeTextField) {
            quantidadeInserida = IntQuantidadeInserida
            precoTotal = moedaPrecoCompra * Double(IntQuantidadeInserida)
        }
        
        if botao.tag == 1 {
            // Botão Comprar
            if (carteira.saldo < moedaPrecoCompra || carteira.saldo < precoTotal) {
                botaoDesabilitado(botaoComprar)
            } else {
                botaoHabilitado(botaoComprar)
            }
        } else {
            // Botão Vender
            if (quantidadeInserida > moedaEmCarteira || moeda.sell == nil || moedaEmCarteira == 0) {
                botaoDesabilitado(botaoVender)
            } else {
                botaoHabilitado(botaoVender)
            }
        }
        if (stringQuantidadeTextField.isEmpty || quantidadeInserida <= 0) {
            botaoDesabilitado(botaoComprar)
            botaoDesabilitado(botaoVender)
        }
    }
    
    // MARK: - Botões Pressionados (Botões Comprar / Vender)
    @IBAction func BotoesPressionados(_ sender: Any) {
        guard let carteira = carteira,
              let moedaSelecionada = moedaSelecionada,
              let stringCampoQuantidade = quantidadeTextField.text,
              let campoQuantidade = Int(stringCampoQuantidade),
              let storyboard = storyboard,
              let MensagemViewController = storyboard.instantiateViewController(withIdentifier: "MensagemViewController") as? MensagemViewController,
              let navigationController = navigationController else {return}
        
        var acaoBotao: String
        var precoTransacao: String
        
        if (sender as AnyObject).tag == 0 {
            acaoBotao = "Comprar"
            carteira.comprar(quantidade: campoQuantidade, siglaMoeda, moedaSelecionada)
            precoTransacao = carteira.precoTotalCompraFormatado
        } else {
            acaoBotao = "Vender"
            carteira.vender(quantidade: campoQuantidade, siglaMoeda, moedaSelecionada)
            precoTransacao = carteira.precoTotalVendaFormatado
        }
        //Informações enviadas para a próxima tela.
        MensagemViewController.acaoBotaoMensagem = acaoBotao
        MensagemViewController.campoQuantidadeMensagem = campoQuantidade
        MensagemViewController.siglaMoedaMensagem = siglaMoeda
        MensagemViewController.moedaSelecionadaMensagem = moedaSelecionada
        MensagemViewController.precoTransacaoMensagem = precoTransacao
        
        MensagemViewController.title = acaoBotao.capitalized
        navigationController.pushViewController(MensagemViewController, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        alteracaoLabel()
    }
    
    
    // MARK: - Funções Customização.
    
    func BordasBotoes(){
        botaoComprar.layer.masksToBounds = true
        botaoComprar.layer.cornerRadius = 15
        botaoVender.layer.masksToBounds = true
        botaoVender.layer.cornerRadius = 15
    }
    
    func BordasView(){
        viewCambio.layer.borderWidth = 1
        viewCambio.layer.cornerRadius = 15
        viewCambio.layer.borderColor = UIColor.white.cgColor
        
    }
    
    func BordasQuantidade() {
        quantidadeTextField.layer.borderWidth = 1
        quantidadeTextField.layer.cornerRadius = 10
        quantidadeTextField.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
        quantidadeTextField.attributedPlaceholder = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)])
    }
    
    func botaoHabilitado(_ botao: UIButton) {
        botao.isEnabled = true
        botao.alpha = 1
    }
    
    func botaoDesabilitado( _ botao: UIButton) {
        botao.isEnabled = false
        botao.alpha = 0.5
    }
}

    // MARK: - Extensão Delegate
extension CambioViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let moedaSelecionada = moedaSelecionada,
              let carteira = carteira else { return }
        
        disponibilidadeBotao(botaoComprar, carteira, moedaSelecionada, iso: siglaMoeda)
        disponibilidadeBotao(botaoVender, carteira, moedaSelecionada, iso: siglaMoeda)
    }
}

