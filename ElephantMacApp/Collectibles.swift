//
//  Collectibles.swift
//  Elephant
//
//  Created by 陸卉媫 on 4/14/25.
//
//## File Description: This file contains all information about collectible packs.
//
//## Components:
// - collectible packs
// - allCollectibles: a list of all collectibles

import SwiftUI

// TODO: update code for more systematic collectible organizations
//struct CollectiblePack : Identifiable {
//    let id: String
//    let name: String
//    let items: Array<ShopItem>
//}

let mammals = [
    ShopItem(id: "mammal-lion", name: "Lion", price: 5),
    ShopItem(id: "mammal-sheep", name: "Sheep", price: 5),
    ShopItem(id: "mammal-elephant", name: "Elephant", price: 5),
    ShopItem(id: "mammal-squirrel", name: "Squirrel", price: 5),
    ShopItem(id: "mammal-giraffe", name: "Giraffe", price: 5),
    ShopItem(id: "mammal-monkey", name: "Monkey", price: 5)
]

let marines = [
    ShopItem(id: "marine-dolphin", name: "Dolphin", price: 5),
    ShopItem(id: "marine-whale", name: "Whale", price: 5),
    ShopItem(id: "marine-narwhal", name: "Narwhal", price: 5),
    ShopItem(id: "marine-penguin", name: "Penguin", price: 5),
    ShopItem(id: "marine-seal", name: "Seal", price: 5),
    ShopItem(id: "marine-turtle", name: "Turtle", price: 5),
]

let birds = [
    ShopItem(id: "bird-pelican", name: "Pelican", price: 5),
    ShopItem(id: "bird-seagull", name: "Seagull", price: 5),
    ShopItem(id: "bird-dove", name: "Dove", price: 5),
    ShopItem(id: "bird-owl", name: "Owl", price: 5),
    ShopItem(id: "bird-tucan", name: "Tucan", price: 5),
    ShopItem(id: "bird-woodpecker", name: "Woodpecker", price: 5),
]

let monsters = [
    ShopItem(id: "monster-fourarms", name: "Four arms", price: 5),
    ShopItem(id: "monster-mad", name: "Mad", price: 5),
    ShopItem(id: "monster-scaring", name: "Intimidating", price: 5),
    ShopItem(id: "monster-alien", name: "Alien", price: 5),
    ShopItem(id: "monster-sneeze", name: "Sneezing", price: 5),
    ShopItem(id: "monster-tree", name: "Tree", price: 5),
    ShopItem(id: "monster-teeth", name: "Teeth", price: 5),
]

let unicorns = [
    ShopItem(id: "unicorn-throwup", name: "Rainbow", price: 5),
    ShopItem(id: "unicorn-sunglass", name: "Sunglasses", price: 5),
    ShopItem(id: "unicorn-wave", name: "Waving", price: 5),
    ShopItem(id: "unicorn-kiss", name: "Kissing", price: 5),
    ShopItem(id: "unicorn-confetti", name: "Confetti", price: 5),
    ShopItem(id: "unicorn-wine", name: "Wine", price: 5),
]

let magic = [
    ShopItem(id: "magic-dragon", name: "Dragon", price: 5),
    ShopItem(id: "magic-wizard", name: "Wizard", price: 5),
    ShopItem(id: "magic-witch", name: "Witch", price: 5),
    ShopItem(id: "magic-fairy", name: "Fairy", price: 5),
    ShopItem(id: "magic-vampire", name: "Vampire", price: 5),
    ShopItem(id: "magic-superman", name: "Superman", price: 5),
]

let packs = [mammals, marines, birds, monsters, unicorns, magic]

let allCollectibles: [ShopItem] = packs.flatMap { $0 }
