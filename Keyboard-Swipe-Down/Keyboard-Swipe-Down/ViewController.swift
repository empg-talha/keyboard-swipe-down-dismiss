//
//  ViewController.swift
//  Keyboard-Swipe-Down
//
//  Created by Talha Ahmad Khan on 12/03/2025.
//

import UIKit

class CustomInputAccessoryView: UIView {
  
  var customContentHeight: CGFloat = 0 {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    let totalHeight = self.customContentHeight
    return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight) // Adjust height as needed
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let tableView = UITableView()
  
  override var inputAccessoryView: UIView? {
    return inputBarContainerView
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  private lazy var inputBarContainerView: UIView = {
    let view = CustomInputAccessoryView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.customContentHeight = 70
    return view
  }()
  
  private lazy var inputBarView: UIView = {
    return createPaddedTextField()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    addKeyboardObservers()
  }
  
  deinit {
    removeKeyboardObservers()
  }
  
  private func setupUI() {
    title = "Test Controller"
    view.backgroundColor = .white
    
    // Setup TableView
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.keyboardDismissMode = .interactive
    
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.transform = CGAffineTransformMakeScale(1, -1)
    inputBarContainerView.addSubview(inputBarView)
    // Constraints for TableView
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      inputBarView.leadingAnchor.constraint(equalTo: inputBarContainerView.leadingAnchor, constant: 10),
      inputBarView.trailingAnchor.constraint(equalTo: inputBarContainerView.trailingAnchor, constant: -10),
      inputBarView.topAnchor.constraint(equalTo: inputBarContainerView.topAnchor, constant: 10),
      inputBarView.bottomAnchor.constraint(lessThanOrEqualTo: inputBarContainerView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
    ])
    
  }
  
  private func addKeyboardObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func removeKeyboardObservers() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? -1
    debugPrint("+++ keyboardWillShow \(keyboardHeight)")
    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
      debugPrint("Keyboard Height (Showing): \(keyboardFrame.height)")
      let currentContentOffset = self.tableView.contentOffset.y
      let keyboardHeight = keyboardFrame.height
      self.tableView.contentInset = .init(top: keyboardHeight, left: 0, bottom: 0, right: 0)
      let newContentOffset = currentContentOffset - keyboardHeight
      self.tableView.contentOffset = .init(x: 0, y: newContentOffset)
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? -1
    debugPrint("+++ keyboardWillHide \(keyboardHeight)")
    self.tableView.contentInset = .zero
  }
  
  // MARK: - TableView DataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 200  // Example rows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.contentView.transform = CGAffineTransformMakeScale(1, -1)
    cell.accessoryView?.transform = CGAffineTransformMakeScale(1, -1)
    cell.textLabel?.text = "Row \(indexPath.row + 1)"
    return cell
  }
  
  // MARK: - Function to Create a Padded TextField
  
  func createPaddedTextField() -> UIView {
    let containerView = UIView()
    containerView.backgroundColor = .lightGray
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    let textField = UITextField()
    textField.placeholder = "Enter text"
    textField.borderStyle = .none
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    containerView.addSubview(textField)
    
//    let textField = UITextView()
//    textField.text = "Sample text"
//    textField.textContainerInset = .zero
//    textField.translatesAutoresizingMaskIntoConstraints = false
//    textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//    textField.isUserInteractionEnabled = true
//    containerView.addSubview(textField)
    
    // Constraints for TextField (10pts padding from all sides)
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
      textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
      textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
      textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
    ])
    
    return containerView
  }
}
