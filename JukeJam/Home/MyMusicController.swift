import UIKit
import FBSDKLoginKit
import FacebookLogin
import MediaPlayer
import FirebaseAuth
import SCLAlertView
import SPStorkController

class MyMusicController: UIViewController, UICollectionViewDelegate{
    
    @IBOutlet weak var playlists: UICollectionView!
    @IBOutlet  var songs: UICollectionView!
    @IBOutlet weak var artists: UICollectionView!
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
        //      scroll.contentSize = CGSize(width: self.view.frame.width, height: 1300)
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
        playlists.dataSource = self
        songs.dataSource = self
        artists.dataSource = self
        playlists.delegate = self
        songs.delegate = self
        artists.delegate = self
        playlists.establishDivCells()
        songs.establishDivCells()
        artists.establishDivCells()
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
        
        case "Playlists":
            DestViewController.myTitle = "My Playlists"
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
}

extension MyMusicController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            var identifier: String = ""
            switch collectionView {
                
            case self.playlists:
                identifier = "PlaylistCell"
                break
                
            case self.songs:
                identifier = "SongCell"
                break
                
            case self.artists:
                identifier = "ArtistCell"
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {


        case self.songs:
            if let modal: SongController = storyboard?.instantiateViewController(withIdentifier: "SongController") as? SongController {
                let transitionDelegate = SPStorkTransitioningDelegate()
                transitionDelegate.isSwipeToDismissEnabled = true
                transitionDelegate.isTapAroundToDismissEnabled = true
                modal.transitioningDelegate = transitionDelegate
                modal.modalPresentationStyle = .custom
                modal.coverImage = myJamsArt[indexPath.item].image
                modal.songText = myJamsArt[indexPath.item].title
                modal.moreText = "\(myJamsArt[indexPath.item].title!) - \(myJamsArt[indexPath.item].author!)"
                print("HERE why taking so long", modal.songText)

                present(modal, animated: true, completion: nil)
            }
            
            break

        default:
            break
        }
    }

    
}
