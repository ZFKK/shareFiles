//
//  UIViewControllerTest.m
//  
//
//  Created by sunkai on 16/11/19.
//
//

#import <XCTest/XCTest.h>

@interface UIViewControllerTest : XCTestCase

@end

@implementation UIViewControllerTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    
    
    [super tearDown];
}

- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    XCUIElement *itemButton = [[[tabBarsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Item"] elementBoundByIndex:0];
    [itemButton tap];
    [[[[tabBarsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Item"] elementBoundByIndex:1] tap];
    [[[[tabBarsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Item"] elementBoundByIndex:2] tap];
    [[[[tabBarsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Item"] elementBoundByIndex:3] tap];
    [itemButton tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"8"] tap];
    [[[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"19"] childrenMatchingType:XCUIElementTypeStaticText] matchingIdentifier:@"19"] elementBoundByIndex:0] swipeUp];
    [[[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"27"] childrenMatchingType:XCUIElementTypeStaticText] matchingIdentifier:@"27"] elementBoundByIndex:0] swipeUp];
    [[[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"37"] childrenMatchingType:XCUIElementTypeStaticText] matchingIdentifier:@"37"] elementBoundByIndex:0] swipeUp];
    
    XCUIElement *element = [[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [[[element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTable].element swipeUp];
    
    XCUIElement *staticText = [[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"99"] childrenMatchingType:XCUIElementTypeStaticText] matchingIdentifier:@"99"] elementBoundByIndex:0];
    [staticText tap];
    [[[[app.navigationBars[@"UIView"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    [staticText tap];
    [element tap];
    [tablesQuery.staticTexts[@"93"] tap];
    [[[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"72"] childrenMatchingType:XCUIElementTypeStaticText] matchingIdentifier:@"72"] elementBoundByIndex:0] swipeDown];
    [[[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"22"] childrenMatchingType:XCUIElementTypeStaticText] matchingIdentifier:@"22"] elementBoundByIndex:0] swipeDown];
    [[[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"0"] childrenMatchingType:XCUIElementTypeStaticText] matchingIdentifier:@"0"] elementBoundByIndex:0] tap];
    [tablesQuery.staticTexts[@"1"] tap];
    [tablesQuery.staticTexts[@"2"] tap];
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
