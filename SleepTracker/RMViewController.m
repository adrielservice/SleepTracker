//
//  RMViewController.m
//  RMDateSelectionViewController-Demo
//
//  Created by David Beilis on 26.10.13.
//  Copyright (c) 2013-2015 Roland Moers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RMViewController.h"
#import "HealthKitManager.h"

@interface RMViewController ()

@property (nonatomic, weak) IBOutlet UILabel *lblStartTime;
@property (nonatomic, weak) IBOutlet UILabel *lblEndTime;

@property (nonatomic, weak) NSDate *startTime;
@property (nonatomic, weak) NSDate *endTime;

@end

@implementation RMViewController

- (void) presentTimeSelectionController:(NSString*)title andDate:(NSDate*)inputDate andHandler:(nullable void (^)(RMActionController * __nonnull))successHandler {
    
    inputDate = (inputDate) ? inputDate : [NSDate date];
    
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    style = RMActionControllerStyleBlack;
    
    RMAction<RMActionController<UIDatePicker *> *> *selectAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:successHandler];
    
    RMAction<RMActionController<UIDatePicker *> *> *cancelAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = title;
    dateSelectionController.message = @"Please choose a date and press 'Select' or 'Cancel'.";
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    RMAction<RMActionController<UIDatePicker *> *> *in15MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"15 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:15*60];
        NSLog(@"15 Min button tapped");
    }];
    in15MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in30MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"30 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:30*60];
        NSLog(@"30 Min button tapped");
    }];
    in30MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in45MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"45 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:45*60];
        NSLog(@"45 Min button tapped");
    }];
    in45MinAction.dismissesActionController = NO;
    
    RMAction<RMActionController<UIDatePicker *> *> *in60MinAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"60 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:60*60];
        NSLog(@"60 Min button tapped");
    }];
    in60MinAction.dismissesActionController = NO;
    
    RMGroupedAction<RMActionController<UIDatePicker *> *> *groupedAction = [RMGroupedAction<RMActionController<UIDatePicker *> *> actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];
    
    [dateSelectionController addAction:groupedAction];
    
    RMAction<RMActionController<UIDatePicker *> *> *nowAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
        controller.contentView.date = [NSDate date];
        NSLog(@"Now button tapped");
    }];
    nowAction.dismissesActionController = NO;
    
    [dateSelectionController addAction:nowAction];
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = FALSE;
    dateSelectionController.disableMotionEffects = FALSE;
    dateSelectionController.disableBlurEffects = TRUE;
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = inputDate;
    
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        dateSelectionController.popoverPresentationController.sourceView = self.tableView;
        dateSelectionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
    
}

#pragma mark - Actions
- (IBAction)openStartTimeSelectionController:(id)sender {
    [self presentTimeSelectionController:@"Start time" andDate:self.startTime andHandler:^(RMActionController<UIDatePicker *> *controller) {
        // NSDate* localDateTime = [NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:controller.contentView.date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *time = [dateFormatter stringFromDate:controller.contentView.date];
        self.lblStartTime.text = time;
        self.startTime = controller.contentView.date;
        NSLog(@"Successfully selected start time: %@", time);
    }];
}

- (IBAction)openEndTimeSelectionController:(id)sender {
    [self presentTimeSelectionController:@"End time" andDate:self.endTime andHandler:^(RMActionController<UIDatePicker *> *controller) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *time = [dateFormatter stringFromDate:controller.contentView.date];
        self.lblEndTime.text = time;
        self.endTime = controller.contentView.date;
        NSLog(@"Successfully selected end time: %@", time);
    }];
}

- (IBAction)submitDateToHealthApp:(id)sender {
    if (self.startTime && self.endTime) {
        [[HealthKitManager sharedManager] writeSleepData:self.startTime andEndTime:self.endTime];
    } else {
        NSLog(@"Sleeping interval is not defined.");
    }
}

#pragma mark - UITableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self openStartTimeSelectionController:self];
        } else if (indexPath.row == 1) {
            [self openEndTimeSelectionController:self];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"Submitting health analisys data");
            [self submitDateToHealthApp:nil];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
