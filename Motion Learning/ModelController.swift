//
//  ModelController.swift
//  Motion Learning
//
//  Created by Dominic Opitz on 18.09.16.
//  Copyright © 2016 Razorfish GmbH. All rights reserved.
//

import UIKit

protocol Page {
    var type: PageType { get }
}

enum PageType {
    case log, session, animation
}

class ModelController: NSObject, UIPageViewControllerDataSource {
    
    let pageData: [PageType] = [.log, .session, .animation]

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> UIViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }

        // Create a new view controller
        switch pageData[index] {
        case .log:
            return storyboard.instantiateViewController(withIdentifier: "LogViewController") as! LogViewController
        case .session:
            return storyboard.instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        case .animation:
            return storyboard.instantiateViewController(withIdentifier: "AnimationViewController") as! AnimationViewController
        }
    }

    func indexOfViewController(_ viewController: UIViewController) -> Int {
        // Return the index of the given data view controller.
        if let page = viewController as? Page {
            return pageData.index(of: page.type) ?? NSNotFound
        }
        
        return NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

// MARK: - Page Extensions

extension LogViewController: Page {
    var type: PageType { return .log }
}

extension SessionViewController: Page {
    var type: PageType { return .session }
}

extension AnimationViewController: Page {
    var type: PageType { return .animation }
}


