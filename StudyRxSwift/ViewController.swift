//
//  ViewController.swift
//  StudyRxSwift
//
//  Created by Cecilia Andrea Pesce on 10/02/24.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    //nessa variável items que estão sendo guardados os products
    var items = PublishSubject<[Product]>()

    func fetchItems() {
        let products = [
        Product(imageName: "house", title: "Home"),
        Product(imageName: "gear", title: "Settings"),
        Product(imageName: "person.circle", title: "Profile"),
        Product(imageName: "airplane", title: "Flights"),
        Product(imageName: "bell", title: "Activity")
        ]
        
        // notifica os observadores sobre a próxima emissão (onNext) e completa a sequência (onCompleted).
        items.onNext(products)
        items.onCompleted()

    }
}

class ViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    func bindTableData() {
        //Bind items to the table
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        //Bind the model selected handler
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        //Fetch items
        viewModel.fetchItems()
    }
}

