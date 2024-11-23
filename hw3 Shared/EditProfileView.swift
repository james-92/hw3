//
//  EditProfileView.swift
//  hw3 iOS
//
//  Created by James.Lai on 21/11/2024.
//

import SwiftUI

struct EditProfileView: View{
    @EnvironmentObject var viewModel: ContentViewModel
    var body: some View{
        List{
            Section("Edit Options"){
                Text(viewModel.user.title)
                
                NavigationLink{
                    EditNameView()
                } label: {
                    Text(viewModel.user.name)
                }
                
                NavigationLink{
                    EditScoreView()
                } label: {
                    Text(viewModel.user.highestScore)
                }
            }
        }
    }
}



struct EditNameView: View{
    @State private var name = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View{
        VStack{
            TextField("Edit your name",text: $name)
                .font(.subheadline)
                .cornerRadius(10)
                .padding(.horizontal,4)
            
            Divider()
            
            Spacer()
        }
        .navigationTitle("Edit Name")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button("Done"){
                    viewModel.user.name = name
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
    }
}


struct EditScoreView: View{
    @State private var highestScore = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View{
        VStack{
            TextField("Edit your highest score",text: $highestScore)
                .font(.subheadline)
                .cornerRadius(10)
                .padding(.horizontal,4)
            
            Divider()
            
            Spacer()
        }
        .navigationTitle("Edit Highest Score")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button("Done"){
                    viewModel.user.highestScore = highestScore
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
    }
}


#Preview {
    EditProfileView()
        .environmentObject(ContentViewModel())
}
