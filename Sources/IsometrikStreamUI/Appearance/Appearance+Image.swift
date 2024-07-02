//
//  Appearance+Icons.swift
//  isometrik-livestream
//
//  Created by Appscrip 3Embed on 27/06/24.
//

import UIKit

public struct ISM_Image {
    
    private static func loadImageSafely(with imageName: String) -> UIImage {
        if let image = UIImage(named: imageName, in: .isometrikStreamBundle) {
            return image
        } else {
            print(
                """
                \(imageName) image has failed to load from the bundle please make sure it's included in your assets folder.
                A default 'red' circle image has been added.
                """
            )
            return UIImage()
        }
    }
    
    private static func loadSafely(systemName: String, assetsFallback: String) -> UIImage {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: systemName) ?? loadImageSafely(with: assetsFallback)
        } else {
            return loadImageSafely(with: assetsFallback)
        }
    }
    
    // create stream icons
    public var camera: UIImage = loadImageSafely(with: "ic_camera")
    public var cancel: UIImage = loadImageSafely(with: "ic_cancel")
    public var checkBoxSelected: UIImage = loadImageSafely(with: "ic_checkbox_selected")
    public var checkBoxUnselected: UIImage = loadImageSafely(with: "ic_checkbox_Unselected")
    public var close: UIImage = loadImageSafely(with: "ic_close")
    public var gallery: UIImage = loadImageSafely(with: "ic_gallery")
    public var item: UIImage = loadImageSafely(with: "ic_item")
    public var next: UIImage = loadImageSafely(with: "ic_next")
    public var plus: UIImage = loadImageSafely(with: "ic_plus")
    public var radioSelected: UIImage = loadImageSafely(with: "ic_radio_selected")
    public var radioUnSelected: UIImage = loadImageSafely(with: "ic_radio_unselected")
    public var userPrivacy: UIImage = loadImageSafely(with: "ic_user_privacy")
    public var vendor: UIImage = loadImageSafely(with: "ic_vendor")
    
    
    // gift icons
    public var coin: UIImage = loadImageSafely(with: "ic_coin")
    public var giftPlaceholder: UIImage = loadImageSafely(with: "ic_gift_placeholder")
    
    // go live icons
    public var arrowDown: UIImage = loadImageSafely(with: "ic_arrow_down")
    public var arrowRight: UIImage = loadImageSafely(with: "ic_arrow_right")
    public var calendar: UIImage = loadImageSafely(with: "ic_calendar")
    public var close2: UIImage = loadImageSafely(with: "ic_close2")
    public var golive: UIImage = loadImageSafely(with: "ic_golive")
    public var schedule2: UIImage = loadImageSafely(with: "ic_schedule2")
    public var copyLink: UIImage = loadImageSafely(with: "ism_copy_link")
    
    public var instagramLogo: UIImage = loadImageSafely(with: "ism_instagram_logo")
    public var twitchLogo: UIImage = loadImageSafely(with: "ism_twitch_logo")
    public var youtubeLogo: UIImage = loadImageSafely(with: "ism_youtube_logo")
    
    public var toggleOffDark: UIImage = loadImageSafely(with: "ism_toggle_off_dark")
    public var toggleOff: UIImage = loadImageSafely(with: "ism_toggle_off")
    public var toggleOnDark: UIImage = loadImageSafely(with: "ism_toggle_on_dark")
    public var toggleOn: UIImage = loadImageSafely(with: "ism_toggle_on")
    
    // pk icons
    public var joinStream: UIImage = loadImageSafely(with: "ic_join_stream")
    public var winnersCup: UIImage = loadImageSafely(with: "ism_cup")
    public var guestRing: UIImage = loadImageSafely(with: "ism_guest_ring")
    public var hostRing: UIImage = loadImageSafely(with: "ism_host_ring")
    public var linking: UIImage = loadImageSafely(with: "ism_linking")
    public var pkDraw: UIImage = loadImageSafely(with: "ism_pk_draw")
    public var pkHostToggle: UIImage = loadImageSafely(with: "ism_pk_hostToggle")
    public var pkLoser: UIImage = loadImageSafely(with: "ism_pk_loser")
    public var pkStart: UIImage = loadImageSafely(with: "ism_pk_start")
    public var pkWinner: UIImage = loadImageSafely(with: "ism_pk_winner")
    public var battleGuestBackground: UIImage = loadImageSafely(with: "ism_pkbattle_anim_guest")
    public var battleHostBackground: UIImage = loadImageSafely(with: "ism_pkbattle_anim_host")
    public var battleTimerOverlay: UIImage = loadImageSafely(with: "ism_timer_container")
    public var battleVsLogo: UIImage = loadImageSafely(with: "ism_vs")
    public var pkLogo: UIImage = loadImageSafely(with: "ism_pk")
    public var stopPK: UIImage = loadImageSafely(with: "ism_stop_pk")
    public var endPK: UIImage = loadImageSafely(with: "ism_end_pk")
    public var bulb: UIImage = loadImageSafely(with: "ic_bulb")
    
    // MARK: STREAM
    
    // analytics
    public var durationStat: UIImage = loadImageSafely(with: "ic_duration_stat")
    public var earningStat: UIImage = loadImageSafely(with: "ic_earning_stat")
    public var followersStat: UIImage = loadImageSafely(with: "ic_followers_stat")
    public var heartStat: UIImage = loadImageSafely(with: "ic_heart_stat")
    public var orderStat: UIImage = loadImageSafely(with: "ic_order_stat")
    public var sellingQtyStat: UIImage = loadImageSafely(with: "ic_sellingQty_stat")
    public var viewerStat: UIImage = loadImageSafely(with: "ic_viewer_stat")
    
    // follow
    public var follow: UIImage = loadImageSafely(with: "ism_follow")
    public var following: UIImage = loadImageSafely(with: "ism_following")
    public var requested: UIImage = loadImageSafely(with: "ism_requested")
    
    // stream options
    public var analytics: UIImage = loadImageSafely(with: "ic_analytics")
    public var audioMuted: UIImage = loadImageSafely(with: "ic_audio_muted")
    public var audioUnmuted: UIImage = loadImageSafely(with: "ic_audio_unmuted")
    public var flipCamera: UIImage = loadImageSafely(with: "ic_flip_camera")
    public var heart: UIImage = loadImageSafely(with: "ic_heart")
    public var muted: UIImage = loadImageSafely(with: "ic_mic_muted")
    public var micUnmuted_op: UIImage = loadImageSafely(with: "ic_mic_unmuted_op")
    public var micUnmuted: UIImage = loadImageSafely(with: "ic_mic_unmuted")
    public var more1: UIImage = loadImageSafely(with: "ic_more")
    public var reaction: UIImage = loadImageSafely(with: "ic_reaction")
    public var requestList: UIImage = loadImageSafely(with: "ic_request_list")
    public var request: UIImage = loadImageSafely(with: "ic_request")
    public var setting: UIImage = loadImageSafely(with: "ic_setting")
    public var share1: UIImage = loadImageSafely(with: "ic_share")
    public var store: UIImage = loadImageSafely(with: "ic_store")
    public var wallet: UIImage = loadImageSafely(with: "ic_wallet")
    public var add: UIImage = loadImageSafely(with: "ism_add")
    public var gift: UIImage = loadImageSafely(with: "ism_gift")
    public var more2: UIImage = loadImageSafely(with: "ism_more")
    public var product: UIImage = loadImageSafely(with: "ism_product")
    public var share2: UIImage = loadImageSafely(with: "ism_share")
    public var groupInvite: UIImage = loadImageSafely(with: "ism_group_invite")
    
    // general icons
    public var back: UIImage = loadImageSafely(with: "ic_back")
    public var cameraPlaceholder: UIImage = loadImageSafely(with: "ic_camera_placeholder")
    public var checkedCheckbox: UIImage = loadImageSafely(with: "ic_checked_checkbox")
    public var diamond: UIImage = loadImageSafely(with: "ic_diamond")
    public var doubleArrow: UIImage = loadImageSafely(with: "ic_double_arrow")
    public var emoji: UIImage = loadImageSafely(with: "ic_emoji_button")
    public var eye: UIImage = loadImageSafely(with: "ic_eye")
    public var rsvpUser: UIImage = loadImageSafely(with: "ic_rsvp_user")
    public var search: UIImage = loadImageSafely(with: "ic_search")
    public var send: UIImage = loadImageSafely(with: "ic_send_button")
    public var timer: UIImage = loadImageSafely(with: "ic_timer")
    public var uncheckedCheckbox: UIImage = loadImageSafely(with: "ic_uncheck_checkbox")
    public var userStatus: UIImage = loadImageSafely(with: "ic_user_status")
    public var viewers: UIImage = loadImageSafely(with: "ic_viewer_count")
    public var block: UIImage = loadImageSafely(with: "ism_block")
    public var videoCameraOff: UIImage = loadImageSafely(with: "ism_camera_off")
    public var videoCamera: UIImage = loadImageSafely(with: "ism_camera")
    public var live: UIImage = loadImageSafely(with: "ism_live")
    public var message: UIImage = loadImageSafely(with: "ism_message")
    public var moderator: UIImage = loadImageSafely(with: "ism_moderator")
    public var noViewers: UIImage = loadImageSafely(with: "ism_no_viewers")
    public var percentage: UIImage = loadImageSafely(with: "ism_percentage")
    public var play: UIImage = loadImageSafely(with: "ism_play")
    public var replay: UIImage = loadImageSafely(with: "ism_replay")
    public var report: UIImage = loadImageSafely(with: "ism_report")
    public var removeCircle: UIImage = loadImageSafely(with: "ism_round_remove_circle")
    public var speakerOff: UIImage = loadImageSafely(with: "ism_speaker_off")
    public var speakerOn: UIImage = loadImageSafely(with: "ism_speaker")
    public var user: UIImage = loadImageSafely(with: "ism_user")
    
    
    // Message events
    public var deletedMsg: UIImage = loadImageSafely(with: "ism_del_msg")
    public var userLeft: UIImage = loadImageSafely(with: "ism_user_left")
    public var userKickedOut: UIImage = loadImageSafely(with: "ism_user_kickedOut")
    public var kickout: UIImage = loadImageSafely(with: "ism_kickout")
    public var userJoined: UIImage = loadImageSafely(with: "ism_user_joined")
    
    public init() {}
    
}
