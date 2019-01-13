import UIKit
import FBSDKLoginKit
import FacebookLogin
import MediaPlayer
import FirebaseAuth
import SCLAlertView

class HomeController: UIViewController, UICollectionViewDelegate{

    @IBOutlet weak var friendsJams: UICollectionView!
    @IBOutlet  var myJamsCarousal: UICollectionView!
    @IBOutlet weak var featuredJams: UICollectionView!
    @IBOutlet weak var scroll: UIScrollView!
    var myJamsArt: [coverArt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempLoadData()
        customizeButtons()
        establishCells()
    }
    override func viewWillLayoutSubviews(){
            super.viewWillLayoutSubviews()
          scroll.contentSize = CGSize(width: self.view.frame.width, height: 1300)
        }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tempLoadData(){
        myJamsArt.append(coverArt(title: "Baby Boy Blue", author: "Nirvana", image: UIImage(named: "album1")!))
        myJamsArt.append(coverArt(title: "Nothing Was the Same", author: "Drake", image: UIImage(named: "album2")!))
        myJamsArt.append(coverArt(title: "Astroworld", author: "Travis Scott", image: UIImage(named: "album3")!))
        myJamsArt.append(coverArt(title: "Kulture II", author: "Migos", image: UIImage(named: "album4")!))
        myJamsArt.append(coverArt(title: "The Life of Pablo", author: "Kanye West", image: UIImage(named: "album5")!))
    }
    
    func establishCells(){
        myJamsCarousal.dataSource = self
        featuredJams.dataSource = self
        friendsJams.dataSource = self
        myJamsCarousal.establishDivCells()
        featuredJams.establishDivCells()
        friendsJams.establishDivCells()
    }
    
    func customizeButtons(){
        self.navigationItem.leftBarButtonItem = getTabBarButton(type: .user, selector:#selector(showProfile))
        self.navigationItem.rightBarButtonItem = getTabBarButton(type: .cog, selector:#selector(showSettings))
    }
    @objc func showProfile(){
        print("Profile")
    }
    @objc func showSettings(){
        print("Settings")
    }

    @IBAction func testFunc(_ sender: UIButton) {
        let handler: AppleHandler = AppleHandler()
        //Checks to see if User has authorized
        //Put below in AppleHandler.play([ID]'s) function
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: SeeMoreController = segue.destination as! SeeMoreController
        switch segue.identifier {
        case "myJams":
            DestViewController.myTitle = "My Jams"
            break
            
        case "friendsJams":
            DestViewController.myTitle = "Friend's Jams"
            break
            
        case "featuredJams":
            DestViewController.myTitle = "Featured Jams"
            break
            
        default:
            break
        }
    }
    
    //Logs people out of their account
    @IBAction func logOut(_ sender: UIButton) {
        let tabbar = self.tabBarController as! ScreenController
        var mc = tabbar.MusicController
        print("HERE removing spothanlder:", mc?.musicHandler.spotifyHandler)
        mc?.musicHandler.spotifyHandler = nil
        mc?.musicHandler = nil
        mc?.dismiss(animated: true, completion: nil)
        logout()

    }
    

}

extension HomeController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var identifier: String = ""
        switch collectionView {
            
        case self.myJamsCarousal:
            identifier = "MyJamsCell"
            break
            
        case self.friendsJams:
            identifier = "FriendJams"
            break
            
        case self.featuredJams:
            identifier = "FeaturedJam"
            break
            
        default:
            break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FocalCell
        cell.coverArt = myJamsArt[indexPath.item]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myJamsArt.count
    }

}
