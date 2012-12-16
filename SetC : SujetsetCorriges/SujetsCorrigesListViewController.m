//
//  SujetsCorrigesListViewController.m
//  SetC : SujetsetCorriges
//
//  Created by Mestiri Hedi on 16/12/12.
//  Copyright (c) 2012 SeC. All rights reserved.
//

#import "SujetsCorrigesListViewController.h"

#import "XMLParser.h"

@interface SujetsCorrigesListViewController ()

@end

@implementation SujetsCorrigesListViewController

@synthesize tableSuj = tableSuj_;
@synthesize listeSujCor = listeSujCor_;
@synthesize intro = intro_;
@synthesize introView = introView_;
@synthesize concours = concours_;
@synthesize filiere = filiere_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (intro_)
    {
        [tableSuj_ setHidden:YES];
        
        CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        CGFloat hauteurFenetre = screenRect.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height;
        
        introView_ = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, hauteurFenetre)];
        
        introLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, round(introView_.frame.size.height/4), introView_.frame.size.width, round(introView_.frame.size.height/3))];
        introLabel_.text = @"Sélectionnez un concours";
        introLabel_.textAlignment = UITextAlignmentCenter;
        
        [introView_ addSubview:introLabel_];
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

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *sujcor = [[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [sujcor objectForKey:kNom], [sujcor objectForKey:kEpreuve]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailEpreuveViewController *detailVC = [[DetailEpreuveViewController alloc] initWithNibName:@"DetailEpreuveViewController" bundle:nil];
    detailVC.concours = concours_;
    detailVC.filiere = filiere_;
    detailVC.annee = [tabAnneeOrdre_ objectAtIndex:[indexPath section]];
    detailVC.epreuve = [[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kNom];
    
    detailVC.lienSujet = [[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kSujet];
    detailVC.lienCorrige = [[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kCorrige];
    detailVC.corrigePartiel = (int)[[[tabSujCorRangeParAnnee_ objectForKey:[tabAnneeOrdre_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]] objectForKey:kCorrigePartiel];
    
    [self.navigationController pushViewController:detailVC animated:YES];*/
}

@end

