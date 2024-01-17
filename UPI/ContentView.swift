//
//  ContentView.swift
//  UPI
//
//  Created by Debashish on 16/01/24.
//

import SwiftUI

struct ContentView: View {
    var viewModel = UPIAppListViewModel()
    var body: some View {
        VStack{
            Spacer()
            Text("Select the Installed UPI Apps to continue with payment")
                .bold()
                .padding(.all)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.installedAppList,id:\.self) { app in
                        AppView(model: app)
                            .padding(.all)
                    }
                }
            }
        }
    }
}

struct AppView: View {
    var model: UPIAppListViewDataModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(lineWidth: 3)
                .foregroundColor(.green)
            VStack {
                Image(uiImage: model.imageURL ?? UIImage(named: "defaultUPI")!)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding()
                Text(model.appname)
                    .font(.title3)
                    .textCase(.uppercase)
                    .bold()
                    .foregroundColor(.blue)
            }
            
        }
        .frame(width: 150,height: 150,alignment: .center)
        .onTapGesture {
            redirectToUPIApp(appScheme: model.appScheme)
        }
    }
    func redirectToUPIApp(appScheme: String) {
        print("App is installed and can be opened")
        let url = URL(string:appScheme)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
