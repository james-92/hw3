//
//  ContentView.swift
//  hw3 iOS
//
//  Created by James.Lai on 21/11/2024.
//

import SwiftUI

struct User{
    let title: String
    var name: String
    var highestScore: String
    
    var initials: String?{
        let formatter = PersonNameComponentsFormatter()
        guard  let components = formatter.personNameComponents(from:title) else{
            return nil}
        formatter.style = .abbreviated
        return formatter.string(from: components)
    }
}

class ContentViewModel: ObservableObject{
    @Published var user: User
    
    init() {
        self.user = User(title: "Player1",name: "your name",highestScore:"0")
    }
}

struct ContentView: View{
    @EnvironmentObject var viewModel: ContentViewModel
    var body: some View{
        
        VStack(spacing: 0){
            NavigationStack{
                List{
                    NavigationLink{
                        EditProfileView()
                    } label: {
                        HStack{
                            Text(viewModel.user.initials ?? "")//
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 48,height: 48)
                                .background(Color(.systemGray4))
                                .clipShape(Circle())
                            VStack(alignment: .leading,spacing: 4){
                                Text(viewModel.user.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Name: \(viewModel.user.name)")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    .padding(.leading,2)
                                    .tint(.gray)
                                Text("highest score: \(viewModel.user.highestScore)")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    NavigationLink("遊戲教學"){
                        TutorialView()
                    }
                    NavigationLink("Start Game") {
                        GameViewControllerWrapper()
                            .edgesIgnoringSafeArea(.all) // 確保遊戲畫面全螢幕
                    }
                }
                .navigationTitle("Game Menu")
                
                TimelineView(.animation) { context in
                        Text("Current Time: \(context.date, formatter: DateFormatter.timeFormatter)")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .padding() // 讓文字與背景有間距
                        .background(Color.white) // 背景顏色
                        .foregroundColor(.black) // 文字顏色
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
    }
}

extension DateFormatter {
    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // 時間格式：小時:分鐘:秒
        return formatter
    }
}
#Preview{
    ContentView()
        .environmentObject(ContentViewModel())
}
