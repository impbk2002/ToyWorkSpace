//
//  URLSessionActor.swift
//  DemoToycraft
//
//  Created by pbk on 2022/05/10.
//

import Foundation
import Combine
import SwiftUI


let client:URLSession = {
    let config = URLSessionConfiguration.background(withIdentifier: "client")
    let queue = OperationQueue()
    queue.underlyingQueue = .global()
    let session = URLSession(configuration: config, delegate: URLSessionActor.shared, delegateQueue: queue)
    return session
}()


public actor URLSessionActor: NSObject, GlobalActor {
    public static let shared = URLSessionActor()
    let notificationCenter = NotificationCenter()
    private let notificationQueue:NotificationQueue
    let fileManger = FileManager()
    override init() {
        notificationQueue = .init(notificationCenter: notificationCenter)
        super.init()
    }
}

// MARK: URLSessionDelegate
extension URLSessionActor: URLSessionDelegate {
    nonisolated public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        let selector = #selector(URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:))
        let selName = NSStringFromSelector(selector)
        var userinfo = [AnyHashable:Any]()
        userinfo[NSUnderlyingErrorKey] = error
        let notification = Notification(name: .init(selName), object: session, userInfo: userinfo)
        notificationQueue.enqueue(notification, postingStyle: .whenIdle)
    }

//    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
//        switch challenge.protectionSpace.authenticationMethod {
//
//        case NSURLAuthenticationMethodClientCertificate:
//            break
//        case NSURLAuthenticationMethodNegotiate:
//            break
//        case NSURLAuthenticationMethodNTLM:
//            break
//        case NSURLAuthenticationMethodServerTrust:
//            break
//
//        case NSURLAuthenticationMethodDefault:
//            break
//        case NSURLAuthenticationMethodHTMLForm:
//            break
//        case NSURLAuthenticationMethodHTTPBasic:
//            break
//        case NSURLAuthenticationMethodHTTPDigest:
//            break
//
//
//
//        default:
//            break
//        }
//        let credential:URLCredential?
//        if let serverTrust = challenge.protectionSpace.serverTrust {
//            credential = .init(trust: serverTrust)
//        } else {
//            credential = challenge.proposedCredential
//        }
//        return (.useCredential, challenge.proposedCredential)
//    }

    nonisolated public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        let selector = #selector(URLSessionDelegate.urlSessionDidFinishEvents(forBackgroundURLSession:))
        let selName = NSStringFromSelector(selector)
        let notification = Notification(name: .init(selName), object: session, userInfo: nil)
        notificationQueue.enqueue(notification, postingStyle: .whenIdle)
    }
    
}

// MARK: URLSessionTaskDelegate
extension URLSessionActor: URLSessionTaskDelegate {
//    public func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest) async -> (URLSession.DelayedRequestDisposition, URLRequest?) {
//
//        return (.useNewRequest, request)
//    }
    

//    nonisolated public func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
//
//        completionHandler(.useNewRequest, request)
//    }
    
    nonisolated public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        let selector = #selector(URLSessionTaskDelegate.urlSession(_:taskIsWaitingForConnectivity:))
        let selName = NSStringFromSelector(selector)
        let userInfo = ["task": task]
        let notification = Notification(name: .init(selName), object: session, userInfo: userInfo)
        notificationQueue.enqueue(notification, postingStyle: .whenIdle)
        notificationQueue.enqueue(.init(name: .init(selName), object: task, userInfo: nil), postingStyle: .whenIdle)
    }
    
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest) async -> URLRequest? {
        
        return request
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        
        return (.useCredential , challenge.proposedCredential)
    }
    
    public func urlSession(_ session: URLSession, needNewBodyStreamForTask task: URLSessionTask) async -> InputStream? {
        let stream = InputStream()
        stream.delegate = self
        return stream
    }
    
    nonisolated public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
    
    nonisolated public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        
    }
    
    
    nonisolated public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
}

// MARK: StreamDelegate
extension URLSessionActor: StreamDelegate {
    
    nonisolated public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .endEncountered:
            break
        case .errorOccurred:
            break
        case .hasBytesAvailable:
            break
        case .openCompleted:
            break
        case .hasSpaceAvailable:
            break
        default:
            break
        }
    }
}

// MARK: URLSessionDataDelegate
extension URLSessionActor: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        .allow
    }

    nonisolated public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
    }

    nonisolated public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        
    }

    nonisolated public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        Task {
            await urlSession(session, dataTask: dataTask, didReceive: data)
        }
    }

    @nonobjc private func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) async {

    }
    
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse) async -> CachedURLResponse? {
        proposedResponse
    }
}

// MARK: URLSessionStreamDelegate
extension URLSessionActor: URLSessionStreamDelegate {
    nonisolated public func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {

    }
    
    nonisolated public func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        
    }
    
    nonisolated public func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        
    }
    
    nonisolated public func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        
    }
    
}

// MARK: URLSessionDownloadDelegate
extension URLSessionActor: URLSessionDownloadDelegate {
    nonisolated public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    nonisolated public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }

    nonisolated public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
}

// MARK: URLSessionWebSocketDelegate
extension URLSessionActor: URLSessionWebSocketDelegate {
    nonisolated public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
    }
    
    nonisolated public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
    }
}

public class SessionManager {
    let session:URLSession
    private let rootQueue = DispatchQueue(label: "SessionManager.URLSession.Delegate.root.queue")
    let progree:Progress
    init(configuration:URLSessionConfiguration) {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.underlyingQueue = rootQueue
        session = .init(configuration: configuration, delegate: URLSessionActor.shared, delegateQueue: operationQueue)
        progree = operationQueue.progress
    }
}


