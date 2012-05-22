//
//  BAMSettings.m
//  BAMSettings
//
//  Created by Barry Murphy on 4/5/11.
//
//  If you use this software in your project, a credit for Barry Murphy
//  and a link to http://barrycenter.com would be appreciated.
//
//  --------------------------------
//  Simplified BSD License (FreeBSD)
//  --------------------------------
//
//  Copyright 2011 Barry Murphy. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of
//     conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list
//     of conditions and the following disclaimer in the documentation and/or other materials
//     provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY BARRY MURPHY "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BARRY MURPHY OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of Barry Murphy.
//

#pragma mark - Constants

#import "BAMSettings.h"

#define BAMSettingsPreferencesSpecifier  @"PreferenceSpecifiers"
#define BAMSettingsStringsTable          @"StringsTable"

#define BAMSettingsType                  @"Type"
#define BAMSettingsTypeGroup             @"PSGroupSpecifier"
#define BAMSettingsTypeMultiValue        @"PSMultiValueSpecifier"
#define BAMSettingsTypeToggleSwitch      @"PSToggleSwitchSpecifier"
#define BAMSettingsTypeTextField         @"PSTextFieldSpecifier"
#define BAMSettingsTypeSlider            @"PSSliderSpecifier"
#define BAMSettingsTypeChildPane         @"PSChildPaneSpecifier"
#define BAMSettingsTypeTitleValue        @"PSTitleValueSpecifier"

#define BAMSettingsKey                   @"Key"
#define BAMSettingsTitle                 @"Title"
#define BAMSettingsTitles                @"Titles"
#define BAMSettingsValues                @"Values"
#define BAMSettingsTrueValue             @"TrueValue"
#define BAMSettingsFalseValue            @"FalseValue"
#define BAMSettingsDefaultValue          @"DefaultValue"
#define BAMSettingsFooterText            @"FooterText"
#define BAMSettingsIsSecure              @"IsSecure"
#define BAMSettingsMinimumValue          @"MinimumValue"
#define BAMSettingsMaximumValue          @"MaximumValue"
#define BAMSettingsMinimumValueImage     @"MinimumValueImage"
#define BAMSettingsMaximumValueImage     @"MaximumValueImage"
#define BAMSettingsFile                  @"File"

#define BAMSettingsAutocorrectionType    @"AutocorrectionType"
#define BAMSettingsAutocorrectionTypeYes @"Yes"
#define BAMSettingsAutocorrectionTypeNo  @"No"

#define BAMSettingsAutocapsType          @"AutocapitalizationType"
#define BAMSettingsAutocapsTypeNone      @"None"
#define BAMSettingsAutocapsTypeWords     @"Words"
#define BAMSettingsAutocapsTypeSentences @"Sentences"
#define BAMSettingsAutocapsTypeAllChars  @"AllCharacters"

static NSString *cellReuseIdentifierMultiValue     = @"SettingsTableCellIdentifierMultiValue";
static NSString *cellReuseIdentifierToggleSwitch   = @"SettingsTableCellIdentifierToggleSwitch";
static NSString *cellReuseIdentifierTextField      = @"SettingsTableCellIdentifierTextField";
static NSString *cellReuseIdentifierSlider         = @"SettingsTableCellIdentifierSlider";
static NSString *cellReuseIdentifierChildPane      = @"SettingsTableCellIdentifierChildPane";
static NSString *cellReuseIdentifierUnknownType    = @"SettingsTableCellIdentifierUnknownType";
static NSString *cellReuseIdentifierTitleValue     = @"SettingsTableCellIdentifierTitleValue";

static NSString *cellReuseIdentifierSettingsDetail = @"SettingsDetailTableCellIdentifier";


#pragma mark - SettingsDetail -

/*****************************************************************************\
 *                                                                           *
 *                             BAMSettingsDetail                             *
 *                                                                           *
 *  This class displays a table of options for a multi-value setting type.   *
 *                                                                           *
\*****************************************************************************/

@interface BAMSettingsDetail () {
    NSInteger selectedRow;
    NSIndexPath *cellIndexPath;
    NSString *title;
    NSArray *rowTitles;
}
@property (nonatomic, retain) NSIndexPath *cellIndexPath;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *rowTitles;
@end

@implementation BAMSettingsDetail

@synthesize delegate;
@synthesize cellIndexPath;
@synthesize title;
@synthesize rowTitles;

- (id)initWithTitle:(NSString *)aTitle rowTitles:(NSArray *)theRowTitles selectedRow:(NSInteger)aSelectedRow forCellAtIndexPath:(NSIndexPath *)aCellIndexPath {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.cellIndexPath = aCellIndexPath;
        self.title = aTitle;
        self.rowTitles = theRowTitles;
        selectedRow = aSelectedRow;
    }
    return self;
}

- (void)dealloc {
    [cellIndexPath release];
    [title release];
    [rowTitles release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = title;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [rowTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierSettingsDetail];
    
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifierSettingsDetail] autorelease];
    }
    
    cell.textLabel.text = [rowTitles objectAtIndex:[indexPath row]];
    if ([indexPath row] == selectedRow) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRow = [indexPath row];
    UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setSelected:NO animated:YES];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSArray *visibleCellPaths = [self.tableView indexPathsForVisibleRows];
    NSMutableArray *cellsToReload = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *path in visibleCellPaths) {
        if ([path row] != [indexPath row]) [cellsToReload addObject:path];
    }
    
    [self.tableView reloadRowsAtIndexPaths:cellsToReload withRowAnimation:UITableViewRowAnimationNone];
    
    [cellsToReload release];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(settingsDetailSelectedRow:forCellIndexPath:)]) {
        [self.delegate settingsDetailSelectedRow:[indexPath row] forCellIndexPath:cellIndexPath];
    }
 }

@end



#pragma mark - Settings -

/*****************************************************************************\
 *                                                                           *
 *                                BAMSettings                                *
 *                                                                           *
 *  This class diplays a table view for the options in the specified plist.  *
 *                                                                           *
\*****************************************************************************/

@interface BAMSettings () {
    BOOL isChildPane;
    NSString *paneTitle, *propertyListName, *stringsTable;
    NSBundle *settingsBundle;
    NSMutableArray *sectionHeaders, *sectionFooters, *sections;
}
@property (nonatomic, copy) NSString *paneTitle, *propertyListName, *stringsTable;
@property (nonatomic, retain) NSBundle *settingsBundle;

- (id)initAsChildPaneWithTitle:(NSString *)aTitle propertyListNamed:(NSString *)aPropertyListName;
- (NSString *)formattedStringForTitle:(id)titleObject format:(NSString *)format;
- (NSArray *)formattedArrayForTitles:(id)titles format:(NSString *)format;
- (NSInteger)selectedRowTitlesIndexForKey:(NSString *)key values:(NSArray *)values defaultValue:(id)defaultValueObject;
- (BOOL)booleanForKey:(NSString *)key trueValue:(id)trueValueObject falseValue:(id)falseValueObject defaultValue:(id)defaultValueObject;
- (NSInteger)autocapsTypeFromKey:(NSString *)key;
- (NSInteger)autocorrectionTypeFromKey:(NSString *)key;
- (NSIndexPath *)cellIndexPathForAccessoryView:(id)accessoryView;
- (UITableViewCell *)reusableOrNewTableCellWithIdentifier:(NSString *)reuseIdentifier cellStyle:(NSInteger)cellStyle;
- (UITableViewCell *)multiValueCellFromRowDictionary:(NSDictionary *)rowDict;
- (UITableViewCell *)toggleSwitchCellFromRowDictionary:(NSDictionary *)rowDict;
- (UITableViewCell *)textFieldCellFromRowDictionary:(NSDictionary *)rowDict;
- (UITableViewCell *)sliderCellFromRowDictionary:(NSDictionary *)rowDict;
- (UITableViewCell *)childPaneCellFromRowDictionary:(NSDictionary *)rowDict;
- (UITableViewCell *)titleValueCellFromRowDictionary:(NSDictionary *)rowDict;
- (UITableViewCell *)unknownCellFromRowDictionary:(NSDictionary *)rowDict;
- (void)updateUserDefaultsForAccessoryView:(id)accessoryView;
- (void)updateStoredValue:(id)valueObject forKey:(NSString *)key;
- (void)scrollToMiddle:(NSIndexPath *)indexPath;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (CGFloat)keyboardHeight:(NSDictionary *)userInfo;
@end

@implementation BAMSettings

@synthesize delegate;
@synthesize paneTitle, propertyListName, stringsTable;
@synthesize settingsBundle;

static BOOL haveSettingsBeenChanged = NO;
static BOOL disableExitDelegateMethod = NO;

- (id)initWithTitle:(NSString *)aTitle propertyListNamed:(NSString *)aPropertyListName {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.paneTitle = aTitle;
        self.propertyListName = [aPropertyListName stringByDeletingPathExtension];
        isChildPane = NO;
    }
    return self;
}

- (id)initAsChildPaneWithTitle:(NSString *)aTitle propertyListNamed:(NSString *)aPropertyListName {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.paneTitle = aTitle;
        self.propertyListName = [aPropertyListName stringByDeletingPathExtension];
        isChildPane = YES;
    }
    return self;
}

- (void)dealloc {
    [paneTitle release];
    [propertyListName release];
    [stringsTable release];
    [settingsBundle release];
    [sectionHeaders release];
    [sectionFooters release];
    [sections release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *settingsBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
    self.settingsBundle = [NSBundle bundleWithPath:settingsBundlePath];

    NSString *settingsPropertyListFilename = [propertyListName stringByAppendingPathExtension:@"plist"];
    NSString *settingsPropertyListPath = [[settingsBundle bundlePath] stringByAppendingPathComponent:settingsPropertyListFilename];

    NSDictionary *settingsPropertyList = [NSDictionary dictionaryWithContentsOfFile:settingsPropertyListPath];
    
    NSMutableArray *preferenceArray = [settingsPropertyList objectForKey:BAMSettingsPreferencesSpecifier];
    self.stringsTable = [settingsPropertyList objectForKey:BAMSettingsStringsTable];
   
    sectionHeaders = [[NSMutableArray alloc] init];
    sectionFooters = [[NSMutableArray alloc] init];
    sections = [[NSMutableArray alloc] init];
    
    NSString *previousHeader = @"";
    NSString *previousFooter = @"";
    NSMutableArray *section = [[NSMutableArray alloc] init];
    
    for (NSDictionary *currentPreferenceDict in preferenceArray) {
        NSString *currentType = [currentPreferenceDict objectForKey:BAMSettingsType];
        if ([currentType isEqualToString:BAMSettingsTypeGroup]) {
            [sectionHeaders addObject:[settingsBundle localizedStringForKey:previousHeader value:previousHeader table:stringsTable]];
            [sectionFooters addObject:[settingsBundle localizedStringForKey:previousFooter value:previousFooter table:stringsTable]]; 
            [sections addObject:[[section copy] autorelease]];
            [section removeAllObjects];
            
            previousHeader = [currentPreferenceDict objectForKey:BAMSettingsTitle];
            previousFooter = [currentPreferenceDict objectForKey:BAMSettingsFooterText];
            if (previousHeader == nil) previousHeader = @"";
            if (previousFooter == nil) previousFooter = @"";
        } else {
            if (![[currentPreferenceDict objectForKey:BAMSettingsKey] isEqualToString:@""]) {
                [section addObject:currentPreferenceDict];
            }
        }
    }
    [sectionHeaders addObject:[settingsBundle localizedStringForKey:previousHeader value:previousHeader table:stringsTable]];
    [sectionFooters addObject:[settingsBundle localizedStringForKey:previousFooter value:previousFooter table:stringsTable]];
    [sections addObject:section];
    
    [section release];
    
    // Apple settings would use the app name but we used the one passed in through init methods.
    self.title = [settingsBundle localizedStringForKey:paneTitle value:paneTitle table:stringsTable];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!isChildPane) disableExitDelegateMethod = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(settingsNavigatedAwayFromPane:withChangedValues:)]) {
        [self.delegate settingsNavigatedAwayFromPane:propertyListName withChangedValues:haveSettingsBeenChanged];
    }
    if (!isChildPane && !disableExitDelegateMethod && self.delegate != nil && [self.delegate respondsToSelector:@selector(settingsExitedWithChangedValues:)]) {
        [self.delegate settingsExitedWithChangedValues:haveSettingsBeenChanged];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSArray *visibleCellPaths = [self.tableView indexPathsForVisibleRows];
    
    for (NSIndexPath *path in visibleCellPaths) {
        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:path];
        if (currentCell.reuseIdentifier == cellReuseIdentifierTextField) {
            [currentCell.accessoryView resignFirstResponder];
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

#pragma mark - Formatting Methods

- (NSString *)formattedStringForTitle:(id)titleObject format:(NSString *)format {
    NSString *returnString = @"";
    
    if (titleObject != nil) {
        if ([titleObject isKindOfClass:[NSString class]]) {
            returnString = [settingsBundle localizedStringForKey:titleObject value:titleObject table:stringsTable];
        } else if ([titleObject isKindOfClass:[NSNumber class]]) {
            NSNumber *returnNumber = (NSNumber *)titleObject;
            returnString = [returnNumber stringValue];
        } else if ([titleObject isKindOfClass:[NSDate class]]) {
            NSDate *returnDate = (NSDate *)titleObject;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            returnString = [dateFormatter stringFromDate:returnDate];
            [dateFormatter release];
        }
    }
    
    return returnString;
}

- (NSArray *)formattedArrayForTitles:(id)titles format:(NSString *)format {
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (id titleObject in titles) {
        NSString *formattedTitle = [self formattedStringForTitle:titleObject format:format];
        [returnArray addObject:formattedTitle];
    }
    
    return (NSArray *)returnArray;
}

#pragma mark - Collection Selector Methods

- (NSInteger)selectedRowTitlesIndexForKey:(NSString *)key values:(NSArray *)values defaultValue:(id)defaultValueObject {
    id storedValueObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSInteger selectedRowTitlesIndex = -1;
    if (storedValueObject == nil) storedValueObject = defaultValueObject;
    
    for (int i=0; i < [values count]; i++) {
        id currentValueObject = [values objectAtIndex:i];
        if ([currentValueObject isKindOfClass:[NSNumber class]] && [storedValueObject isKindOfClass:[NSNumber class]]) {
            if ([currentValueObject isEqualToNumber:storedValueObject]) selectedRowTitlesIndex = i;
        } else if ([currentValueObject isKindOfClass:[NSString class]] && [storedValueObject isKindOfClass:[NSString class]]) {
            if ([currentValueObject isEqualToString:storedValueObject]) selectedRowTitlesIndex = i;
        } else if ([currentValueObject isKindOfClass:[NSDate class]] && [storedValueObject isKindOfClass:[NSDate class]]) {
            if ([currentValueObject isEqualToDate:storedValueObject]) selectedRowTitlesIndex = i;
        }
    }
    
    return selectedRowTitlesIndex;
}

- (BOOL)booleanForKey:(NSString *)key trueValue:(id)trueValueObject falseValue:(id)falseValueObject defaultValue:(id)defaultValueObject {
    id storedValueObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (storedValueObject == nil) storedValueObject = defaultValueObject;
    BOOL returnBool = YES;
    
    if ([storedValueObject isKindOfClass:[NSNumber class]]) {
        // This will work with NSNumbers (ncluding booleans) if the stored value matches the true or false value. Yes, a boolean could have a YES as a false value making the boolean an inverse of the expected values.
        if ([trueValueObject isKindOfClass:[NSNumber class]]) {
            if ([trueValueObject isEqualToNumber:storedValueObject]) returnBool = YES;
            else returnBool = NO;
        } else if ([falseValueObject isKindOfClass:[NSNumber class]]) {
            if ([falseValueObject isEqualToNumber:storedValueObject]) returnBool = NO;
            else returnBool = YES;
        } else if (strcmp([(NSNumber *)storedValueObject objCType], @encode(BOOL)) == 0) {
            // HACK: This test is needed because the NSCFBoolean type is private and cannot be used to determine whether an NSNumber is actually storing a boolean value. By testing the the objCType I can determine that it is a boolean value but it's a bit hacky.
            returnBool = [storedValueObject boolValue];
        }
    } else if ([storedValueObject isKindOfClass:[NSString class]]) {
        if ([trueValueObject isKindOfClass:[NSString class]]) {
            if ([trueValueObject isEqualToString:storedValueObject]) returnBool = YES;
            else returnBool = NO;
        } else if ([falseValueObject isKindOfClass:[NSString class]]) {
            if ([falseValueObject isEqualToString:storedValueObject]) returnBool = NO;
            else returnBool = YES;
        }
    } else if ([storedValueObject isKindOfClass:[NSDate class]]) {
        if ([trueValueObject isKindOfClass:[NSDate class]]) {
            if ([trueValueObject isEqualToDate:storedValueObject]) returnBool = YES;
            else returnBool = NO;
        } else if ([falseValueObject isKindOfClass:[NSDate class]]) {
            if ([falseValueObject isEqualToDate:storedValueObject]) returnBool = NO;
            else returnBool = YES;
        }
        
    }
    
    return returnBool;
}

- (NSInteger)autocapsTypeFromKey:(NSString *)key {
    NSInteger returnInteger = UITextAutocapitalizationTypeSentences; // Default autocapitalization type
    if (key != nil) {
        if ([key isEqualToString:BAMSettingsAutocapsTypeNone]) { // No autocapitalization
            returnInteger = UITextAutocapitalizationTypeNone;
        } else if ([key isEqualToString:BAMSettingsAutocapsTypeWords]) { // Capitalize words
            returnInteger = UITextAutocapitalizationTypeWords;
        } else if ([key isEqualToString:BAMSettingsAutocapsTypeSentences]) { // Capitalize sentences
            returnInteger = UITextAutocapitalizationTypeSentences;
        } else if ([key isEqualToString:BAMSettingsAutocapsTypeAllChars]) { // All caps
            returnInteger = UITextAutocapitalizationTypeAllCharacters;
        }
    }
    
    return returnInteger;
}

- (NSInteger)autocorrectionTypeFromKey:(NSString *)key {
    NSInteger returnInteger = UITextAutocorrectionTypeDefault;
    if (key != nil) {
        if ([key isEqualToString:BAMSettingsAutocorrectionTypeYes]) { // Should autocorrect
            returnInteger = UITextAutocorrectionTypeYes;
        } else if ([key isEqualToString:BAMSettingsAutocorrectionTypeNo]) { // Should not autocorrect
            returnInteger = UITextAutocorrectionTypeNo;
        }
    }
    
    return returnInteger;
}

- (NSIndexPath *)cellIndexPathForAccessoryView:(id)accessoryView {
    NSIndexPath *returnIndexPath = [[[NSIndexPath alloc] init] autorelease];
    NSArray *visibleCellPaths = [self.tableView indexPathsForVisibleRows];
    
    for (NSIndexPath *path in visibleCellPaths) {
        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:path];
        if (currentCell.accessoryView == accessoryView) returnIndexPath = path;
    }

    return returnIndexPath;
}

#pragma mark - UITableViewCell Formatting Methods

- (UITableViewCell *)reusableOrNewTableCellWithIdentifier:(NSString *)reuseIdentifier cellStyle:(NSInteger)cellStyle {
    UITableViewCell *returnCell;
    
    returnCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(returnCell == nil) {
        returnCell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    return returnCell;
}

- (UITableViewCell *)multiValueCellFromRowDictionary:(NSDictionary *)rowDict {
    UITableViewCell *returnCell = [self reusableOrNewTableCellWithIdentifier:cellReuseIdentifierMultiValue cellStyle:UITableViewCellStyleValue1];
    
    NSString *rowTitle = [rowDict objectForKey:BAMSettingsTitle];
    returnCell.textLabel.text = [settingsBundle localizedStringForKey:rowTitle value:rowTitle table:stringsTable];
    
    NSInteger selectedRowTitlesIndex = [self selectedRowTitlesIndexForKey:[rowDict objectForKey:BAMSettingsKey] values:[rowDict objectForKey:BAMSettingsValues] defaultValue:[rowDict objectForKey:BAMSettingsDefaultValue]];
    NSArray *rowTitles = [rowDict objectForKey:BAMSettingsTitles];
    if (selectedRowTitlesIndex > -1) returnCell.detailTextLabel.text = [self formattedStringForTitle:[rowTitles objectAtIndex:selectedRowTitlesIndex] format:nil];
    
    returnCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return returnCell;
}

- (UITableViewCell *)toggleSwitchCellFromRowDictionary:(NSDictionary *)rowDict {
    UITableViewCell *returnCell = [self reusableOrNewTableCellWithIdentifier:cellReuseIdentifierToggleSwitch cellStyle:UITableViewCellStyleDefault];
    
    NSString *rowTitle = [rowDict objectForKey:BAMSettingsTitle];
    returnCell.textLabel.text = [settingsBundle localizedStringForKey:rowTitle value:rowTitle table:stringsTable];

    UISwitch *toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [toggleSwitch setOn:[self booleanForKey:[rowDict objectForKey:BAMSettingsKey] trueValue:[rowDict objectForKey:BAMSettingsTrueValue] falseValue:[rowDict objectForKey:BAMSettingsFalseValue] defaultValue:[rowDict objectForKey:BAMSettingsDefaultValue]]];
    [toggleSwitch addTarget:self action:@selector(updateUserDefaultsForAccessoryView:) forControlEvents:UIControlEventValueChanged];

    returnCell.accessoryView = toggleSwitch;
    [toggleSwitch release];
    
    return returnCell;
}

- (UITableViewCell *)textFieldCellFromRowDictionary:(NSDictionary *)rowDict {
    UITableViewCell *returnCell = [self reusableOrNewTableCellWithIdentifier:cellReuseIdentifierTextField cellStyle:UITableViewCellStyleDefault];
    
    NSString *rowTitle = [rowDict objectForKey:BAMSettingsTitle];
    returnCell.textLabel.text = [settingsBundle localizedStringForKey:rowTitle value:rowTitle table:stringsTable];
    
    // HACK: Hardcoding systemFontOfSize:17.0 because sizeWithFont:[[cell textLabel] font] doesn't work until after the cell has been displayed for the first time.
    CGSize textLabelSize = [returnCell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:17.0]];
    CGRect textFieldRect = CGRectMake(0.0, 0.0, returnCell.frame.size.width - textLabelSize.width - 60.0, 21.0);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    NSString *storedText = [[NSUserDefaults standardUserDefaults] objectForKey:[rowDict objectForKey:BAMSettingsKey]];
    if (storedText != nil) {
        NSString *storedTextTrimmed = [storedText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        textField.text = [settingsBundle localizedStringForKey:storedText value:storedTextTrimmed table:stringsTable];
    } else {
        NSString *defaultText = [rowDict objectForKey:BAMSettingsDefaultValue];
        if (defaultText != nil) {
            NSString *defaultTextTrimmed = [defaultText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            textField.text = [settingsBundle localizedStringForKey:defaultText value:defaultTextTrimmed table:stringsTable];
        }
    }
    
    NSNumber *isSecureField = [rowDict objectForKey:BAMSettingsIsSecure];
    if (isSecureField != nil && [isSecureField boolValue]) { // is a secure text field.
        textField.secureTextEntry = YES;
    } else { // is not a secure text field.
        textField.secureTextEntry = NO;
    }
    
    textField.autocapitalizationType = [self autocapsTypeFromKey:[rowDict objectForKey:BAMSettingsAutocapsType]];
    textField.autocorrectionType = [self autocorrectionTypeFromKey:[rowDict objectForKey:BAMSettingsAutocorrectionType]];
    textField.textAlignment = UITextAlignmentLeft; // Apple's settings app left justifies but it's unattractive.
    //textField.textAlignment = UITextAlignmentRight; // I prefer this but I'll let you decide what you want here.
    textField.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    textField.delegate = self;
    
    returnCell.accessoryView = textField;
    [textField release];

    return returnCell;
}

- (UITableViewCell *)sliderCellFromRowDictionary:(NSDictionary *)rowDict {
    UITableViewCell *returnCell = [self reusableOrNewTableCellWithIdentifier:cellReuseIdentifierSlider cellStyle:UITableViewCellStyleDefault];
    
    CGRect sliderRect = CGRectMake(0.0, 0.0, returnCell.frame.size.width - 38.0, 0.0);
    UISlider *sliderView = [[UISlider alloc] initWithFrame:sliderRect];
    sliderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    NSNumber *sliderMinValue = [rowDict objectForKey:BAMSettingsMinimumValue];
    NSNumber *sliderMaxValue = [rowDict objectForKey:BAMSettingsMaximumValue];
    if (sliderMinValue != nil) sliderView.minimumValue = [sliderMinValue floatValue];
    if (sliderMaxValue != nil) sliderView.maximumValue = [sliderMaxValue floatValue];

    NSNumber *storedNumber = [[NSUserDefaults standardUserDefaults] objectForKey:[rowDict objectForKey:BAMSettingsKey]];
    if (storedNumber != nil) {
        sliderView.value = [storedNumber floatValue];
    } else {
        NSNumber *defaultNumber = [rowDict objectForKey:BAMSettingsDefaultValue];
        if (defaultNumber != nil) sliderView.value = [defaultNumber floatValue];
    }
    
    NSString *sliderMinImage = [rowDict objectForKey:BAMSettingsMinimumValueImage];
    NSString *sliderMaxImage = [rowDict objectForKey:BAMSettingsMaximumValueImage];
    if (sliderMinImage != nil) sliderView.minimumValueImage = [UIImage imageNamed:(NSString *)sliderMinImage];
    if (sliderMaxImage != nil) sliderView.maximumValueImage = [UIImage imageNamed:(NSString *)sliderMaxImage];
    
    [sliderView addTarget:self action:@selector(updateUserDefaultsForAccessoryView:) forControlEvents:UIControlEventTouchUpInside];

    returnCell.accessoryView = sliderView;
    [sliderView release];
        
    return returnCell;
}    

- (UITableViewCell *)childPaneCellFromRowDictionary:(NSDictionary *)rowDict {
    UITableViewCell *returnCell = [self reusableOrNewTableCellWithIdentifier:cellReuseIdentifierChildPane cellStyle:UITableViewCellStyleDefault];
    
    NSString *rowTitle = [rowDict objectForKey:BAMSettingsTitle];
    returnCell.textLabel.text = [settingsBundle localizedStringForKey:rowTitle value:rowTitle table:stringsTable];
    
    returnCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return returnCell;
}

- (UITableViewCell *)titleValueCellFromRowDictionary:(NSDictionary *)rowDict {
    UITableViewCell *returnCell = [self reusableOrNewTableCellWithIdentifier:cellReuseIdentifierTitleValue cellStyle:UITableViewCellStyleValue1];
    
    NSString *rowTitle = [rowDict objectForKey:BAMSettingsTitle];
    returnCell.textLabel.text = [settingsBundle localizedStringForKey:rowTitle value:rowTitle table:stringsTable];
    
    NSInteger selectedRowTitlesIndex = [self selectedRowTitlesIndexForKey:[rowDict objectForKey:BAMSettingsKey] values:[rowDict objectForKey:BAMSettingsValues] defaultValue:[rowDict objectForKey:BAMSettingsDefaultValue]];
    NSArray *rowTitles = [rowDict objectForKey:BAMSettingsTitles];
    if (selectedRowTitlesIndex > -1) returnCell.detailTextLabel.text = [self formattedStringForTitle:[rowTitles objectAtIndex:selectedRowTitlesIndex] format:nil];
    
    return returnCell;
}

- (UITableViewCell *)unknownCellFromRowDictionary:(NSDictionary *)rowDict {
    UITableViewCell *returnCell = [self reusableOrNewTableCellWithIdentifier:cellReuseIdentifierUnknownType cellStyle:UITableViewCellStyleSubtitle];

    returnCell.textLabel.text = [settingsBundle localizedStringForKey:@"Unknown Type" value:@"Unknown Type" table:stringsTable];
    returnCell.textLabel.textColor = [UIColor lightGrayColor];

    NSString *rowType = [rowDict objectForKey:BAMSettingsType];
    if (rowType != nil) {
        returnCell.detailTextLabel.text = rowType;
        returnCell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    return returnCell;
}

#pragma mark - Action Methods

- (void)updateUserDefaultsForAccessoryView:(id)accessoryView {
    NSIndexPath *accessoryIndexPath = [self cellIndexPathForAccessoryView:accessoryView];
    NSArray *section = [sections objectAtIndex:[accessoryIndexPath section]];
    NSDictionary *rowDict = (NSDictionary *)[section objectAtIndex:[accessoryIndexPath row]];
    NSString *currentKey = [rowDict objectForKey:BAMSettingsKey];
    
    if ([accessoryView isKindOfClass:[UISwitch class]]) {
        UISwitch *selectedSwitch = (UISwitch *)accessoryView;
        id trueObject = [rowDict objectForKey:BAMSettingsTrueValue];
        id falseObject = [rowDict objectForKey:BAMSettingsFalseValue];
        if (selectedSwitch.on && trueObject != nil) {
            [self updateStoredValue:trueObject forKey:currentKey];
        }
        else if (!selectedSwitch.on && falseObject != nil) {
            [self updateStoredValue:falseObject forKey:currentKey];
        }
        else {
            [self updateStoredValue:[NSNumber numberWithBool:selectedSwitch.on]  forKey:currentKey];
        }
    } else if ([accessoryView isKindOfClass:[UITextField class]]) {
        UITextField *selectedTextField = (UITextField *)accessoryView;
        [self updateStoredValue:selectedTextField.text forKey:currentKey];
    } else if ([accessoryView isKindOfClass:[UISlider class]]) {
        UISlider *selectedSlider = (UISlider *)accessoryView;
        [self updateStoredValue:[NSNumber numberWithFloat:selectedSlider.value] forKey:currentKey];
    }
}

- (void)updateStoredValue:(id)valueObject forKey:(NSString *)key {
    haveSettingsBeenChanged = YES;
    [[NSUserDefaults standardUserDefaults] setObject:valueObject forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(settingsDidChangeValueForKey:)]) {
        [self.delegate settingsDidChangeValueForKey:key];
    }
}

- (void)scrollToMiddle:(NSIndexPath *)indexPath {
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - Keyboard Notification Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frameAfterKeyboardShows = self.view.frame;
    frameAfterKeyboardShows.size.height -= [self keyboardHeight:notification.userInfo];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    self.view.frame = frameAfterKeyboardShows;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frameAfterKeyboardHides = self.view.frame;
    frameAfterKeyboardHides.size.height += [self keyboardHeight:notification.userInfo];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    self.view.frame = frameAfterKeyboardHides;
    [UIView commitAnimations];
}

- (CGFloat)keyboardHeight:(NSDictionary *)userInfo {
    CGRect keyboardFrame = [self.view convertRect:[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    return keyboardFrame.size.height;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionHeaders count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionHeaders objectAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [sectionFooters objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    NSInteger returnCount = 0;
    if ([sections count] > 0 && [sections count] > section) returnCount = [(NSArray *)[sections objectAtIndex:section] count];
    return returnCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *section = [sections objectAtIndex:[indexPath section]];
    NSUInteger row = [indexPath row];
    NSDictionary *rowDict = (NSDictionary *)[section objectAtIndex:row];
    NSString *rowType = [rowDict objectForKey:BAMSettingsType]; 
    
    UITableViewCell *cell;
    if ([rowType isEqualToString:BAMSettingsTypeMultiValue]) {
        cell = [self multiValueCellFromRowDictionary:rowDict];
    } else if ([rowType isEqualToString:BAMSettingsTypeToggleSwitch]) {
        cell = [self toggleSwitchCellFromRowDictionary:rowDict];
    } else if ([rowType isEqualToString:BAMSettingsTypeTextField]) {
        cell = [self textFieldCellFromRowDictionary:rowDict];
    } else if ([rowType isEqualToString:BAMSettingsTypeSlider]) {
        cell = [self sliderCellFromRowDictionary:rowDict];
    } else if ([rowType isEqualToString:BAMSettingsTypeChildPane]) {
        cell = [self childPaneCellFromRowDictionary:rowDict];
    } else if ([rowType isEqualToString:BAMSettingsTypeTitleValue]) {
        cell = [self titleValueCellFromRowDictionary:rowDict];
    } else {
        cell = [self unknownCellFromRowDictionary:rowDict];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
             
#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    selectedCell.selected = NO;
    
    NSArray *section = [sections objectAtIndex:[indexPath section]];
    NSUInteger row = [indexPath row];
    NSDictionary *rowDict = (NSDictionary *)[section objectAtIndex:row];
    NSString *rowType = [rowDict objectForKey:BAMSettingsType];   
    
    if ([rowType isEqualToString:BAMSettingsTypeTextField]) {
        UITextField *selectedTextField = (UITextField *)selectedCell.accessoryView;
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [selectedTextField becomeFirstResponder];
    } else if ([rowType isEqualToString:BAMSettingsTypeMultiValue]) {
        NSString *selectedKey = [rowDict objectForKey:BAMSettingsKey];
        NSInteger selectedRowTitlesIndex = [self selectedRowTitlesIndexForKey:selectedKey values:[rowDict objectForKey:BAMSettingsValues] defaultValue:[rowDict objectForKey:BAMSettingsDefaultValue]];
        NSArray *formattedTitles = [self formattedArrayForTitles:[rowDict objectForKey:BAMSettingsTitles] format:nil];
        NSString *selectedTitle = [rowDict objectForKey:BAMSettingsTitle];
        NSString *selectedTitleLocalized = [settingsBundle localizedStringForKey:selectedTitle value:selectedTitle table:stringsTable];

        BAMSettingsDetail *settingsDetail = [[BAMSettingsDetail alloc] initWithTitle:selectedTitleLocalized rowTitles:formattedTitles selectedRow:selectedRowTitlesIndex forCellAtIndexPath:indexPath];
        
        settingsDetail.delegate = self;
        disableExitDelegateMethod = YES;
        [self.navigationController pushViewController:settingsDetail animated:YES];
        [settingsDetail release];
    } else if ([rowType isEqualToString:BAMSettingsTypeChildPane]) {
        NSString *selectedTitle = [rowDict objectForKey:BAMSettingsTitle];
        NSString *selectedTitleLocalized = [settingsBundle localizedStringForKey:selectedTitle value:selectedTitle table:stringsTable];
        
        BAMSettings *settings = [[BAMSettings alloc] initAsChildPaneWithTitle:selectedTitleLocalized propertyListNamed:[rowDict objectForKey:BAMSettingsFile]];
        
        settings.delegate = delegate;
        disableExitDelegateMethod = YES;
        [self.navigationController pushViewController:settings animated:YES];
        [settings release];
    } else if ([rowType isEqualToString:BAMSettingsTypeToggleSwitch]) {
        // This is not the behaviour of Apple's settings app but if you'd prefer for a tap in the row to change the value of the toggle switch, just uncomment the three lines below.
        //UISwitch *selectedSwitch = (UISwitch *)selectedCell.accessoryView;
        //[selectedSwitch setOn:!selectedSwitch.on animated:YES];
        //[self updateUserDefaultsForAccessoryView:selectedSwitch];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSIndexPath *textFieldIndexPath = [self cellIndexPathForAccessoryView:textField];
    [self performSelector:@selector(scrollToMiddle:) withObject:textFieldIndexPath afterDelay:0.0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self updateUserDefaultsForAccessoryView:textField];
    return YES;
}

#pragma mark - SettingsDetailViewDelegate Methods

- (void)settingsDetailSelectedRow:(NSInteger)row forCellIndexPath:(NSIndexPath *)indexPath {
    NSArray *section = [sections objectAtIndex:[indexPath section]];
    NSDictionary *rowDict = (NSDictionary *)[section objectAtIndex:[indexPath row]];
    NSArray *currentValues = (NSArray *)[rowDict objectForKey:BAMSettingsValues];
    
    [self updateStoredValue:[currentValues objectAtIndex:row] forKey:[rowDict objectForKey:BAMSettingsKey]];
    [self.tableView reloadData];
}

@end