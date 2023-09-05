//
//  Networking.swift
//  AimGame
//
//  Created by mac on 9/4/23.
//

import Foundation

let resultURL = "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod"


extension ViewController {
    func fetchResultLink(completionHandler: @escaping () -> Void) {
        if let url = URL(string: resultURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        self.winnerStringURL = res.winner
                        self.loserStringURL = res.loser
                        completionHandler()
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
