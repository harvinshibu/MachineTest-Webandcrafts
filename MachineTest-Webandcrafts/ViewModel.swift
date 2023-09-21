//
//  ViewModel.swift
//  MachineTest-Webandcrafts
//
//  Created by Harvin Shibu on 21/09/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var categories: [Value] = []
    @Published var banner: [Value] = []
    @Published var products: [Value] = []
    
    
    func fetch() {
        guard let url = URL(string: "https://run.mocky.io/v3/69ad3ec2-f663-453c-868b-513402e515f0") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self ] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(DataModel.self, from: data)
                DispatchQueue.main.async {
                    self?.categories = decodedData.homeData.first!.values
                    self?.banner = decodedData.homeData[1].values
                    self?.products = decodedData.homeData.last!.values
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
