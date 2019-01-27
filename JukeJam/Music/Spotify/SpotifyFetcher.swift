//
//  SpotifyFetcher.swift
//  JukeJam
//
//  Created by Rena fortier on 1/21/19.
//  Copyright © 2019 Ben Fortier. All rights reserved.
//

import Foundation
import Spartan
class SpotifyFetcher: NSObject {
    
    
    var currentUserID: String!
    fileprivate var user: User!
    var currentSong: Song?
    override init(){
        super.init()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let auth = appDelegate.accessToken
        Spartan.authorizationToken = auth
        self.initUser()
        self.fetchAllMusic()
       
    }
    fileprivate func initUser(){
        let def = UserDefaults.standard
        let userData = def.object(forKey: "user") as? NSData
        if let user = userData {
            self.user = (NSKeyedUnarchiver.unarchiveObject(with: user as Data) as? User)!
        }
        print("User set", user.name)
    }
    fileprivate func fetchAllMusic(){
    _ = Spartan.getMe(success: { (user) in
    // Do something with the user object
    self.currentUserID = user.id as! String
        self.getPlaylists(userId: self.currentUserID)
    }, failure: { (error) in
    print("HERE failure", error)
    })
    }
   
    fileprivate func createSong(){
        
    }
    
    func getPlaylists(userId: Any ){
        var userId = userId as! String
        
        //Used to get information about playlsit
        _ = Spartan.getUsersPlaylists(userId: userId, limit: 20, offset: 0, success: { (pagingObject) in
//            pagingObject.items.forEach({ (playlist) in
                let playlistId = pagingObject.items[6].id as! String
            let user_playlist = Playlist(id: playlistId)
                
                _ = Spartan.getUsersPlaylist(userId: userId, playlistId: playlistId, fields: nil, market: .us, success: { (playlist) in
                    user_playlist.followers = playlist.followers.total
                    user_playlist.name = playlist.name
                    user_playlist.owner = playlist.owner
                    user_playlist.about = playlist.description
                    //Might be worth it to just have one image, because first appears to be biggest for all. Will test
                    user_playlist.cover? = playlist.images[0].url.toImage()
                    print("HERE cover: ",user_playlist.cover, playlist.images[0].url.toImage(), playlist.images[0].url)
//                    user_playlist.cover
                    //Used to get tracks from playlist
                    _ = Spartan.getPlaylistTracks(userId: userId, playlistId: playlistId, limit: 1, offset: 0, fields: nil, market: .us, success: { (pagingObject) in
                        //                    print("HERE success ful", pagingObject.items[0].track.name)
//                        pagingObject.items.forEach({ (track) in
                        
                           var track = pagingObject.items[0].track
                        var id = track?.id as! String
                            var title = track?.name
                            var duration = track?.durationMs
                            var artists: [Artist] = []
                            track?.artists.forEach({ (artist) in
                                let curArtist = Artist(id: artist.id as! String)
                                curArtist.name = artist.name
                                artists.append(curArtist)
                            })
//                            var cover = track?.album.images[0].url.toImage()
                            var album = Album(id: track?.album.id as! String)
                            album.name = track?.album.name
                            album.cover = track?.album.images[0].url.toImage()
                        let song = Song(id: id, title: title!, duration: duration!, artist: artists, album: album)
//                        })
                        
                    }, failure: { (error) in
                        print("Here failed" ,error)
                    })
                }, failure: { (error) in
                    print("HERE fail", error)
                })
            
           
//            })
        }, failure: { (error) in
            print("HERE fail",error)
        })
    }
}


