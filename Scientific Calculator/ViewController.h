//
//  ViewController.h
//  Scientific Calculator
//
//  Created by XCode Developer on 9/10/15.
//  Copyright (c) 2015 fsu. All rights reserved.
//
/*
 9/15/15
 Subclasses of UIViewController are used to declare objects.
 UILabel class implementsa read-only text view.
 
 If buttons next to each other in a view, it is up to the controller to decide
 how the buttons should grow if there is extra room.
 
 operationUserHasPressed will keep track of the last operation button
 user has pressed.

 Using xcode 7, math.h is automatically imported.
 */

#import <UIKit/UIKit.h>
/*
 Class Compute
 */
@interface Compute : NSObject

@property (nonatomic, strong) NSMutableArray *programStack;
-(void) pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(double)popOperand;

@end

@interface ViewController : UIViewController

@property (nonatomic, strong) Compute *comp;
@property (nonatomic, weak) NSString *operationUserHasPressed;
@property (strong, nonatomic) IBOutlet UILabel *display;

/*
 // inline defined actions
-(IBAction)digitPressed:(UIButton *)sender;
-(IBAction)equalSignPressed:(UIButton *)sender;
-(IBAction)operationSignPressed:(UIButton *)sender;
-(IBAction)cancelButtonPressed:(UIButton *)sender;
*/
@end



/*
 - @synthesize properties when custom getter/setter functions implemented.
 - _<property> uses the autosynthesized properties; auto creates 'iVar'.
 -(UIButton *)sender is not required for the action methods unless there are
 multiple buttons connected to a single method (for button distinction).
 -IBOutlet connects an object in the UI to instance variables.
 -It is not guaranteed that the setter/ getter will set/get a whole value.
 -Assign vs weak vs retain vs copy determines how the synthesized accessors interact with
 the Objective-C memory management scheme. ASSIGN is the default and simply performs a
 variable assignment. It does not assert ownership, so the object pointed to by the
 property's pointer may disappear at any time WEAK is identical to assign, except that it
 will zero out pointers that lead to deallocated objects to stop them from dangling. Weak
 is only available in an ARC environment.
 
*/