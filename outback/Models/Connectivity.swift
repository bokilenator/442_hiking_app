//
//  Connectivity.swift
//  outback
//
//  Created by Karan Bokil on 12/6/18.
//  Copyright © 2018 Karan Bokil. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
  class func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
  }
}
