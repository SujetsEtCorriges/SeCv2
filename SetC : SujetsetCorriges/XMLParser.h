//
//  XMLParser.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 03/10/12.
//  Copyright (c) 2012 Mestiri Hedi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kItem @"item"


@class XMLParser;

@protocol XMLParserDelegate <NSObject>

- (void) xmlParser:(XMLParser*)parser didFinishParsing:(NSArray*)array;
- (void) xmlParser:(XMLParser *)parser didFailWithError:(NSError *)error;

@end


@interface XMLParser : NSObject <NSXMLParserDelegate>
{
    NSXMLParser *textParser_;
    NSString *typeParse_;
    
    
    NSMutableDictionary *item_;
    
    NSString *_currentElement;
    
    //parse wordpress
    NSMutableString *title_;
	NSMutableString *date_;
	NSMutableString *summary_;
	NSMutableString *link_;
    NSMutableString *message_;
    NSMutableString *id_;
    NSMutableString *nbcomments_;
    NSMutableString *creator_;
}


- (void)parseXMLFileAtData:(NSString *)theData;
- (void)parseXMLFileAtURL:(NSString *)theUrl;

@property (nonatomic, retain) NSMutableArray *XMLData;
@property (nonatomic, assign) id <XMLParserDelegate> delegate;

@end
