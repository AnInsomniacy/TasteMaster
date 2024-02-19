//
//  ContributeCards.swift
//  TasteMaster
//
//  Created by Sekiro on 31/10/2023.
//

import Foundation
import SwiftUI

struct ContributeCards: View {
    
    @Environment(\.colorScheme) var colorScheme // 获取当前的配色方案（明亮或黑暗）
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: card.cardHSpaceMin, maximum: card.cardHSpaceMax))], spacing: card.cardVSpace) {
            
                ForEach(ContributeCardsManager.getCardInfoArray()){ CookingCard in
                    
                    NavigationLink(destination: CookingCard.getContent) {
                        VStack(spacing: card.cardTextImageSpace){
                            Text(CookingCard.image)           .font(.title)
                                .frame(width: card.imageWidth, height: card.imageHeight)
                            
                            Text(CookingCard.text)
                        }
                        .frame(width: card.width, height: card.height)
                        .background(CookingCard.color)
                        .cornerRadius(card.radius)
                        .shadow(color: colorScheme == .dark ? Color.cyan.opacity(0.2) : Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: card.radius)
                                .stroke(colorScheme == .dark ? Color.brown : Color.white, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .font(card.fontSize)
                    }
                    
                }

                
            }.padding()
            .navigationTitle("作出贡献")
        }
    }
}


#Preview {
    NavigationStack{
        ContributeCards()
    }
}
