//
//  CPGEView.h
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 12/04/13.
//  Copyright (c) 2013 SeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPGEViewDelegate;

@interface CPGEView : UIView

@property (nonatomic, strong) IBOutlet UISegmentedControl *sgRedoublant;
@property (nonatomic, strong) IBOutlet UILabel *lStatut;
@property (nonatomic, weak) id <CPGEViewDelegate> delegate;

-(id)initCPGEViewAtPosition:(float)yPosition;

@end


/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol CPGEViewDelegate <NSObject>

@optional
-(void)redoublant:(BOOL)statut;

@end