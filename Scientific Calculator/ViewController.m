//
//  ViewController.m
//  Scientific Calculator
//
//  Created by XCode Developer on 9/10/15.
//  Copyright (c) 2015 fsu. All rights reserved.
//

#import "ViewController.h"

/*
 Class Compute
 Objects are sent to this to make the computational portion
 of the calculator
*/
@implementation Compute
/*
	Pushes each number into programStack
*/
-(void)pushOperand:(double)operand
{
	NSNumber* num = [NSNumber numberWithDouble:operand];
	if(self.programStack == nil)
	{
		self.programStack = [[NSMutableArray alloc] init];
	}
	[self.programStack addObject:num];
}
/*
 Perform operation passed into parameter
*/
-(double)performOperation:(NSString *)operation
{
	double operand1, operand2, result;
	if ([operation isEqualToString:@"+"])
	{
		operand1 = [self popOperand];
		operand2 = [self popOperand];
		result = operand1 + operand2;
	}
	else if ([operation isEqualToString:@"-"])
	{
		operand2 = [self popOperand];
		operand1 = [self popOperand];
		result = operand1 - operand2;
	}
	else if([operation isEqualToString:@"/"])
	{
		operand2 = [self popOperand];
		operand1 = [self popOperand];
		if(operand1 != 0)
			result = operand1/operand2;
	}
	else if([operation isEqualToString:@"x"])
	{
		operand1 = [self popOperand];
		operand2 = [self popOperand];
		result = operand1*operand2;
	}
	else if ([operation isEqual:@"sin"])
	{
		operand1 = [self popOperand];
		result = sin(operand1);
	}
	else if ([operation isEqual:@"cos"])
	{
		operand1 = [self popOperand];
		result = cos(operand1);
	}
	else if ([operation isEqual:@"tan"])
	{
		operand1 = [self popOperand];
		result = tan(operand1);
	}
	else if([operation isEqual:@"log"])
	{
		operand1 = [self popOperand];
		result = log(operand1);
	}
	
	return result;
}


-(double)popOperand
{
	double value = [[self.programStack lastObject] doubleValue];
	[self.programStack removeLastObject];
	return value;
}

@end;



@implementation ViewController
//@synthesize operationUserHasPressed;
/*
 Continues to receive the number pressed until button not 
 representing a number is pressed. While still in this function,
 all numbers should be appended to a single string.
*/
@synthesize comp;
-(IBAction)digitPressed:(UIButton *)sender
{
	NSSet* functionOperators = [[NSSet alloc] initWithObjects:@"sin(",@"cos(",@"tan(",@"log(",nil];
	if([self.operationUserHasPressed isEqual:@"="] || [self.display.text isEqualToString: @"Syntax error"])
	{
		self.operationUserHasPressed = @"";
		self.display.text = @"0";
	}
	
	if(![self.display.text isEqual: @"0"]) // display is not cleared
	{
		// if there was a preceding operation function button pressed
		if ([functionOperators containsObject:self.display.text])
		{
			self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];
			self.display.text = [self.display.text stringByAppendingString:@")"];
			[self.comp pushOperand:[sender.currentTitle doubleValue]];
		}
		else
		{
			self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];
		}
	}
	else  // if label is clear (equals 0)
	{
		[self.display setText:[sender currentTitle]];
	}
}

/*
 Store front operand into stack then append operator to display. This is also
 where 'comp' is initialized since nothing can be computed without an operator.
 self.operationUserHasPressed is appended by that last operation that what pressed
*/
-(IBAction)operationSignPressed:(UIButton *)sender
{
	NSSet *functionOperators = [[NSSet alloc] initWithObjects:@"sin",@"cos",@"tan",@"log",nil];
	if ([self.display.text isEqual:@"0"] || [self.display.text isEqualToString:@"Syntax error"] || [self.operationUserHasPressed isEqual:@"="])
	{
		self.display.text = @"";
		self.operationUserHasPressed = @"";
	}
	self.comp = [[Compute alloc] init];
	
	// only allow one operation to be calculated at one time
	if ([self.operationUserHasPressed length] > 0)
	{
		self.operationUserHasPressed = [self.operationUserHasPressed stringByAppendingString:[sender currentTitle]];
	}
	else
	{
		self.operationUserHasPressed = [sender currentTitle];
//		NSLog(@"operatiionSignPressed operand to be pushed: &.2f", [self.display.text doubleValue]);
		[self.comp pushOperand:[self.display.text doubleValue]];
	}
	
	self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];

	if ([functionOperators containsObject:self.operationUserHasPressed])
	{
		self.display.text = [self.display.text stringByAppendingString:@"("];
	}
}

/*
 Extract operand "behind" the operator from the display then calculate..
*/
-(IBAction)equalSignPressed:(UIButton *)sender
{
	NSSet *functionOperators = [[NSSet alloc] initWithObjects:@"sin",@"cos",@"tan",@"log",nil];
	char lastCharacter = [self.display.text characterAtIndex:self.display.text.length-1];
	char firstCharacter = [self.display.text characterAtIndex:0];
	// if last character is not a number or end of operator function
	if(lastCharacter == '(' && !(lastCharacter > 48 && lastCharacter < 57))
	{
		[self.comp.programStack removeAllObjects];
		self.display.text = @"Syntax error";
		return;
	}
	
	// if there first character of string is an operator, invalid input
	if (firstCharacter == 'x' || firstCharacter == '/' || firstCharacter == '+' || firstCharacter == '-')
	{
		[self.comp.programStack removeAllObjects];
		self.display.text = @"Syntax error";
		return;
	}
	
	// Calculate if there are operands and not more than one operation button pressed
	if (/*[self.comp.programStack count] && */[self.operationUserHasPressed length] > 0)
	{
		NSMutableArray* operandList = [self.display.text componentsSeparatedByString:self.operationUserHasPressed];
		// get rid of par
		if ([functionOperators containsObject:self.operationUserHasPressed])
		{
			NSString* dirty = (NSString *)operandList.lastObject;
			NSString* clean = [dirty stringByReplacingOccurrencesOfString:@"("withString:@""];
			clean = [clean stringByReplacingOccurrencesOfString:@")"withString:@""];
			[operandList addObject:clean];
		}
		[self.comp pushOperand:[operandList.lastObject doubleValue]];
		// store calculation in result
		NSNumber* result = [NSNumber numberWithDouble:[self.comp performOperation:self.operationUserHasPressed]];

		if([[result stringValue] isEqual:@"inf"])  // result is invalid
			self.display.text = @"D.N.E";
		else																			 // result is valid, return
		{
			self.display.text = [result stringValue];
			self.operationUserHasPressed = @"=";
			return;
		}
	}
	else
	{
		self.display.text = @"Syntax error";
		[self.comp.programStack removeAllObjects];
		//self.operationUserHasPressed = @"";
	}
	self.operationUserHasPressed = @"";
}

-(IBAction)cancelButtonPressed:(UIButton *)sender
{
	[self.comp.programStack removeAllObjects];
	UIAlertController* message = [UIAlertController
	alertControllerWithTitle:@"Are you sure to clear the display?" message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No"style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
	UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style: UIAlertActionStyleDefault handler:^(UIAlertAction * action){[self.comp.programStack removeAllObjects]; self.display.text = @"0";} ];
	[message addAction:noAction];
	[message addAction:yesAction];
	[self presentViewController:message animated:YES completion:nil];
}
@end

