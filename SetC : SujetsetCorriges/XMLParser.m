//
//  XMLParser.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 03/10/12.
//  Copyright (c) 2012 Mestiri Hedi. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize XMLData = XMLData_;
@synthesize delegate = delegate_;

-(void) parseXMLFileAtData:(NSString *)theData
{
    self.XMLData = [[NSMutableArray alloc] init];
    
    typeParse_ = @"sujcor";
    
    NSData* list=[theData dataUsingEncoding:NSUTF8StringEncoding];
    
    textParser_ = [[NSXMLParser alloc] initWithData:list];
    
    [textParser_ setShouldProcessNamespaces:NO];
	[textParser_ setShouldReportNamespacePrefixes:NO];
	[textParser_ setShouldResolveExternalEntities:NO];
    
    [textParser_ setDelegate:self];
    
    [textParser_ parse];
}

- (void) parseXMLFileAtURL:(NSString *)theUrl
{
    self.XMLData = [[NSMutableArray alloc] init];
    
    typeParse_ = @"posts";
    
    NSURL *xmlURL = [NSURL URLWithString:theUrl];
    
    textParser_ = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    [textParser_ setShouldProcessNamespaces:NO];
	[textParser_ setShouldReportNamespacePrefixes:NO];
	[textParser_ setShouldResolveExternalEntities:NO];
    
    [textParser_ setDelegate:self];
    
    [textParser_ parse];
}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentElement = [elementName copy];
    
    if ([elementName isEqualToString:kItem])
    {
        if ([typeParse_ isEqualToString:@"sujcor"])
        {
            item_ = [[NSMutableDictionary alloc] init];
            
            currentMatiere_ = [[NSMutableString alloc] init];
            currentAnnee_ = [[NSMutableString alloc] init];
            currentEpreuve_ = [[NSMutableString alloc] init];
            currentSujet_ = [[NSMutableString alloc] init];
            currentCorrige_ = [[NSMutableString alloc] init];
            currentCorrigePartiel_ = [[NSMutableString alloc] init];
            currentNom_ = [[NSMutableString alloc] init];
        }
        else if ([typeParse_ isEqualToString:@"posts"])
        {
            item_ = [[NSMutableDictionary alloc] init];
            
            title_ = [[NSMutableString alloc] init];
            date_ = [[NSMutableString alloc] init];
            summary_ = [[NSMutableString alloc] init];
            link_ = [[NSMutableString alloc] init];
            message_ = [[NSMutableString alloc] init];
            id_ = [[NSMutableString alloc] init];
        }
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([typeParse_ isEqualToString:@"sujcor"])
    {
        if ([_currentElement isEqualToString:kMatiere])
        {
            [currentMatiere_ appendString:string];
        }
        else if ([_currentElement isEqualToString:kAnnee])
        {
            [currentAnnee_ appendString:string];
        }
        else if ([_currentElement isEqualToString:kEpreuve])
        {
            [currentEpreuve_ appendString:string];
        }
        else if ([_currentElement isEqualToString:kSujet])
        {
            [currentSujet_ appendString:string];
        }
        else if ([_currentElement isEqualToString:kCorrige])
        {
            [currentCorrige_ appendString:string];
        }
        else if ([_currentElement isEqualToString:kCorrigePartiel])
        {
            [currentCorrigePartiel_ appendString:string];
        }
        else if ([_currentElement isEqualToString:kNom])
        {
            [currentNom_ appendString:string];
        }
    }
    else if ([typeParse_ isEqualToString:@"posts"])
    {
        if ([_currentElement isEqualToString:@"title"])
        {
            [title_ appendString:string];
            [title_ setString: [self cleaningString:title_]];
        }
        else if ([_currentElement isEqualToString:@"pubDate"])
        {
            [date_ appendString:string];
            [date_ setString: [self cleaningString:date_]];
        }
        else if ([_currentElement isEqualToString:@"content:encoded"])
        {
            [summary_ appendString:string];
            [summary_ setString: [self cleaningString:summary_]];
        }
        else if ([_currentElement isEqualToString:@"link"])
        {
            [link_ appendString:string];
            [link_ setString: [self cleaningString:link_]];
        }
        else if ([_currentElement isEqualToString:@"description"])
        {
            [message_ appendString:string];
            [message_ setString: [self cleaningString:message_]];
        }
        else if ([_currentElement isEqualToString:@"guid"])
        {
            [id_ appendString:string];
            [id_ setString: [self cleaningString:id_]];
        }
    }
}


-(NSString *)cleaningString:(NSString *)dirtyString
{
    //On nettoie les chaînes
    NSString *cleanString = [dirtyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    cleanString = [cleanString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cleanString = [cleanString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    cleanString = [cleanString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    cleanString = [cleanString stringByTrimmingCharactersInSet:[NSCharacterSet nonBaseCharacterSet]];
    return cleanString;
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kItem])
    {
        if ([typeParse_ isEqualToString:@"sujcor"])
        {
            [item_ setObject:currentMatiere_ forKey:kMatiere];
            [item_ setObject:currentAnnee_ forKey:kAnnee];
            [item_ setObject:currentEpreuve_ forKey:kEpreuve];
            [item_ setObject:currentSujet_ forKey:kSujet];
            [item_ setObject:currentCorrige_ forKey:kCorrige];
            [item_ setObject:currentCorrigePartiel_ forKey:kCorrigePartiel];
            [item_ setObject:currentNom_ forKey:kNom];
            
            [self.XMLData addObject:item_];
        }
        else if ([typeParse_ isEqualToString:@"posts"])
        {
            [item_ setObject:title_ forKey:@"title"];
            [item_ setObject:date_ forKey:@"date"];
            [item_ setObject:summary_ forKey:@"summary"];
            [item_ setObject:link_ forKey:@"link"];
            [item_ setObject:message_ forKey:@"message"];
            [item_ setObject:[[id_ componentsSeparatedByString:@"="] objectAtIndex:1] forKey:@"id"];
            
            [self.XMLData addObject:item_];
        }
       
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self.delegate xmlParser:self didFinishParsing:[NSArray arrayWithArray:self.XMLData]];
                   });
        
}

- (void) informDelegateOfError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self.delegate xmlParser:self didFailWithError:error];
                   });
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self informDelegateOfError:parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    [self informDelegateOfError:validationError];
}

@end
