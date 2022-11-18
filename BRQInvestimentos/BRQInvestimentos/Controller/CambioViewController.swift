import Foundation
import UIKit

class CambioViewController: UIViewController {
    
    // View
    @IBOutlet weak var viewCambio: UIView!
    
    // Labels da View
    @IBOutlet weak var siglaNomeLabel: UILabel!
    @IBOutlet weak var variacaoLabel: UILabel!
    @IBOutlet weak var precoCompraLabel: UILabel!
    @IBOutlet weak var precoVendaLabel: UILabel!
    
    // Saldo Disponivel
    @IBOutlet weak var saldoDisponivelLabel: UILabel!
    
    // Moeda em caixa
    @IBOutlet weak var moedaCaixaLabel: UILabel!
    
    // Botões
    @IBOutlet weak var botaoVender: UIButton!
    @IBOutlet weak var botaoComprar: UIButton!
    
    // Campo quantidade
    @IBOutlet weak var quantidadeTextField: UITextField!
    
    // Variáveis
    var moedaSelecionada: Currency?
    var siglaMoeda = String()
    var currencyISO = String()
    var carteira: Carteira?
    var totalTransacao = Double()
    var valorDeVenda = Double()
    var valorDeCompra = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customização
        customizacaoBotoes()
        customizacaoView()
        customizacaoQuantidade()
        
        alteracaoLabel()
        
    }
    // MARK: - Alterando Labels
    func alteracaoLabel() {
        guard let moeda = moedaSelecionada,
              let carteira = carteira,
              let quantidadeDeMoedas = carteira.carteiraPessoal[siglaMoeda]  else {return}
        
        // Sigla Moeda
        siglaNomeLabel.text = "\(siglaMoeda) - \(moeda.name)"
        
        // Variação Moeda
        variacaoLabel.text = moeda.variationString
        variacaoLabel.corLabel(variacaoPorcentagem: moeda.variation)  // Cor variação
        
        // Preço de Compra
        precoCompraLabel.text = ("Compra: " + moeda.compraString)
        
        // Preço de Venda
        precoVendaLabel.text = ("Venda: " + moeda.vendaString)
        
        // Saldo disponível
        saldoDisponivelLabel.text = ("Saldo disponível: \(carteira.saldoDisponivel)")
        
        // Quantidade em caixa
        moedaCaixaLabel.text = ("\(quantidadeDeMoedas) \(siglaMoeda) em caixa")
        
        // Disponibilidade dos Botões
        disponibilidadeBotao(botaoComprar, carteira, moeda, iso: siglaMoeda)
        disponibilidadeBotao(botaoVender, carteira, moeda, iso: siglaMoeda)
        quantidadeTextField.text = ""
    }
    
    // MARK: - Disponibilidade Botões (Habilitado / Desabilitado)
    func disponibilidadeBotao(_ botao: UIButton, _ carteira: Carteira, _ moeda: Currency, iso: String) {
        
        guard let moedaPrecoCompra = moeda.buy,
              let dinheiroDisponivel = carteira.carteiraPessoal[iso],
              let stringDinheiroDisponivel = quantidadeTextField.text else { return }
        
        var precoTotal = Double()
        var quantidadeInserida = Int()
        if let intQuantidadeInserida = Int(stringDinheiroDisponivel) {
            quantidadeInserida = intQuantidadeInserida
            precoTotal = moedaPrecoCompra * Double(intQuantidadeInserida)
        }
        
        if botao.tag == 1 {
            // BotaoComprar
            if (carteira.saldo < moedaPrecoCompra || carteira.saldo < precoTotal) {
                habilitado(botaoComprar)
            } else {
                desabilitado(botaoComprar)
            }
        } else {
            // BotaoVender
            if (quantidadeInserida > dinheiroDisponivel || moeda.sell == nil || dinheiroDisponivel == 0) {
                habilitado(botaoVender)
            } else {
                desabilitado(botaoVender)
            }
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
    
    // MARK: - Funções Botões (Desabilitado / Habilitado)
    
    // Desabilitado
    func desabilitado(_ botao: UIButton) {
        botao.isEnabled = true
    }
    
    // Habilitado
    func habilitado(_ botao: UIButton) {
        botao.isEnabled = false
    }
    
    // MARK: - Funções de customização
    // Botões
    func customizacaoBotoes() {
        botaoComprar.layer.cornerRadius = 15
        botaoVender.layer.cornerRadius = 15
    }
    
    // View
    func customizacaoView() {
        viewCambio.layer.borderWidth = 1
        viewCambio.layer.cornerRadius = 15
        viewCambio.layer.borderColor = UIColor.white.cgColor
    }
    
    // Quantidade (TextField)
    func customizacaoQuantidade() {
        quantidadeTextField.layer.borderWidth = 1
        quantidadeTextField.layer.cornerRadius = 10
        quantidadeTextField.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
        quantidadeTextField.attributedPlaceholder = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)])
    }
}
