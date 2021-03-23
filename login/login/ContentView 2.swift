//
//  ContentView.swift
//  login
//
//  Created by Ivan Peng on 3/16/21.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct ContentView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            TitleText()
            TextField("Username", text: $username).padding().background(lightGreyColor).cornerRadius(5.0).padding(.bottom, 20)
            TextField("Password", text: $password).padding().background(lightGreyColor).cornerRadius(5.0).padding(.bottom, 20)
            Button(action: {print("LOGIN tapped")}) {
                LoginButtonText()
            }
            Button(action: {print("SIGN UP tapped")}) {
                SingUpButtonText()
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct TitleText : View {
    var body: some View {
        return Text("Trojan Check In/Out").font(.largeTitle).fontWeight(.semibold).padding(.bottom, 20)
    }
}

struct LoginButtonText : View {
    var body: some View {
        return Text("Login").font(.headline).foregroundColor(.white).padding().frame(width: 220, height: 60).background(Color.black).cornerRadius(15.0)
    }
}

struct SingUpButtonText : View {
    var body: some View {
        return Text("Sign Up").font(.headline).foregroundColor(.white).padding().frame(width: 220, height: 60).background(Color.black).cornerRadius(15.0)
    }
}
