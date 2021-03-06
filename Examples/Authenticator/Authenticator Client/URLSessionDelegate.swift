//
//  URLSessionDelegate.swift
//  Authenticator
//
//  Created by Kyle Jessup on 2015-11-12.
//  Copyright © 2015 PerfectlySoft. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Affero General Public License as
//	published by the Free Software Foundation, either version 3 of the
//	License, or (at your option) any later version, as supplemented by the
//	Perfect Additional Terms.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Affero General Public License, as supplemented by the
//	Perfect Additional Terms, for more details.
//
//	You should have received a copy of the GNU Affero General Public License
//	and the Perfect Additional Terms that immediately follow the terms and
//	conditions of the GNU Affero General Public License along with this
//	program. If not, see <http://www.perfect.org/AGPL_3_0_With_Perfect_Additional_Terms.txt>.
//

import Foundation

class URLSessionDelegate: NSObject, NSURLSessionDataDelegate {
	
	let username: String
	let password: String
	let completionHandler:(d:NSData?, res:NSURLResponse?, e:NSError?)->()
	var data: NSData?
	var response: NSURLResponse?
	var suppliedCreds = false
	
	init(username: String, password: String, completionHandler: (d:NSData?, res:NSURLResponse?, e:NSError?)->()) {
		self.username = username
		self.password = password
		self.completionHandler = completionHandler
	}
	
	func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
		if self.suppliedCreds {
			completionHandler(.PerformDefaultHandling, nil)
		} else {
			self.suppliedCreds = true
			let cred = NSURLCredential(user: username, password: password, persistence: .ForSession)
			completionHandler(.UseCredential, cred)
		}
	}

	func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
		self.data = data
	}
	
	func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
		self.response = response
		completionHandler(NSURLSessionResponseDisposition.Allow)
	}
	
	func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
		self.completionHandler(d: self.data, res: self.response, e: error)
	}
}
