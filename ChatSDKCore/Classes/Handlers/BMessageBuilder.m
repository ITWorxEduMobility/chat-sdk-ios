//
//  BMessageBuilder.m
//  AFNetworking
//
//  Created by Ben on 12/11/18.
//

#import "BMessageBuilder.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation BMessageBuilder

-(instancetype) init {
    if((self = [super init])) {
        [self createMessage];
    }
    return self;
}

+(instancetype) message {
    return [[self alloc] init];
}

+(instancetype) textMessage: (NSString *) text {
    return [[[self alloc] init] textMessage:text];
}

+(instancetype) withType: (bMessageType) type {
    return [[[self alloc] init] withType:type];
}

+(instancetype) systemMessage: (NSString *) text type: (bSystemMessageType) systemMessageType {
    return [[[self alloc] init] systemMessage:text type:systemMessageType];
}

+(instancetype) imageMessage: (UIImage *) image {
    return [[[self alloc] init] imageMessage:image];
}

-(id<PMessage>) build {
    return _message;
}

-(BMessageBuilder *) textMessage: (NSString *) text {
    [_message setText:text];
    [self type:bMessageTypeText];
    return self;
}

-(BMessageBuilder *) withType: (bMessageType) type {
    [self type:type];
    return self;
}

-(BMessageBuilder *) meta: (NSDictionary *) meta {
    for (id key in meta.allKeys) {
        [_message setMetaValue:meta[key] forKey:key];
    }
    return self;
}

-(BMessageBuilder *) entityID: (NSString *) entityID {
    _message.entityID = entityID;
    return self;
}

-(BMessageBuilder *) type: (bMessageType) type {
    _message.type = @(type);
    return self;
}

-(BMessageBuilder *) typeAsInt: (int) type {
    _message.type = @(type);
    return self;
}


-(BMessageBuilder *) thread: (NSString *) threadID {
    id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadID withType:bThreadEntity];
    [thread addMessage: _message];
    return self;
}

-(BMessageBuilder *) systemMessage: (NSString *) text type: (bSystemMessageType) systemMessageType {
    [self type:bMessageTypeSystem];
    [_message setMeta:@{bMessageText: text,
                       bMessageSystemType: @(systemMessageType)}];

    return self;
}

-(BMessageBuilder *) imageMessage: (UIImage *) image{
    [self type:bMessageTypeImage];
    
    // Rotate image to be correct orientation
//    image = [UIImage fixedOrientationFor:image];
    
    _message.placeholder = UIImageJPEGRepresentation(image, 0.6);
    return self;
}

-(BMessageBuilder *) createMessage {
    _message = [BChatSDK.db createMessageEntity];
    _message.entityID = BCoreUtilities.getUUID;
    
    _message.date = BChatSDK.core.now;
    
    _message.userModel = BChatSDK.currentUser;
    [_message setDelivered: @NO];
    [_message setRead: @NO];
    _message.flagged = @NO;
    
    return self;
}

@end
