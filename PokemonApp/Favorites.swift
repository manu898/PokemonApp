//
//  Favorites.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import UIKit
import Foundation

class Preferiti: UIViewController{
    
    var realmManager: RealmManager?
    var buttonList: [(PokemonButton,Int)] = []
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
        
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let realmManager = realmManager {
            let rimossiCount = realmManager.changeInFavorite["rimossi"]?.count
            let aggiuntiCount = realmManager.changeInFavorite["aggiunti"]?.count
            print("rimosssi = \(rimossiCount!) e aggiunti = \(aggiuntiCount!)")
            if realmManager.changeInFavorite["rimossi"]?.count == 0 && realmManager.changeInFavorite["aggiunti"]?.count != 0 {
                realmManager.changeInFavorite["aggiunti"]?.forEach { poke in
                    print("count = 0 e chiamo ")
                    let imageURL = APICaller.shared.getPokemonImageURL(name: poke)
                    let imageView = APICaller.shared.getPokemonImage(url: imageURL)
                    let button = PokemonButton(title: poke, imageView: imageView)
                    let btn = button.button
                    let numOfButton = buttonList.count
                    btn.tag = numOfButton + 200 // 199 prima ma crea problemi
                    buttonList.append((button,btn.tag))
                    btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
                    stackView.addArrangedSubview(btn)
                }
            } else if realmManager.changeInFavorite["rimossi"]?.count == 0 && realmManager.changeInFavorite["aggiunti"]?.count == 0 {
                print("non eseguo un cazzo")
            } else {
                print("qualche pokemon è stato rimosso dai preferiti")
                //print("buttonList dentro viewWillAppear = \(buttonList)")
                
//                realmManager.changeInFavorite["rimossi"]?.forEach { poke in
//                    print("\(poke) è il pokemon da rimuovere")
//                    removeSubview(pokemonName: poke)
//                }
                
                removeAllSubviews(sV: stackView)
                setup()
            }
            realmManager.changeInFavorite["aggiunti"] = []
            realmManager.changeInFavorite["rimossi"] = []
        }
        
    }
    
    func removeAllSubviews(sV: UIStackView){
        sV.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        buttonList.removeAll()
    }
    
    // da testare
    func removeSubview(pokemonName: String) {
        print("buttonList dentro removeSub = \(buttonList)")
        buttonList.forEach { poke in
            print("pokemonName foreach = \(String(describing: poke.0.title))")
            if poke.0.title == pokemonName {
                let viewToRemove = view.viewWithTag(poke.1)
                printContent("view da rimuovere = \(String(describing: viewToRemove))")
                viewToRemove?.removeFromSuperview()
            }
        }
    }
    
    private func setup() {
        if let realmManager = realmManager {
            for (n,poke) in realmManager.favourites.enumerated(){
                let imageURL = APICaller.shared.getPokemonImageURL(name: poke.name)
                let imageView = APICaller.shared.getPokemonImage(url: imageURL)
                let button = PokemonButton(title: poke.name, imageView: imageView)
                let btn = button.button
                btn.tag = n+200 // random number diverso da quello già dato
                buttonList.append((button,btn.tag))
                btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
                stackView.addArrangedSubview(btn)
            }
        }
        print("buttonListPreriti = \(buttonList)")
    }
    
    private func setupViews() {
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setup()
    }
    
    @objc
    func tap(sender: UIButton){
        let pokemonName = buttonList[sender.tag-200].0.title
        print("pokemonName = \(pokemonName!)")
        let result = APICaller.shared.getPokemon(name: pokemonName!)
        let imageURL = APICaller.shared.getPokemonImageURL(name: pokemonName!)
        let imageView = APICaller.shared.getPokemonImage(url: imageURL)
        let abilities = result.0
        let stats = result.1
        let controller = PokemonDetailView()
        controller.img = imageView
        controller.pokemonName = pokemonName
        controller.preferiti = self
        controller.realmManager = realmManager
        controller.stats = stats
        controller.abilities = abilities
        present(controller, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
