//
//  Pokemon.swift
//  PokeApp
//
//  Created by Felipe Correa on 8/05/23.
//

import Foundation

final class Pokemon: Decodable, Identifiable {
    
    let name: String
    let id: String
    let imageUrl: String
    let xDescription: String
    let yDescription: String
    let height: String
    let category: String
    let weight: String
    let typeOfPokemon: [PokemonType]
    let weaknesses: [String]
    let evolutions: [String]
    let abilities: [String]
    let hp: Double
    let attack: Double
    let defense: Double
    let speciaAttack: Double
    let specialDefense: Double
    let speed: Double
    let total: Double
    let malePercentage: String?
    let femalePercentage: String?
    let genderless: Double
    let cycles: String
    let eggGroups: String
    let reason: String
    let evolvedFrom: String
    let baseExp: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case imageUrl = "imageurl"
        case xDescription = "xdescription"
        case yDescription = "ydescription"
        case height
        case category
        case weight
        case typeOfPokemon = "typeofpokemon"
        case weaknesses
        case evolutions
        case abilities
        case hp
        case attack
        case defense
        case speciaAttack = "special_attack"
        case specialDefense = "special_defense"
        case speed
        case total
        case malePercentage = "male_percentage"
        case femalePercentage = "female_percentage"
        case genderless
        case cycles
        case eggGroups = "egg_groups"
        case reason
        case evolvedFrom = "evolvedfrom"
        case baseExp = "base_exp"
    }
    
    var mainType: PokemonType {
        typeOfPokemon.first ?? .unknown
    }
    
    var typeEffectiveness: [PokemonType: Double] {
        var effectiveness: [PokemonType: Double] = [:]
        
        for type in PokemonType.allCases where type != .unknown {
            let typeEffectiveness = typeOfPokemon
                .map { $0.effectiveness(to: type)}
                .reduce(1.0, *)
            effectiveness[type] = typeEffectiveness
        }
        return effectiveness
    }
    
    static func sample() -> Pokemon {
        if let pkm = Pokemon.loadData().first {
            return pkm
        }
        fatalError()
    }
}

extension Pokemon: Hashable {
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Pokemon {
    static func loadData() -> [Pokemon] {
        if let path = Bundle(for: Pokemon.self).path(forResource: "PokemonList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let info = try decoder.decode([Pokemon].self, from: data)
                return info
            } catch let error {
                assertionFailure(error.localizedDescription)
            }
        }
        assertionFailure("Invalid Path for Pokemon List File'")
        return []
    }
}
