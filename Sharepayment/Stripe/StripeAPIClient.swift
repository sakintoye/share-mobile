//
//  BackendAPIAdapter.swift
//  Stripe iOS Example (Simple)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//
import Foundation
import Stripe

class StripeAPIClient: NSObject, STPBackendAPIAdapter {
    
    static let sharedClient = StripeAPIClient()
    let session: URLSession
    var baseURLString: String? = "https://api.payment.akintoye.me/"
    var customerID: String? = nil
    var defaultSource: STPCard? = nil
    var sources: [STPCard] = []
    let backendURI = "stripe"
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        self.session = URLSession(configuration: configuration)
        super.init()
    }
    
    func decodeResponse(_ response: URLResponse?, error: NSError?) -> NSError? {
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            return error ?? NSError.networkingError(httpResponse.statusCode)
        }
        return error
    }
    
    func completeCharge(_ result: STPToken, amount: Double, recipient_id: Int, completion: @escaping STPErrorBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString) else {
            let error = NSError(domain: StripeDomain, code: 50, userInfo: [
                NSLocalizedDescriptionKey: "Please set baseURLString to your backend URL in CheckoutViewController.swift"
                ])
            completion(error)
            return
        }
        guard let customerID = customerID else {
            let error = NSError(domain: StripeDomain, code: 50, userInfo: [
                NSLocalizedDescriptionKey: "Please set customerID to a valid Stripe customer ID in CheckoutViewController.swift"
                ])
            completion(error)
            return
        }
        let path = "\(backendURI)/charge_card"
        let url = baseURL.appendingPathComponent(path)
        let params: [String: AnyObject] = [
            "stripe_token": result.stripeID as AnyObject,
            "amount": amount * 100,
            "recipient_id": recipient_id,
            "customer_id": customerID
        ]
        let request = URLRequest.request(url, method: .POST, params: params)
        let task = self.session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error) {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }) 
        task.resume()
    }
    
    @objc func retrieveCustomer(_ completion: @escaping STPCustomerCompletionBlock) {
        guard let key = Stripe.defaultPublishableKey(), !key.contains("#") else {
            let error = NSError(domain: StripeDomain, code: 50, userInfo: [
                NSLocalizedDescriptionKey: "Please set stripePublishableKey to your account's test publishable key in CheckoutViewController.swift"
                ])
            completion(nil, error)
            return
        }
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString), let customerID = customerID else {
            // This code is just for demo purposes - in this case, if the example app isn't properly configured, we'll return a fake customer just so the app works.
            let customer = STPCustomer(stripeID: "cus_test", defaultSource: self.defaultSource, sources: self.sources)
            completion(customer, nil)
            return
        }
        let path = "\(backendURI)\(customerID)"
        let url = baseURL.appendingPathComponent(path)
        let request = URLRequest.request(url, method: .GET, params: [:])
        let task = self.session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
            DispatchQueue.main.async {
                let deserializer = STPCustomerDeserializer(data: data, urlResponse: urlResponse, error: error)
                if let error = deserializer.error {
                    completion(nil, error)
                    return
                } else if let customer = deserializer.customer {
                    completion(customer, nil)
                }
            }
        }) 
        task.resume()
    }
    
    @objc func selectDefaultCustomerSource(_ source: STPSource, completion: @escaping STPErrorBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString), let customerID = customerID else {
            if let token = source as? STPToken {
                self.defaultSource = token.card
            }
            completion(nil)
            return
        }
        let path = "\(backendURI)\(customerID)/select_source"
        let url = baseURL.appendingPathComponent(path)
        let params = [
            "customer_id": customerID,
            "source": source.stripeID,
            ]
        let request = URLRequest.request(url, method: .POST, params: params)
        let task = self.session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error) {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }) 
        task.resume()
    }
    
    @objc func attachSource(toCustomer source: STPSource, completion: @escaping STPErrorBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString), let customerID = customerID else {
            if let token = source as? STPToken, let card = token.card {
                self.sources.append(card)
                self.defaultSource = card
            }
            completion(nil)
            return
        }
        let path = "\(backendURI)/customer/sources"
        let url = baseURL.appendingPathComponent(path)
        let params = [
            "customer_id": customerID,
            "source": source.stripeID,
            ]
        let request = URLRequest.request(url, method: .POST, params: params)
        let task = self.session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error) {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }) 
        task.resume()
    }
    
    @objc func subscribeCustomer(_ source: STPSource, plan: String, completion: @escaping STPErrorBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString), let customerID = customerID else {
            if let token = source as? STPToken, let card = token.card {
                self.sources.append(card)
                self.defaultSource = card
            }
            completion(nil)
            return
        }
        let path = "\(backendURI)subscriptions"
        let url = baseURL.appendingPathComponent(path)
        let params = [
            "customer_id": customerID,
            "plan": plan,
            "stripe_token": source.stripeID,
            ]
        let request = URLRequest.request(url, method: .POST, params: params)
        let task = self.session.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error) {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }) 
        task.resume()
    }
    
}
