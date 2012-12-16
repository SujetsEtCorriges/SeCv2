//
//  XMLParser.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 03/10/12.
//  Copyright (c) 2012 Mestiri Hedi. All rights reserved.
//

#import <Foundation/Foundation.h>

//sujets et corriges
#define kItem @"item"
#define kMatiere @"matiere"
#define kAnnee @"annee"
#define kEpreuve @"epreuve"
#define kSujet @"sujet"
#define kCorrige @"corrige"
#define kCorrigePartiel @"corrigePartiel"
#define kNom @"nom"

@class XMLParser;

@protocol XMLParserDelegate <NSObject>

- (void) xmlParser:(XMLParser*)parser didFinishParsing:(NSArray*)array;
- (void) xmlParser:(XMLParser *)parser didFailWithError:(NSArray *)error;

@end


@interface XMLParser : NSObject <NSXMLParserDelegate>
{
    NSXMLParser *textParser_;
    NSString *typeParse_;
    
    
    NSMutableDictionary *item_;
    
    NSString *_currentElement;
    
    //parse sujet et corrigé
    NSMutableString *currentMatiere_;
    NSMutableString *currentAnnee_;
    NSMutableString *currentEpreuve_;
    NSMutableString *currentSujet_;
    NSMutableString *currentCorrige_;
    NSMutableString *currentCorrigePartiel_;
    NSMutableString *currentNom_;
    
    //parse wordpress
    NSMutableString *title_;
	NSMutableString *date_;
	NSMutableString *summary_;
	NSMutableString *link_;
    NSMutableString *message_;
    NSMutableString *id_;
}


- (void)parseXMLFileAtData:(NSString *)theData;
- (void)parseXMLFileAtURL:(NSString *)theUrl;

@property (nonatomic, retain) NSMutableArray *XMLData;
@property (nonatomic, assign) id <XMLParserDelegate> delegate;

@end
