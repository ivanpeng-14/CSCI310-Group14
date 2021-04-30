//
//  EmailSender.swift
//  qrcodeStuff
//
//  Created by Carlos Lao on 2021/4/29.
//

import Foundation
import Alamofire

struct EmailSender {
    let APIurl = "https://api.mailjet.com/v3.1/send"
    let headers: HTTPHeaders = [
                .authorization(username: "bcafa8f2678dc3537fee31490dc8ce12", password: "60364317b3889f32745d46f0d199c290"),
                .accept("application/json")
            ]
    let from = "crlao@usc.edu"
    let fromName = "Trojan Check In"
    
    func sendEmail(to email: String, name: String, subject: String, text: String, html: String) {
        
        let body: [String: Any] = [
            "From": [
                "Email": self.from,
                "Name": self.fromName
            ],
            "To": [[
                "Email": email,
                "Name": name
            ]],
            "Subject": subject,
            "TextPart": text,
            "HTMLPart": html
        ]
        
        AF.request(APIurl, method: .post, parameters: ["Messages": [body]], encoding: JSONEncoding.default, headers: self.headers).responseString { (response) in
                        print(response)
                    }
    }
    
    func verificationEmail(for email: String, name: String) {
        let subject = "Thank You for Signing Up with Trojan Check In!"
        let text = "Welcome to Trojan Check In, \(name)! Thank you for signing up for our services. Upon receiving this email, your email has officially been verified. That's it! You don't have to do any more. Stay safe and fight on!"
        let html = "<h3>Welcome to Trojan Check In, \(name)!</h3><p>Thank you for signing up for our services.<br />Upon receiving this email, your email has officially been verified.<br />That's it! You don't have to do any more.</p><h4>Stay Safe and Fight On!</h4>"
        
        sendEmail(to: email, name: name, subject: subject, text: text, html: html)
    }
    
    func kickEmail(for email: String, name: String, building: String) {
        let subject = "You Were Kicked Out of \(building)!"
        let text = "You have been kicked out of \(building). We hope this isn't too much of an inconvenience! Fight On!"
        let html = "<h3>You have been kicked out of \(building).</h3><p>We hope this isn't too much of an inconvenience!</p><h4>Fight On!</h4>"
        
        sendEmail(to: email, name: name, subject: subject, text: text, html: html)
    }
}
