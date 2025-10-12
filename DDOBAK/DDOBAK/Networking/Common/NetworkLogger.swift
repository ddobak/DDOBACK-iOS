import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "network.logger.queue")

    func requestDidResume(_ request: Request) {
        print("➡️ [REQ] \(request.description)")
        if let headers = request.request?.allHTTPHeaderFields { print("   headers: \(headers)") }
        if let bodyData = request.request?.httpBody, let body = String(data: bodyData, encoding: .utf8) { print("   body: \(body)") }
    }

    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        let status = response.response?.statusCode ?? -1
        print("⬅️ [RES] status: \(status), for: \(request.description)")
        if let data = response.data, let body = String(data: data, encoding: .utf8) { print("   body: \(body)") }
        if let error = response.error { print("   error: \(error)") }
    }
}
