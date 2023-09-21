//
//  ContentView.swift
//  MachineTest-Webandcrafts
//
//  Created by Harvin Shibu on 21/09/23.
//

import SwiftUI


struct RemoteImage: View {
    let url: URL
    @State private var image: UIImage?

    init(url: URL) {
        self.url = url
    }

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Text("Loading...").frame(width: 40)
                .onAppear {
                    loadImage()
                }
        }
    }

    private func loadImage(){
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            } else {
                print("Failed to create UIImage from data")
            }
        }.resume()
    }
}


struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    
    
    var body: some View {
        NavigationView{
            TabView(selection: $selectedTab) {
                ScrollView{
                    VStack(alignment: .leading){
                        VStack{
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Search", text: $searchText)
                                
                                Image(systemName: "barcode.viewfinder")
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                    }
                            }
                            .frame(height: 47)
                            .background(Color(UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)))
                            .padding([.leading, .trailing],10)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                            
                            
                        }.padding([.leading, .trailing],10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.categories, id: \.self) { item in
                                    CategoriesView(text: item.name ?? "", image: item.imageURL ?? "")
                                        .frame(width: UIScreen.main.bounds.width / 5)
                                }
                            }.padding([.leading,.trailing],10)
                        }.frame(height: 100)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.banner, id: \.self) { item in
                                    GeometryReader { geometry in
                                        RemoteImage(url: URL(string: item.bannerURL ?? "")!)
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width - 40)
                                            .clipped()
                                    }
                                    .cornerRadius(5)
                                    .frame(width: UIScreen.main.bounds.width - 30)
                                }
                            }
                            .padding(10)
                            .frame(height: 200)

                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.products, id: \.self) { item in
                                    ProductsView(image: item.image ?? "", express: item.isExpress ?? false, offer: item.offer ?? 0, realPrice: item.actualPrice ?? "", offerPrice: item.offerPrice ?? "", name: item.name ?? "")
                                }
                            }.padding(10)
                        }
                        .frame(height: 322)
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        
                }.tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                
                Text("Categories")
                    .tabItem {
                        Image(systemName: "menubar.rectangle")
                        Text("Categories")
                    }
                    .tag(1)

                
                Text("Offers")
                    .tabItem {
                        Image(systemName: "percent")
                        Text("Offers")
                    }
                    .tag(2)

                
                Text("Cart")
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Cart")
                    }
                    .badge(2)
                    .tag(3)

                
                Text("Account")
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Account")
                    }
                    .tag(4)
                 
            }
            
        }.onAppear{
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.shadowColor = .black
            tabBarAppearance.backgroundColor = .white
            tabBarAppearance.stackedItemPositioning = .centered
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            viewModel.fetch()
        }
        
    }
}

struct ProductsView: View {
    let image: String
    let express: Bool
    let offer: Int
    let realPrice:String
    let offerPrice: String
    let name: String
        
    var body: some View {
        
            VStack {
                HStack {
                    ZStack(alignment: .trailing) {
                        Rectangle()
                            .fill(Color.red)
                            .frame(height: 20)
                        
                        Text("\(offer)% OFF")
                            .foregroundColor(.white)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                        
                       
                    }
                    .frame(width: 60)
                    Spacer()
                    Image("heart")
                        .frame(width: 30, height: 30).padding(.trailing,5)
                    
                   
                }.padding(.top, 10).opacity(offer > 0 ? 1 : 0)
                
                RemoteImage(url: URL(string: image)!).frame(width: 92, height: 92)
                
                HStack{
                    ZStack{
                        Rectangle().fill(Color.yellow).frame(width: 23,height: 22)
                        Image("express").resizable().frame(width: 15, height: 10)
                    }.cornerRadius(3)
                    
                    Spacer()
                    
                }.padding(.leading, 5).opacity(express ? 1 : 0)
                
                Text(realPrice)
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                    .strikethrough(true, color: .gray)
                    .opacity(offer > 0 ? 1 : 0)
                Text(offerPrice)
                    .foregroundColor(.black)
                    .font(.headline)
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5) // Add padding to the left of the text
                
                Text(name)
                    .foregroundColor(.black)
                    .font(.footnote)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .bottom, .trailing], 5)
                
                Spacer()
                
                VStack {
                    Button(action: {
                    }) {
                        Text("ADD")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 31)
                    .background(Color.green)
                    .cornerRadius(5)
                    .padding([.leading, .bottom, .trailing], 20)
                    
                }
                
            }
            .frame(width: UIScreen.main.bounds.width / 2.5, height: 320)
            
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX + 10, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}


struct CategoriesView: View {
    let text: String
    let image:String
    
    var body: some View {
        VStack {
            ZStack{
                Circle().fill(Color.cyan)
                RemoteImage(url: URL(string: image)!).frame(width: 48, height: 48)
            }.frame(width: UIScreen.main.bounds.width / 1.8, height: 60)
            
            Text(text)
                .foregroundColor(.black)
                .font(.caption)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

