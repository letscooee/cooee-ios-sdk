//
//  DebugInfoViewController.swift
//  CooeeSDK
//
//  Created by Ashish Gaikwad on 22/08/22.
//

import Foundation
import SwiftUI
import UIKit

/**
 Show debug information for internal use only

 - Author: Ashish Gaikwad
 - Since: 1.3.17
 */
class DebugInfoViewController {
    // MARK: Lifecycle

    init(on viewController: UIViewController) {
        visibleViewController = viewController
        loadView()
    }

    // MARK: Internal

    let visibleViewController: UIViewController

    /**
     Loads SwiftUI view in current view controller
     */
    private func loadView() {
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        var debugView = DebugInfoUI(visibleViewController)
        debugView.viewToRemove = {
            parentView.removeFromSuperview()
        }
        let host = UIHostingController(rootView: debugView)
        guard let hostView = host.view else {
            CooeeFactory.shared.sentryHelper.capture(message: "Loading SwiftUI failed")
            return
        }
        hostView.insetsLayoutMarginsFromSafeArea = false
        hostView.translatesAutoresizingMaskIntoConstraints = false
        hostView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        hostView.backgroundColor = UIColor(hexString: "#6200ee")
        parentView.addSubview(hostView)
        visibleViewController.view.addSubview(parentView)
    }
}

/**
 SwiftUI which can be displayed to user

 - Author: Ashish Gaikwad
 - Since: 1.3.17
 */
struct DebugInfoUI: View {
    // MARK: Lifecycle

    init(_ visibleViewController: UIViewController) {
        self.visibleViewController = visibleViewController
        let date = Date()
        let calendar = Calendar.current

        let month = calendar.component(.month, from: date) + 10
        let minutes = calendar.component(.minute, from: date) + 10
        password = "\(minutes)\(month)"
        let debugInfoCollector = DebugInfoCollector()
        deviceInfo = debugInfoCollector.deviceInformation
        userInfo = debugInfoCollector.userInformation
    }

    // MARK: Internal

    @State var isUserAuthorisedPreviously: Bool = false
    @State var isSecured: Bool = true
    @State var textInput: String = ""

    let visibleViewController: UIViewController
    var deviceInfo: [DebugInformation]
    var userInfo: [DebugInformation]
    var viewToRemove: (() -> ())?
    let password: String
    var title: String = "Enter Password"

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                SwiftUI.Image(systemName: "multiply")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40, alignment: .center)
                        .font(.largeTitle)
                        .clipped()
                        .gesture(
                                TapGesture()
                                        .onEnded { _ in
                                            if let remove = viewToRemove {
                                                remove()
                                            }
                                        }
                        )
                Text("Debug Info")
                        .font(.title)
                        .foregroundColor(.white)
            }
                    .frame(width: UIScreen.main.bounds.width, height: 40, alignment: .leading)
                    .background(SwiftUI.Color(hex: "#6200ee"))
            if !isUserAuthorisedPreviously {
                ScrollView {
                    VStack {
                        VStack(alignment: .center) {
                            Text("Password Required to access screen")
                            ZStack(alignment: .trailing) {
                                Group {
                                    if isSecured {
                                        SecureField(title, text: $textInput)
                                                .keyboardType(.numberPad)
                                                .frame(width: UIScreen.main.bounds.width / 2, height: 40, alignment: .leading)
                                    } else {
                                        TextField(title, text: $textInput)
                                                .keyboardType(.numberPad)
                                                .frame(width: UIScreen.main.bounds.width / 2, height: 40, alignment: .leading)
                                    }
                                }
                                        .padding(.trailing, 32)

                                Button(action: {
                                    isSecured.toggle()
                                }) {
                                    SwiftUI.Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                            .accentColor(.gray)
                                }
                            }
                                    .padding(5)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.gray, lineWidth: 2)
                                    )

                            Button(action: {
                                if password == textInput {
                                    isUserAuthorisedPreviously = true
                                }
                            }, label: {
                                Text("Next").foregroundColor(.white)
                            })
                                    .frame(width: UIScreen.main.bounds.width / 3, height: 30, alignment: .center)

                                    .padding(5)
                                    .background(SwiftUI.Color(hex: "#6200ee"))
                                    .cornerRadius(16)

                        }
                                .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height - 40, alignment: .top)
                    }
                            .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height, alignment: .top)
                }
                        .padding(5)
                        .background(Color.white)
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Device Info")
                                .font(.title)
                                .bold()
                        ForEach(0..<deviceInfo.count, id: \.self) { index in
                            HStack(spacing: 20) {
                                Text("\(deviceInfo[index].key)")
                                        .frame(width: UIScreen.main.bounds.width / 3, height: 20, alignment: .leading)
                                Spacer()
                                Text("\(deviceInfo[index].value)")
                                        .lineLimit(1)
                            }
                                    .if(deviceInfo[index].sharable) {
                                        $0.gesture(
                                                TapGesture()
                                                        .onEnded { _ in
                                                            shareData(deviceInfo[index].value)
                                                        }
                                        )
                                    }
                            VStack {
                                Color.gray.frame(height: 1 / UIScreen.main.scale)
                            }
                        }
                        Text("User Info")
                                .font(.title)
                                .bold()
                        ForEach(0..<userInfo.count, id: \.self) { index in
                            HStack(spacing: 20) {
                                Text("\(userInfo[index].key)")
                                        .frame(width: UIScreen.main.bounds.width / 3, height: 20, alignment: .leading)
                                Spacer()
                                Text("\(userInfo[index].value)")
                                        .lineLimit(1)
                            }
                                    .if(userInfo[index].sharable) {
                                        $0.gesture(
                                                TapGesture()
                                                        .onEnded { _ in
                                                            shareData(userInfo[index].value)
                                                        }
                                        )
                                    }
                            VStack {
                                Color.gray.frame(height: 1 / UIScreen.main.scale)
                            }
                        }
                    }
                            .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height, alignment: .topLeading)
                }
                        .padding(5).background(Color.white)
            }
        }
    }

    /**
     Opens share dialog with provided content

     - Parameter shareContent: content be shared
     */
    func shareData(_ shareContent: String) {
        let activityVC = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}
