//
//  PoliticoAPI.swift
//  PoliticsApp
//
//  Created by Benjamin Rogers on 8/2/23.
//

import Foundation
import UIKit

// Class for accessing ProPublicas Congress API
// APIKEY stored in Config.xcconfig -> info.plist files
class ProPublicaAPI {
    
    // General function to call API w/ completion handler for fetch functions & ~error handling~
    func callAPIWithKey(urlString: String, apiKey: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            if String(data: data, encoding: .utf8) != nil {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
            }
        }
        
        task.resume()
    }
    
    // Fetch recent 20 bills that were acted on
    // Still not exactly sure what conditions are met for records to show up in this endpoint... since there is also a recent bills endpoint. The recent bills endpoint requires you specify the type of update that occured rather than just grabbing the most recent 20 acted on. Worth looking into...
    // Docs: https://projects.propublica.org/api-docs/congress-api/bills/
    // ** Named "Search Bills" in docs
    // `Use this request to search the title and full text of legislation by keyword to get the 20 most recent bills. Searches cover House and Senate bills from the 113th Congress through the current Congress (117th). If multiple words are given (e.g. query=health care) the search is treated as multiple keywords using the OR operator. Quoting the words (e.g. query="health care") makes it a phrase search. Search results can be sorted by date (the default) or by relevance, and in ascending or descending order.`
    // Can further refine search with keyword query param for use in later views?
    // pageNum for paginated responses so feed can scroll endlessly.
    // Decode to Models in Models/Recent RecentBills -> RecentResults -> RecentBill
    func fetchAPIBillsSearchData(query:String, pageNum: Int) -> RecentBills? {
        let queryString = "query=\(query)"
        let offsetString = "offset=\(pageNum * 20)"
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
        let apiUrl = "https://api.propublica.org/congress/v1/bills/search.json?\(queryString)&\(offsetString)"
        let semaphore = DispatchSemaphore(value: 0)
        var upcomingBills: RecentBills?
        
        if apiKey != "" {
            callAPIWithKey(urlString: apiUrl, apiKey: apiKey) {result in
                switch result {
                case .success(let jsonData):
                    let decoder = JSONDecoder()
                    upcomingBills = try! decoder.decode(RecentBills.self, from:jsonData)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        return upcomingBills
    }
    
    // Fetch specific Bill using bill slug
    // Docs: https://projects.propublica.org/api-docs/congress-api/bills/
    // ** named "Get a Specific Bill"
    // `Use this request type to get details about a particular bill, including actions taken and votes. The attributes house_passage_vote and senate_passage_vote are populated (with the date of passage) only upon successful passage of the bill. Bills before the 113th Congress (prior to 2013) have fewer attribute values than those from the 113th Congress onward, because the more recent bill data comes from the bulk data provided by the Government Publishing Office. Details for the older bills came from scraping Thomas.gov, the former congressional site of the Library of Congress.`
    // Decode to Models in Models/Specific SpecificBills -> SpecificBill -> SpecificBillVotes
    //                                                             -> SpecificBillAction
    // Used in Views SpecificBillView
    func fetchAPIBillsSpecific(congressSession: Int, billSlug: String) -> SpecificBills? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
        let apiUrl = "https://api.propublica.org/congress/v1/\(congressSession)/bills/\(billSlug).json"
        var specificResults: SpecificBills?
        let semaphore = DispatchSemaphore(value: 0)
        
        if apiKey != "" {
            callAPIWithKey(urlString: apiUrl, apiKey: apiKey) {result in
                switch result {
                case .success(let jsonData):
                    let decoder = JSONDecoder()
                    specificResults = try! decoder.decode(SpecificBills.self, from:jsonData)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        
        return specificResults
    }
    func fetchAPIRollCallVoteSpecific(apiUrl: String) -> SpecificRollCall? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
        var specificRollCallVote: SpecificRollCall?
        let semaphore = DispatchSemaphore(value: 0)
        
        if apiKey != "" {
            callAPIWithKey(urlString: apiUrl, apiKey: apiKey) {result in
                switch result {
                case .success(let jsonData):
                    let decoder = JSONDecoder()
                    specificRollCallVote = try! decoder.decode(SpecificRollCall.self, from:jsonData)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        
        return specificRollCallVote
    }
    
    func  fetchAPIBillsRecent(congressSession: Int, chamber: String, type: String, pageNum: Int) -> RecentBills? {
        let offsetString = "offset=\(pageNum * 20)"
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
        let apiUrl = "https://api.propublica.org/congress/v1/\(congressSession)/\(chamber)/bills/\(type).json?\(offsetString)"
        print(apiUrl)
        let semaphore = DispatchSemaphore(value: 0)
        var upcomingBills: RecentBills?
        
        if apiKey != "" {
            callAPIWithKey(urlString: apiUrl, apiKey: apiKey) {result in
                switch result {
                case .success(let jsonData):
                    print(jsonData)
                    let decoder = JSONDecoder()
                    upcomingBills = try! decoder.decode(RecentBills.self, from:jsonData)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        return upcomingBills
    }
}
