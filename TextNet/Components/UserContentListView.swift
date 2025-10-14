//
//  UserContentListView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/03/2025.
//

import SwiftUI

struct UserContentListView: View {
    @State private var selectedFilter: ProfilePostFilter = .posts
    @Namespace var animation
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfilePostFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    var body: some View {
        VStack{
            HStack{
                ForEach(ProfilePostFilter.allCases) { filter in
                    VStack{
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                        
                        if selectedFilter == filter{
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: 180, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 180, height: 1)
                        }
                    }
                    .onTapGesture{
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            LazyVStack{
                ForEach(0 ... 10, id: \.self) { index in
                    HomePostView(post: Post(ownerId: "sample", content: "Sample post \(index)", timestamp: .init()))
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    UserContentListView()
}
