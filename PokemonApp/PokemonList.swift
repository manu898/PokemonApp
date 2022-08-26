//
//  PokemonList.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import UIKit
import Foundation
import SwiftUI

class PokemonList: UIViewController {
    
    var realmManager: RealmManager?
    var pokemonList: [Pokemon]?
    var buttonList: [PokemonButton] = [PokemonButton]()
    var favorites: UIViewController?
    
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
    
    private func setupViews() {
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        pokemonList = APICaller.shared.getPokemonList(numPokemon: 50)

        if let pokemonList = pokemonList {
            for (n,poke) in pokemonList.enumerated(){
                let imageURL = APICaller.shared.getPokemonImageURL(name: poke.name)
                let imageView = APICaller.shared.getPokemonImage(url: imageURL)
                let button = PokemonButton(title: poke.name, imageView: imageView)
                buttonList.append(button)
                let btn = button.button
                btn.tag = n+1
                btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
                stackView.addArrangedSubview(btn)
            }
        }
    }
    
    @objc
    func tap(sender: UIButton){
        let pokemonName = buttonList[sender.tag-1].title
        let imageURL = APICaller.shared.getPokemonImageURL(name: pokemonName!)
        let imageView = APICaller.shared.getPokemonImage(url: imageURL)
        let result = APICaller.shared.getPokemon(id: sender.tag)
        let abilities = result.0
        let stats = result.1
        let controller = PokemonDetailView()
        controller.img = imageView
        controller.pokemonName = pokemonName
        controller.favorites = favorites
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

class PokemonButton: UIView{
    var title: String?
    var imageView: UIImageView?

    init(title: String, imageView: UIImageView){
        self.title = title
        self.imageView = imageView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 200).isActive = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor

        let image = imageView?.image
        let targetSize = CGSize(width: 150, height: 150)

        let scaledImage = image?.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        button.setImage(scaledImage?.image, for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
}


