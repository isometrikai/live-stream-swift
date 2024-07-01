//
//  IsometrickErrorBuilder.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 10/11/22.
//

import Foundation

public final class IsometrikErrorBuilder {
    
    /*
    ** Account Id missing
    */
    private static  var IMERR_ACCOUNTID_MISSING = 101
    
    /*
    ** The constant IMERROBJ_ACCOUNTID_MISSING
    */
    public static var IMERROBJ_ACCOUNTID_MISSING = IsometrikError(remoteError: false, errorMessage: "Account id not configured".ism_localized + ".", isometrikErrorCode: IMERR_ACCOUNTID_MISSING)
    
    /*
    ** Project id missing
    */
    private static  var IMERR_PROJECTID_MISSING = 102
    
    /*
    ** The constant IMERROBJ_PROJECTID_MISSING
    */
    public static var IMERROBJ_PROJECTID_MISSING = IsometrikError(remoteError: false, errorMessage: "Project id not configured".ism_localized + ".", isometrikErrorCode: IMERR_PROJECTID_MISSING)
    
    /*
    ** Keyset id missing
    */
    private static  var IMERR_KEYSETID_MISSING = 103
    
    /*
    ** The constant IMERROBJ_ACCOUNTID_MISSING
    */
    public static var IMERROBJ_KEYSETID_MISSING = IsometrikError(remoteError: false, errorMessage: "Keyset id not configured".ism_localized + ".", isometrikErrorCode: IMERR_KEYSETID_MISSING)
    
    /*
    ** License key missing
    */
    private static  var IMERR_LICENSE_KEY_MISSING = 104
    
    /*
    ** The constant IMERROBJ_LICENSE_KEY_MISSING
    */
    public static var IMERROBJ_LICENSE_KEY_MISSING = IsometrikError(remoteError: false, errorMessage: "License key not configured".ism_localized + ".", isometrikErrorCode: IMERR_LICENSE_KEY_MISSING)
    
    /*
    ** Stream key missing
    */
    private static  var IMERR_STREAMID_MISSING = 105
    
    /*
    ** The constant IMERROBJ_STREAMID_MISSING
    */
    public static var IMERROBJ_STREAMID_MISSING = IsometrikError(remoteError: false, errorMessage: "Stream id is missing".ism_localized + ".", isometrikErrorCode: IMERR_STREAMID_MISSING)
    
    /*
    ** Member id missing
    */
    private static  var IMERR_MEMBERID_MISSING = 106
    
    /*
    ** The constant IMERROBJ_STREAMID_MISSING
    */
    public static var IMERROBJ_MEMBERID_MISSING = IsometrikError(remoteError: false, errorMessage: "Member id is missing".ism_localized + ".", isometrikErrorCode: IMERR_MEMBERID_MISSING)
    
    /*
    ** Viewer id missing
    */
    private static  var IMERR_VIEWERID_MISSING = 107
    
    /*
    ** The constant IMERROBJ_VIEWERID_MISSING
    */
    public static var IMERROBJ_VIEWERID_MISSING = IsometrikError(remoteError: false, errorMessage: "Viewer id is missing".ism_localized + ".", isometrikErrorCode: IMERR_VIEWERID_MISSING)
    
    /*
    ** Initiator id missing
    */
    private static  var IMERR_INITIATORID_MISSING = 108
    
    /*
    ** The constant IMERROBJ_INITIATORID_MISSING
    */
    public static var IMERROBJ_INITIATORID_MISSING = IsometrikError(remoteError: false, errorMessage: "Initiator id is missing".ism_localized + ".", isometrikErrorCode: IMERR_INITIATORID_MISSING)
    
    /*
    ** User id missing
    */
    private static  var IMERR_USERID_MISSING = 109
    
    /*
    ** The constant IMERROBJ_INITIATORID_MISSING
    */
    public static var IMERROBJ_USERID_MISSING = IsometrikError(remoteError: false, errorMessage: "User id is missing".ism_localized + ".", isometrikErrorCode: IMERR_USERID_MISSING)
    
    /*
    ** Sender id missing
    */
    private static  var IMERR_SENDERID_MISSING = 110
    
    /*
    ** The constant IMERROBJ_SENDERID_MISSING
    */
    public static var IMERROBJ_SENDERID_MISSING = IsometrikError(remoteError: false, errorMessage: "Sender id is missing".ism_localized + ".", isometrikErrorCode: IMERR_SENDERID_MISSING)
    
    /*
    ** Sender name missing
    */
    private static  var IMERR_SENDER_NAME_MISSING = 111
    
    /*
    ** The constant IMERROBJ_SENDER_NAME_MISSING
    */
    public static var IMERROBJ_SENDER_NAME_MISSING = IsometrikError(remoteError: false, errorMessage: "Sender name is missing.", isometrikErrorCode: IMERR_SENDER_NAME_MISSING)
    
    /*
    ** Sender identifier missing
    */
    private static  var IMERR_SENDER_IDENTIFIER_MISSING = 112
    
    /*
    ** The constant IMERROBJ_SENDER_IDENTIFIER_MISSING
    */
    public static var IMERROBJ_SENDER_IDENTIFIER_MISSING = IsometrikError(remoteError: false, errorMessage: "Sender identifier is missing.", isometrikErrorCode: IMERR_SENDER_IDENTIFIER_MISSING)
    
    /*
    ** Sender image missing
    */
    private static  var IMERR_SENDER_IMAGE_MISSING = 113
    
    /*
    ** The constant IMERROBJ_SENDER_IMAGE_MISSING
    */
    public static var IMERROBJ_SENDER_IMAGE_MISSING = IsometrikError(remoteError: false, errorMessage: "Sender image is missing.", isometrikErrorCode: IMERR_SENDER_IMAGE_MISSING)
    
    /*
    ** Message missing
    */
    private static  var IMERR_MESSAGE_MISSING = 114
    
    /*
    ** The constant IMERROBJ_MESSAGE_MISSING
    */
    public static var IMERROBJ_MESSAGE_MISSING = IsometrikError(remoteError: false, errorMessage: "Message is missing.", isometrikErrorCode: IMERR_MESSAGE_MISSING)
    
    /*
    ** Message type invalid value
    */
    private static  var IMERR_MESSAGE_TYPE_INVALID_VALUE = 115
    
    /*
    ** The constant IMERROBJ_MESSAGE_TYPE_INVALID_VALUE
    */
    public static var IMERROBJ_MESSAGE_TYPE_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Message type invalid value.", isometrikErrorCode: IMERR_MESSAGE_TYPE_INVALID_VALUE)
    
    /*
    ** Created by missing
    */
    private static  var IMERR_CREATED_BY_MISSING = 116
    
    /*
    ** The constant IMERROBJ_CREATED_BY_MISSING
    */
    public static var IMERROBJ_CREATED_BY_MISSING = IsometrikError(remoteError: false, errorMessage: "Created by is missing.", isometrikErrorCode: IMERR_CREATED_BY_MISSING)
    
    /*
    ** Stream image is missing
    */
    private static  var IMERR_STREAM_IMAGE_MISSING = 117
    
    /*
    ** The constant IMERROBJ_STREAM_IMAGE_MISSING
    */
    public static var IMERROBJ_STREAM_IMAGE_MISSING = IsometrikError(remoteError: false, errorMessage: "Stream image is missing.", isometrikErrorCode: IMERR_STREAM_IMAGE_MISSING)
    
    /*
    ** Stream description missing
    */
    private static  var IMERR_STREAM_DESCRIPTION_MISSING = 118
    
    /*
    ** The constant IMERROBJ_STREAM_DESCRIPTION_MISSING
    */
    public static var IMERROBJ_STREAM_DESCRIPTION_MISSING = IsometrikError(remoteError: false, errorMessage: "Stream description is missing.", isometrikErrorCode: IMERR_STREAM_DESCRIPTION_MISSING)
    
    /*
    ** Stream members missing
    */
    private static  var IMERR_STREAM_MEMBERS_MISSING = 119
    
    /*
    ** The constant IMERROBJ_STREAM_MEMBERS_MISSING
    */
    public static var IMERROBJ_STREAM_MEMBERS_MISSING = IsometrikError(remoteError: false, errorMessage: "Stream members are missing.", isometrikErrorCode: IMERR_STREAM_MEMBERS_MISSING)
    
    /*
    ** User name missing
    */
    private static  var IMERR_USERNAME_MISSING = 120
    
    /*
    ** The constant IMERROBJ_USERNAME_MISSING
    */
    public static var IMERROBJ_USERNAME_MISSING = IsometrikError(remoteError: false, errorMessage: "Username is missing.", isometrikErrorCode: IMERR_USERNAME_MISSING)
    
    /*
    ** User profile pic missing
    */
    private static  var IMERR_USER_PROFILEPIC_MISSING = 121
    
    /*
    ** The constant IMERROBJ_USER_PROFILEPIC_MISSING
    */
    public static var IMERROBJ_USER_PROFILEPIC_MISSING = IsometrikError(remoteError: false, errorMessage: "User profile pic is missing.", isometrikErrorCode: IMERR_USER_PROFILEPIC_MISSING)
    
    /*
    ** User identifier missing
    */
    private static  var IMERR_USER_IDENTIFIER_MISSING = 122
    
    /*
    ** The constant IMERROBJ_USER_IDENTIFIER_MISSING
    */
    public static var IMERROBJ_USER_IDENTIFIER_MISSING = IsometrikError(remoteError: false, errorMessage: "User identifier is missing.", isometrikErrorCode: IMERR_USER_IDENTIFIER_MISSING)
    
    /*
    ** Count invalid value
    */
    private static  var IMERR_COUNT_INVALID_VALUE = 123
    
    /*
    ** The constant IMERROBJ_COUNT_INVALID_VALUE
    */
    public static var IMERROBJ_COUNT_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Count has invalid value.", isometrikErrorCode: IMERR_COUNT_INVALID_VALUE)

    /*
    ** Count invalid value
    */
    private static  var IMERR_PAGE_TOKEN_INVALID_VALUE = 124
    
    /*
    ** The constant IMERROBJ_PAGE_TOKEN_INVALID_VALUE
    */
    public static var IMERROBJ_PAGE_TOKEN_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Page token has invalid value.", isometrikErrorCode: IMERR_PAGE_TOKEN_INVALID_VALUE)
    
    /*
    ** User name invalid value
    */
    private static  var IMERR_USERNAME_INVALID_VALUE = 125
    
    /*
    ** The constant IMERROBJ_USERNAME_INVALID_VALUE
    */
    public static var IMERROBJ_USERNAME_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Username has invalid value.", isometrikErrorCode: IMERR_USERNAME_INVALID_VALUE)
    
    /*
    ** User profile invalid value
    */
    private static  var IMERR_USER_PROFILEPIC_INVALID_VALUE = 126
    
    /*
    ** The constant IMERROBJ_USER_PROFILEPIC_INVALID_VALUE
    */
    public static var IMERROBJ_USER_PROFILEPIC_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "User profile pic has invalid value.", isometrikErrorCode: IMERR_USER_PROFILEPIC_INVALID_VALUE)
    
    /*
    ** User identifier invalid value
    */
    private static  var IMERR_USER_IDENTIFIER_INVALID_VALUE = 127
    
    /*
    ** The constant IMERROBJ_USER_IDENTIFIER_INVALID_VALUE
    */
    public static var IMERROBJ_USER_IDENTIFIER_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "User identifier has invalid value.", isometrikErrorCode: IMERR_USER_IDENTIFIER_INVALID_VALUE)
    
    
    /*
    ** Not Found
    */
    private static var IMERR_NOT_FOUND = 128
    
    /*
    ** Forbidden
    */
    private static var IMERR_FORBIDDEN = 129
    
    /*
    ** Service unavailable
    */
    private static var IMERR_SERVICE_UNAVAILABLE = 130
    
    /*
    ** Conflict
    */
    private static var IMERR_CONFLICT = 131
    
    /*
    ** Unprocessable entity
    */
    private static var IMERR_UNPROCESSABLE_ENTITY = 132
    
    /*
    ** Bad gateway
    */
    private static var IMERR_BAD_GATEWAY = 133
    
    /*
    ** Internal server error
    */
    private static var IMERR_INTERNAL_SERVER_ERROR = 134
    
    /*
    ** Parsing error
    */
    private static var IMERR_PARSING_ERROR = 135
    
    /*
    ** Network error
    */
    private static var IMERR_NETWORK_ERROR = 136
    
    /*
    ** Bad Request error
    */
    private static var IMERR_BAD_REQUEST_ERROR = 137
    
    /*
    ** ClientId missing
    */
    private static var IMERR_CLIENT_ID_MISSING = 138
    
    /*
    ** The constant IMERROBJ_CLIENT_ID_MISSING
    */
    public static var IMERROBJ_CLIENT_ID_MISSING = IsometrikError(remoteError: false, errorMessage: "Client id not configured.", isometrikErrorCode: IMERR_CLIENT_ID_MISSING)
    
    /*
    ** Is public missing
    */
    private static var IMERR_IS_PUBLIC_MISSING = 139
    
    /*
    ** The constant IMERROBJ_IS_PUBLIC_MISSING
    */
    public static var IMERROBJ_IS_PUBLIC_MISSING = IsometrikError(remoteError: false, errorMessage: "Is public stream missing.", isometrikErrorCode: IMERR_IS_PUBLIC_MISSING)
    
    /*
    ** Invalid value of streamType
    */
    private static var IMERR_STREAM_TYPE_INVALID_VALUE = 140
    
    /*
    ** The constant IMERROBJ_STREAM_TYPE_INVALID_VALUE
    */
    public static var IMERROBJ_STREAM_TYPE_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Is public stream missing.", isometrikErrorCode: IMERR_STREAM_TYPE_INVALID_VALUE)
    
    /*
    ** Missing value of streamType
    */
    private static var IMERR_STREAM_TYPE_MISSING = 141
    
    /*
    ** The constant IMERROBJ_STREAM_TYPE_MISSING
    */
    public static var IMERROBJ_STREAM_TYPE_MISSING = IsometrikError(remoteError: false, errorMessage: "Is public stream missing.", isometrikErrorCode: IMERR_STREAM_TYPE_MISSING)
    
    /*
    ** Missing value of audioOnly
    */
    private static var IMERR_AUDIO_ONLY_MISSING = 142
    
    /*
    ** The constant IMERROBJ_AUDIO_ONLY_MISSING
    */
    public static var IMERROBJ_AUDIO_ONLY_MISSING = IsometrikError(remoteError: false, errorMessage: "Audio only stream missing.", isometrikErrorCode: IMERR_AUDIO_ONLY_MISSING)
    
    /*
    ** User uid missing
    */
    private static var IMERR_UID_MISSING = 143
    
    /*
    ** The constant IMERROBJ_UID_MISSING
    */
    public static var IMERROBJ_UID_MISSING = IsometrikError(remoteError: false, errorMessage: "User uid is missing.", isometrikErrorCode: IMERR_UID_MISSING)

    
    /*
    ** Missing value of multiLive
    */
    private static var IMERR_MULTI_LIVE_MISSING = 144
    
    /*
    ** The constant IMERROBJ_MULTI_LIVE_MISSING
    */
    public static var IMERROBJ_MULTI_LIVE_MISSING = IsometrikError(remoteError: false, errorMessage: "Multi live stream missing.", isometrikErrorCode: IMERR_MULTI_LIVE_MISSING)
    
    /*
    ** Missing value of enableRecording
    */
    private static var IMERR_ENABLE_RECORDING_MISSING = 145
    
    /*
    ** The constant IMERROBJ_ENABLE_RECORDING_MISSING
    */
    public static var IMERROBJ_ENABLE_RECORDING_MISSING = IsometrikError(remoteError: false, errorMessage: "Enable recording missing.", isometrikErrorCode: IMERR_ENABLE_RECORDING_MISSING)
    
    /*
    ** Missing value of lowLatencyMode
    */
    private static var IMERR_LOW_LATENCY_MODE_MISSING = 146
    
    /*
    ** The constant IMERROBJ_LOW_LATENCY_MODE_MISSING
    */
    public static var IMERROBJ_LOW_LATENCY_MODE_MISSING = IsometrikError(remoteError: false, errorMessage: "Low latency mode missing.", isometrikErrorCode: IMERR_LOW_LATENCY_MODE_MISSING)
    
    /*
    ** Missing value of hdBroadcast
    */
    private static var IMERR_HD_BROADCAST_MISSING = 147
    
    /*
    ** The constant IMERROBJ_HD_BROADCAST_MISSING
    */
    public static var IMERROBJ_HD_BROADCAST_MISSING = IsometrikError(remoteError: false, errorMessage: "Hd broadcast missing.", isometrikErrorCode: IMERR_HD_BROADCAST_MISSING)
    
    /*
    ** Missing value of hdBroadcast
    */
    private static var IMERR_METADATA_MISSING = 148
    
    /*
    ** The constant IMERROBJ_METADATA_MISSING
    */
    public static var IMERROBJ_METADATA_MISSING = IsometrikError(remoteError: false, errorMessage: "Metadata missing.", isometrikErrorCode: IMERR_METADATA_MISSING)
    
    /*
    ** Missing value of restream
    */
    private static var IMERR_RESTREAM_MISSING = 149
    
    /*
    ** The constant IMERROBJ_RESTREAM_MISSING
    */
    public static var IMERROBJ_RESTREAM_MISSING = IsometrikError(remoteError: false, errorMessage: "Metadata missing.", isometrikErrorCode: IMERR_RESTREAM_MISSING)
    
    /*
    ** Channel id missing
    */
    private static var IMERR_CHANNELID_MISSING = 150
    
    /*
    ** The constant IMERROBJ_CHANNELID_MISSING
    */
    public static var IMERROBJ_CHANNELID_MISSING = IsometrikError(remoteError: false, errorMessage: "Channel id is missing.", isometrikErrorCode: IMERR_RESTREAM_MISSING)
    
    /*
    ** Channel name missing
    */
    private static var IMERR_CHANNEL_NAME_MISSING = 151
    
    /*
    ** The constant IMERROBJ_CHANNEL_NAME_MISSING
    */
    public static var IMERROBJ_CHANNEL_NAME_MISSING = IsometrikError(remoteError: false, errorMessage: "Channel name is missing.", isometrikErrorCode: IMERR_CHANNEL_NAME_MISSING)
    
    /*
    ** Channel type missing
    */
    private static var IMERR_CHANNEL_TYPE_MISSING = 152
    
    /*
    ** The constant IMERROBJ_CHANNEL_TYPE_MISSING
    */
    public static var IMERROBJ_CHANNEL_TYPE_MISSING = IsometrikError(remoteError: false, errorMessage: "Channel type is missing.", isometrikErrorCode: IMERR_CHANNEL_TYPE_MISSING)
    
    /*
    ** Ingest url missing
    */
    private static var IMERR_INGEST_URL_MISSING = 153
    
    /*
    ** The constant IMERROBJ_INGEST_URL_MISSING
    */
    public static var IMERROBJ_INGEST_URL_MISSING = IsometrikError(remoteError: false, errorMessage: "Ingest url is missing.", isometrikErrorCode: IMERR_INGEST_URL_MISSING)
    
    /*
    ** Restream enabled missing
    */
    private static var IMERR_RESTREAM_ENABLED_MISSING = 154
    
    /*
    ** The constant IMERROBJ_RESTREAM_ENABLED_MISSING
    */
    public static var IMERROBJ_RESTREAM_ENABLED_MISSING = IsometrikError(remoteError: false, errorMessage: "Enabled(restream) is missing.", isometrikErrorCode: IMERR_RESTREAM_ENABLED_MISSING)
    
    /*
    ** Channel name has invalid value
    */
    private static var IMERR_CHANNEL_NAME_INVALID_VALUE = 155
    
    /*
    ** The constant IMERROBJ_CHANNEL_NAME_INVALID_VALUE
    */
    public static var IMERROBJ_CHANNEL_NAME_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Channel name has invalid value.", isometrikErrorCode: IMERR_CHANNEL_NAME_INVALID_VALUE)
    
    /*
    ** Ingest url invalid value
    */
    private static var IMERR_INGEST_URL_INVALID_VALUE = 156
    
    /*
    ** The constant IMERROBJ_INGEST_URL_INVALID_VALUE
    */
    public static var IMERROBJ_INGEST_URL_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Ingest url has invalid value.", isometrikErrorCode: IMERR_INGEST_URL_INVALID_VALUE)
    
    /*
    ** Moderator id missing
    */
    private static var IMERR_MODERATORID_MISSING = 157
    
    /*
    ** The constant IMERROBJ_MODERATORID_MISSING
    */
    public static var IMERROBJ_MODERATORID_MISSING = IsometrikError(remoteError: false, errorMessage: "Moderator id is missing.", isometrikErrorCode: IMERR_MODERATORID_MISSING)
    
    /*
    ** Product id missing
    */
    private static var IMERR_PRODUCTID_MISSING = 158
    
    /*
    ** The constant IMERROBJ_PRODUCTID_MISSING
    */
    public static var IMERROBJ_PRODUCTID_MISSING = IsometrikError(remoteError: false, errorMessage: "Product id is missing.", isometrikErrorCode: IMERR_PRODUCTID_MISSING)
    
    /*
    ** Quantity missing
    */
    private static var IMERR_QUANTITY_MISSING = 159
    
    /*
    ** The constant IMERROBJ_QUANTITY_MISSING
    */
    public static var IMERROBJ_QUANTITY_MISSING = IsometrikError(remoteError: false, errorMessage: "Quantity is missing.", isometrikErrorCode: IMERR_QUANTITY_MISSING)
    
    /*
    ** Product name missing
    */
    private static var IMERR_PRODUCT_NAME_MISSING = 160
    
    /*
    ** The constant IMERROBJ_PRODUCT_NAME_MISSING
    */
    public static var IMERROBJ_PRODUCT_NAME_MISSING = IsometrikError(remoteError: false, errorMessage: "Product name is missing.", isometrikErrorCode: IMERR_PRODUCT_NAME_MISSING)
    
    /*
    ** Count missing
    */
    private static var IMERR_COUNT_MISSING = 161
    
    /*
    ** The constant IMERROBJ_COUNT_MISSING
    */
    public static var IMERROBJ_COUNT_MISSING = IsometrikError(remoteError: false, errorMessage: "Count is missing.", isometrikErrorCode: IMERR_COUNT_MISSING)
    
    /*
    ** External product id missing
    */
    private static var IMERR_EXTERNAL_PRODUCTID_MISSING = 162
    
    /*
    ** The constant IMERROBJ_EXTERNAL_PRODUCTID_MISSING
    */
    public static var IMERROBJ_EXTERNAL_PRODUCTID_MISSING = IsometrikError(remoteError: false, errorMessage: "External product id is missing.", isometrikErrorCode: IMERR_EXTERNAL_PRODUCTID_MISSING)
    
    /*
    ** Quantity invalid value
    */
    private static var IMERR_QUANTITY_INVALID_VALUE = 163
    
    /*
    ** The constant IMERROBJ_QUANTITY_INVALID_VALUE
    */
    public static var IMERROBJ_QUANTITY_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Quantity has invalid value.", isometrikErrorCode: IMERR_QUANTITY_INVALID_VALUE)
    
    /*
    ** id missing
    */
    private static var IMERR_CHECKOUT_SECRET_MISSING = 164
    
    /*
    ** The constant IMERROBJ_CHECKOUT_SECRET_MISSING
    */
    public static var IMERROBJ_CHECKOUT_SECRET_MISSING = IsometrikError(remoteError: false, errorMessage: "Checkout secret is missing.", isometrikErrorCode: IMERR_CHECKOUT_SECRET_MISSING)
    
    /*
    ** Product name has invalid value
    */
    private static var IMERR_PRODUCT_NAME_INVALID_VALUE = 165
    
    /*
    ** The constant IMERROBJ_PRODUCT_NAME_INVALID_VALUE
    */
    public static var IMERROBJ_PRODUCT_NAME_INVALID_VALUE = IsometrikError(remoteError: false, errorMessage: "Product name has invalid value.", isometrikErrorCode: IMERR_PRODUCT_NAME_INVALID_VALUE)
    
    /*
    ** Product and metadata both null
    */
    private static var IMERR_PRODUCT_NAME_METADATA_BOTH_NULL = 166
    
    /*
    ** The constant IMERROBJ_PRODUCT_NAME_METADATA_BOTH_NULL
    */
    public static var IMERROBJ_PRODUCT_NAME_METADATA_BOTH_NULL = IsometrikError(remoteError: false, errorMessage: "Atleast one of product name or metadata should be non-null.", isometrikErrorCode: IMERR_PRODUCT_NAME_METADATA_BOTH_NULL)
    
    /*
    ** Missing value of productsLinked
    */
    private static var IMERR_PRODUCTS_LINKED_MISSING = 167
    
    /*
    ** The constant IMERROBJ_PRODUCTS_LINKED_MISSING
    */
    public static var IMERROBJ_PRODUCTS_LINKED_MISSING = IsometrikError(remoteError: false, errorMessage: "Products linked missing.", isometrikErrorCode: IMERR_PRODUCTS_LINKED_MISSING)
    
    /*
    ** Missing value of productsIds
    */
    private static var IMERR_PRODUCT_IDS_MISSING = 168
    
    /*
    ** The constant IMERROBJ_PRODUCT_IDS_MISSING
    */
    public static var IMERROBJ_PRODUCT_IDS_MISSING = IsometrikError(remoteError: false, errorMessage: "Products ids are missing.", isometrikErrorCode: IMERR_PRODUCT_IDS_MISSING)
    
    /*
    ** Start featuring missing
    */
    private static var IMERR_START_FEATURING_MISSING = 169
    
    /*
    ** The constant IMERROBJ_START_FEATURING_MISSING
    */
    public static var IMERROBJ_START_FEATURING_MISSING = IsometrikError(remoteError: false, errorMessage: "Start featuring is missing.", isometrikErrorCode: IMERR_START_FEATURING_MISSING)
    
    /*
    ** Parent message id missing
    */
    private static var IMERR_PARENT_MESSAGE_ID_MISSING = 170
    
    /*
    ** The constant IMERROBJ_PARENT_MESSAGE_ID_MISSING
    */
    public static var IMERROBJ_PARENT_MESSAGE_ID_MISSING = IsometrikError(remoteError: false, errorMessage: "Parent message id is missing.", isometrikErrorCode: IMERR_PARENT_MESSAGE_ID_MISSING)
    
    /*
    ** Parent message sent at missing
    */
    private static var IMERR_PARENT_MESSAGE_SENT_AT_MISSING = 171
    
    /*
    ** The constant IMERROBJ_PARENT_MESSAGE_SENT_AT_MISSING
    */
    public static var IMERROBJ_PARENT_MESSAGE_SENT_AT_MISSING = IsometrikError(remoteError: false, errorMessage: "Parent message sent at is missing.", isometrikErrorCode: IMERR_PARENT_MESSAGE_SENT_AT_MISSING)
    
    /*
    ** Message sent at missing
    */
    private static var IMERR_MESSAGE_SENT_AT_MISSING = 172
    
    /*
    ** The constant IMERROBJ_MESSAGE_SENT_AT_MISSING
    */
    public static var IMERROBJ_MESSAGE_SENT_AT_MISSING = IsometrikError(remoteError: false, errorMessage: "Message sent at is missing.", isometrikErrorCode: IMERR_MESSAGE_SENT_AT_MISSING)
    
    /*
    ** Member name missing
    */
    private static var IMERR_MEMBER_NAME_MISSING = 173
    
    /*
    ** The constant IMERROBJ_MEMBER_NAME_MISSING
    */
    public static var IMERROBJ_MEMBER_NAME_MISSING = IsometrikError(remoteError: false, errorMessage: "Member name is missing.", isometrikErrorCode: IMERR_MEMBER_NAME_MISSING)
    
    /*
    ** Moderator name missing
    */
    private static var IMERR_MODERATOR_NAME_MISSING = 174
    
    /*
    ** The constant IMERROBJ_MODERATOR_NAME_MISSING
    */
    public static var IMERROBJ_MODERATOR_NAME_MISSING = IsometrikError(remoteError: false, errorMessage: "Moderator name is missing.", isometrikErrorCode: IMERR_MODERATOR_NAME_MISSING)
    
    /*
    ** Message id missing
    */
    private static var IMERR_MESSAGE_ID_MISSING = 175
    
    /*
    ** The constant IMERROBJ_MESSAGE_ID_MISSING
    */
    public static var IMERROBJ_MESSAGE_ID_MISSING = IsometrikError(remoteError: false, errorMessage: "Message id is missing.", isometrikErrorCode: IMERR_MESSAGE_ID_MISSING)
    
    /*
    ** Password is missing
    */
    private static var IMERR_PASSWORD_MISSING = 176
    
    /*
    ** The constant IMERROBJ_MESSAGE_ID_MISSING
    */
    public static var IMERROBJ_PASSWORD_MISSING = IsometrikError(remoteError: false, errorMessage: "Password is missing.", isometrikErrorCode: IMERR_PASSWORD_MISSING)
    
    /*
     * Gets imerr not found.
     *
     * @return the imerr not found
    */
    static func getImerrNotFound() -> Int {
        return IMERR_NOT_FOUND
    }
    
    /*
     * Gets imerr forbidden.
     *
     * @return the imerr forbidden
    */
    static func getImerrForbidden() -> Int {
        return IMERR_FORBIDDEN
    }
    
    /*
     * Gets imerr service unavailable.
     *
     * @return the imerr service unavailable
    */
    static func getImerrServiceUnavailable() -> Int {
        return IMERR_SERVICE_UNAVAILABLE
    }
    
    /*
     * Gets imerr conflict.
     *
     * @return the imerr conflict
    */
    static func getImerrConflict() -> Int {
        return IMERR_CONFLICT
    }
    
    /*
     * Gets imerr unprocessable entity.
     *
     * @return the imerr unprocessable entity
    */
    static func getImerrUnprocessableEntity() -> Int {
        return IMERR_UNPROCESSABLE_ENTITY
    }
    
    /*
     * Gets imerr bad gateway.
     *
     * @return the imerr bad gateway
    */
    static func getImerrBadGateway() -> Int {
        return IMERR_BAD_GATEWAY
    }

    /*
     * Gets imerr internal server error.
     *
     * @return the imerr internal server error
    */
    static func getImerrInternalServerError() -> Int {
        return IMERR_INTERNAL_SERVER_ERROR
    }
    
    /*
     * Gets imerr parsing error.
     *
     * @return the imerr parsing error
    */
    static func getImerrParsingError() -> Int {
        return IMERR_PARSING_ERROR
    }
    
    /*
     * Gets imerr network error.
     *
     * @return the imerr network error
    */
    static func getImerrNetworkError() -> Int {
        return IMERR_NETWORK_ERROR
    }
    
    /*
     * Gets imerr bad request error.
     *
     * @return the imerr bad request error
    */
    static func getImerrBadRequestError() -> Int {
        return IMERR_BAD_REQUEST_ERROR
    }

}
