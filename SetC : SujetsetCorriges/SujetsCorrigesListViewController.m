//
//  SujetsCorrigesListViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "SujetsCorrigesListViewController.h"

#import "XMLParser.h"
#import "VariableStore.h"
#import "SujetsCorrigesDetailsViewController.h"

@interface SujetsCorrigesListViewController ()

@end

@implementation SujetsCorrigesListViewController

@synthesize tableSuj = tableSuj_;
@synthesize listeSujCor = listeSujCor_;
@synthesize introView = introView_;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    VariableStore *obj=[VariableStore getInstance];
    concours_ = obj.concours;
    filiere_ = obj.filiere;
    
    UIView *viewShadowConcours = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    viewShadowConcours.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *shadowConcours = [CAGradientLayer layer];
    shadowConcours.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.8].CGColor,(id)[UIColor colorWithWhite:1 alpha:0.0].CGColor,nil];
    shadowConcours.frame = viewShadowConcours.frame;
    shadowConcours.startPoint = CGPointMake(0.5, 0);
    shadowConcours.endPoint = CGPointMake(0.5,1);
    [viewShadowConcours.layer addSublayer:shadowConcours];
    
    UILabel *labelConcours = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, viewShadowConcours.frame.size.width, 20)];
    labelConcours.backgroundColor = [UIColor clearColor];
    labelConcours.textColor = [UIColor whiteColor];
    labelConcours.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    labelConcours.textAlignment = NSTextAlignmentCenter;
    labelConcours.shadowColor = [UIColor blackColor];
    labelConcours.shadowOffset = CGSizeMake(0, 1);
    labelConcours.text = concours_;
    [viewShadowConcours addSubview:labelConcours];
    
    UILabel *labelMatiere = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, viewShadowConcours.frame.size.width, 16)];
    labelMatiere.backgroundColor = [UIColor clearColor];
    labelMatiere.textColor = [UIColor whiteColor];
    labelMatiere.font = [UIFont fontWithName:@"Helvetica" size:12];
    labelMatiere.textAlignment = NSTextAlignmentCenter;
    labelMatiere.shadowColor = [UIColor blackColor];
    labelMatiere.shadowOffset = CGSizeMake(0, 1);
    labelMatiere.text = @"Matière";
    [viewShadowConcours addSubview:labelMatiere];
    
    [self.view addSubview:viewShadowConcours];
    
    [tableSuj_ setContentInset:UIEdgeInsetsMake(30,0,0,0)];
    
    if ([concours_ isEqualToString:@"aucun"])
    {
        [tableSuj_ setHidden:YES];
        
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        CGFloat hauteurFenetre = screenRect.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height;
        
        introView_ = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, hauteurFenetre)];
        introView_.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        
        introLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, introView_.frame.size.width-200, hauteurFenetre)];
        
        introLabel_.backgroundColor = [UIColor clearColor];
        introLabel_.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        introLabel_.textColor = [UIColor darkGrayColor];
        introLabel_.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        introLabel_.shadowOffset = CGSizeMake(0,1);
        introLabel_.text = @"Sélectionnez un concours";
        introLabel_.numberOfLines = 0;
        introLabel_.lineBreakMode = NSLineBreakByWordWrapping;
        
        //[introView_ addSubview:introLabel_];
        [self.view addSubview:introView_];
    }
    else
    {
        //initialisation des variables
        NSDictionary *tempSujCor = [[NSDictionary alloc] init];
        NSString *tempAnnee = [[NSString alloc] init];
        NSMutableArray *listAnnee = [[NSMutableArray alloc] init];
        tabSujCorRangeParAnnee_ = [[NSMutableDictionary alloc] init];
        
        //booléen pour savoir si l'annee a déjà été rencontré
        BOOL found = NO;
        
        //tableau des années extraites
        for (int i=0; i<[listeSujCor_ count]; i++)
        {
            //on prend l'entrée et on enregistre la matière
            tempSujCor = [listeSujCor_ objectAtIndex:i];
            tempAnnee = [tempSujCor objectForKey:@"annee"];
            
            //on recherche si la matière est dans le tableau
            for (NSString *mat in listAnnee)
            {
                if ([mat isEqualToString:tempAnnee])
                {
                    found = YES;
                    break;
                }
            }
            
            //si l'année n'a pas été trouvé
            if (!found)
            {
                //on ajoute l'année dans le tableau
                [listAnnee addObject:tempAnnee];
                
                //on créé un tableau qui contiendra les épreuves pour l'année correspondante
                NSMutableArray *tabEpreuves = [[NSMutableArray alloc] init];
                
                //on ajoute l'élément XML actuel dans le tableau d'ID
                [tabEpreuves addObject:tempSujCor];
                
                //on ajoute dans le dictionnaire le tableau d'epreuve avec pour clé l'annee actuelle
                [tabSujCorRangeParAnnee_ setObject:tabEpreuves forKey:tempAnnee];
                
                found = NO;
            }
            else
            {
                //l'annee existe, un tableau d'épreuve existe pour cette année, on l'enregistre
                NSMutableArray *tabEpreuves = [[NSMutableArray alloc] init];
                tabEpreuves = [tabSujCorRangeParAnnee_ objectForKey:tempAnnee];
                
                //on rajoute à ce tableau l'épreuve actuel
                [tabEpreuves addObject:tempSujCor];
                
                //on trie le tableau d'epreuve par le numero epreuve
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"epreuve"  ascending:YES];
                NSArray *tabTemp = [tabEpreuves sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
                tabEpreuves = [(NSArray*)tabTemp mutableCopy];
                
                //on remplace l'ancien tableau d'élément par le nouveau dans le dictionnaire
                [tabSujCorRangeParAnnee_ setObject:tabEpreuves forKey:tempAnnee];
                
                found = NO;
            }
        }
        
        //trier tableau annee dans l'ordre croissant
        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
        tabAnneeOrdre_ = [listAnnee sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
        
        tableSuj_.delegate = self;
        tableSuj_.dataSource = self;
    }
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tabAnneeOrdre_ count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [tabAnneeOrdre_ objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"epreuveCell";
    
    EpreuveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[EpreuveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *sujcor = [[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    cell.epreuveLabel.text = [NSString stringWithFormat:@"%@ - %@", [sujcor objectForKey:kNom], [sujcor objectForKey:kEpreuve]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"pushToSujetsCorrigesView" sender: self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - push View method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToSujetsCorrigesView"])
    {
        NSIndexPath *indexPath = [self.tableSuj indexPathForSelectedRow];
        SujetsCorrigesDetailsViewController *destViewController = segue.destinationViewController;
        
        destViewController.concours = concours_;
        destViewController.filiere = filiere_;
        destViewController.annee = [tabAnneeOrdre_ objectAtIndex:[indexPath section]];
        destViewController.epreuve = [[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kNom];
        
        destViewController.lienSujet = [[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kSujet];
        destViewController.lienCorrige = [[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kCorrige];
        destViewController.corrigePartiel = (int)[[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kCorrigePartiel];
    }
}

@end

