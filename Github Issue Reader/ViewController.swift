//
//  ViewController.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/30/22.
//

import UIKit

// 2 hours
class ViewController: UIViewController {

    // property creating a stackView (like a list) to organize the UI for the entire VC
    var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // text label
    var gitLabel: UILabel = {
        let label = UILabel()
        label.text = "GitHub Issue Viewer"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    // text label
    var gitSubLabel: UILabel = {
        let label = UILabel()
        label.text = "View issues in a repository:"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .systemGray
        return label
    }()
    
    // text label
    var orgLabel: UILabel = {
        let label = UILabel()
        label.text = "Organization"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    // text label
    var repoLabel: UILabel = {
        let label = UILabel()
        label.text = "Repository"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    // text input (User interactive)
    var orgTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter an organization"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    // text input (User interactive)
    var repoTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a repository"
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    // a button (User interactive)
    lazy var submitButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "View Issues"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        config.cornerStyle = .capsule
        button.configuration = config
        // This is telling the button what to do once it's been tapped. It's going to run the fetchIssues function
        button.addTarget(self, action: #selector(fetchIssues), for: .touchUpInside)
        return button
    }()

    // this function is essentially running all the other functions/ui to present in our VC
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        
        // AUTO SET UP TYPE TEXT WHEN LAUNCH
        orgTextfield.text = "Apple"
        repoTextfield.text = "Swift"
        
        setupUI()
        activateIndicator()
    }
    
    // this is a catch all func to handle constraints etc.
    func setupUI() {
        // simple declaration for a reusable value. Streamlined here for code readability and easy debugging
        let standardPadding: CGFloat = 20
        
        // I actually can't tell why this line of code is here or where it's relevant so I commented it out. The title of the submit button is declared up in the original property.
        // submitButton.titleLabel?.text = "Submit"
        
        //connecting all the UI to the containerView stack (in order of appearance, with some spacing added)
        containerView.addArrangedSubview(gitLabel)
        containerView.addArrangedSubview(gitSubLabel)
        containerView.setCustomSpacing(standardPadding, after: gitSubLabel)
        containerView.addArrangedSubview(orgLabel)
        containerView.addArrangedSubview(orgTextfield)
        containerView.addArrangedSubview(repoLabel)
        containerView.addArrangedSubview(repoTextfield)
        containerView.setCustomSpacing(standardPadding, after: repoTextfield)
        containerView.addArrangedSubview(submitButton)
        
        // adding all the containerViews from above to the VC 
        view.addSubview(containerView)
        
        // pinning it to the view so it doesn't float around and explode
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func fetchIssues() {
        
        // asking for the text fields input from above to turn into actual text to look up
        let organization = orgTextfield.text
        let repo = repoTextfield.text
        
        // make sure it's not gonna break in a nil return
        guard let organization = organization, let repo = repo else {
            return
        }
        
        // while it's loading here is a cute UI thing to tell you the networking call is happening from "now" up to 5 seconds after launching the call which will make it time out and quits/crashes
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // pulling in the IssueViewModel into this file to manipulate data within it.
            let viewModel = IssueViewModel()
            // pulling the fetchIssues from the VM
            // making the repo and organization fill in for the conditionals on the fetchIssues func from the VM
            viewModel.fetchIssues(for: organization, repo: repo) { [self] issues in
                print("Successfully received issues.")
                
                // pulling in the fileIssuesCollectionVC and filling in the conditional of the VM (IssueViewModel)
                let issuesVC = IssuesCollectionVC(viewModel: viewModel)
                // assigning it to be the next view in the chain of events in the navController and animate the presentation.
                navigationController?.pushViewController(issuesVC, animated: true)
                // once the new viewController has been pushed through after the networking call make the activity loading stop showing.
                activityIndicator.stopAnimating()
            }
        }
    }
    // a basic property declaration of the loading UI is going to be called this and look like this... (more clarification of specifics to come in func below)
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func activateIndicator() {
        // create a variable to hold an empty view for us to modify
        let container = UIView()
        // giving the view space guidelines to work within
        container.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        // slap that activity thing in the center of itself
        activityIndicator.center = self.view.center
        
        // put the activity UI into the empty UIView
        container.addSubview(activityIndicator)
        // adding the container to the view of the ViewController
        self.view.addSubview(container)
    }
    
}

