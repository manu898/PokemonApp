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
    
    func getPokemonList(numPokemon: Int) -> [Pokemon]{
        let urlData = urlString + "?limit=\(numPokemon)"
        if let url = URL(string: urlData){
            if let data = try? Data(contentsOf: url){
                if let jsonPokemonList = try? JSONDecoder().decode(Pokemons.self, from: data) {
                    pokemons = jsonPokemonList.results
                    return pokemons
                }
            }
        }
        return []
    }
    
    
    func getPokemon(id: Int) -> ([String],[Stat]){
        let urlData = urlString + "\(id)/"
        //print("la url è = \(urlData)")
        if let url = URL(string: urlData){
            if let data = try? Data(contentsOf: url){
                //print("presi i dati dalla URL")
                let abilities = getAbilities(data: data)
                let stats = getStats(data: data)
                return (abilities,stats)
            }
        }
        return ([],[])
    }
    
    func getPokemon(name: String) -> ([String],[Stat]){
        let urlData = urlString + "\(name)/"
        //print("la url è = \(urlData)")
        if let url = URL(string: urlData){
            if let data = try? Data(contentsOf: url){
                //print("presi i dati dalla URL")
                let abilities = getAbilities(data: data)
                let stats = getStats(data: data)
                return (abilities,stats)
            }
        }
        return ([],[])
    }
    
    func getAbilities(data: Data) -> [String] {
        if let json = try? JSON(data: data) {
            var abilitiesList = [String]()
            for (_, abilities) in json["abilities"] {
                let ability = abilities["ability"]["name"].stringValue
                abilitiesList.append(ability)
            }
            //print("abilitiesList = \(abilitiesList)")
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
                print("StatName: \(statName) = \(statValue) ")
                print("statsDict = \(statsDict)")
            }
            print("statsDict = \(statsDict)")
            return statsDict
        }
        return []
    }
        
    func getPokemonImageURL(name: String) -> String {
        let urlData = urlString + "\(name)/"
        if let url = URL(string: urlData) {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSON(data: data) {
                    let imageURL = json["sprites"]["front_default"].stringValue
                    return imageURL
                }
            }
        }
        return "niente immagine"
    }
    
    // l'ID lo prendo dalla lista
    func getPokemonImage(url: String) -> UIImageView{
        let imageView = UIImageView()
        // Fetch Image Data
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                // Create Image and Update Image View
                imageView.image = UIImage(data: data)
            }
            return imageView
        }
        return imageView
    }
}

