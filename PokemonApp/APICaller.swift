//
//  APICaller.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import Foundation
import SwiftyJSON
import UIKit

struct Pokemon: Decodable{
    let name: String
    let url: URL
}

struct Pokemons: Decodable{
    let results: [Pokemon]
}

struct Stat {
    let name: String
    let value: String
}

class APICaller{
    static let shared = APICaller()
    var pokemons = [Pokemon]()
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    
    func getPokemonList(numPokemon: Int) async throws -> [Pokemon] {
        let urlData = urlString + "?limit=\(numPokemon)"
        guard let url = URL(string: urlData) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching pokemon list")}
        
        guard let decodedData = try? JSONDecoder().decode(Pokemons.self, from: data) else {
            fatalError("The server response wasn't recognized ")
        }
        return decodedData.results
    }
    
    func getPokemon(id: Int) async throws -> ([String],[Stat]){
        let urlData = urlString + "\(id)/"
        guard let url = URL(string: urlData) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching pokemon")
        }
        let abilities = getAbilities(data: data)
        let stats = getStats(data: data)
        return (abilities,stats)
    }
    
    func getPokemon(name: String) async throws -> ([String],[Stat]){
        let urlData = urlString + "\(name)/"
        guard let url = URL(string: urlData) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching pokemon")
        }
        let abilities = getAbilities(data: data)
        let stats = getStats(data: data)
        return (abilities,stats)
    }
    
    func getAbilities(data: Data) -> [String] {
        if let json = try? JSON(data: data) {
            var abilitiesList = [String]()
            for (_, abilities) in json["abilities"] {
                let ability = abilities["ability"]["name"].stringValue
                abilitiesList.append(ability)
            }
            return abilitiesList
        }
        return []
    }
    
    func getStats(data: Data) -> [Stat]{
        if let json = try? JSON(data: data) {
            var statsDict: [Stat] = [Stat]()
            for (_, stats) in json["stats"] {
                let statName = stats["stat"]["name"].stringValue
                let statValue = stats["base_stat"].stringValue
                statsDict.append(Stat(name: statName, value: statValue))
            }
            return statsDict
        }
        return []
    }
    
    func getPokemonImageURL(name: String) async throws -> String {
        let urlData = urlString + "\(name)/"
        guard let url = URL(string: urlData) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching pokemon image URL")
        }
        guard let json = try? JSON(data: data) else {
            fatalError("The server response wasn't recognized")
        }
        let imageURL = json["sprites"]["front_default"].stringValue
        return imageURL
    }
    
    func getPokemonImage(url: String) async throws -> UIImageView{
        let imageView = UIImageView()
        guard let url = URL(string: url) else {
            fatalError("Missing URL")
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching pokemon image URL")
        }
        DispatchQueue.main.async {
            imageView.image = UIImage(data: data)
        }
        return imageView
    }
}

