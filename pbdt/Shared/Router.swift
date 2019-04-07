//
//  Router.swift
//  pbdt
//
//  Created by Andrew M Levy on 3/30/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import Foundation

class Router {
    
    // enum containing all endpoints
    enum Endpoint : String {
        case createUser                         = "/users"              // POST
        case createOrDestroySession             = "/sessions"           // POST or DELETE
        case createFood                         = "/foods"              // POST
        case updateOrDestroyFood                = "/foods/@id1@"        // PUT or DELETE
        case indexItems                         = "/items"              // GET
    }
    
    /*
    // generate header
    func requestHeader() -> [String:String] {
        var headers : [String:String] = [:]
        //if let email = User
        return headers
    }
    */
}
