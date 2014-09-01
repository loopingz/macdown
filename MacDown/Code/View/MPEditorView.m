//
//  MPEditorView.m
//  MacDown
//
//  Created by Tzu-ping Chung  on 30/8.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPEditorView.h"

@interface MPEditorView ()

@property NSRect contentRect;

@end


@implementation MPEditorView

- (void)setFrameSize:(NSSize)newSize
{
    CGFloat inset = self.textContainerInset.height;
    CGFloat line = self.font.pointSize + self.defaultParagraphStyle.lineSpacing;
    CGFloat ch = self.contentRect.size.height + inset - line;
    CGFloat eh = self.enclosingScrollView.contentSize.height - inset - line;
    CGFloat offset = ch < eh ? ch : eh;
    if (offset > inset + line)
        newSize.height += offset;
    [super setFrameSize:newSize];
}

/** Overriden to perform extra operation on initial text setup.
 *
 * When we first launch the editor, -didChangeText will *not* be called, so we
 * override this to perform required resizing. The -updateContentRect is wrapped
 * inside an NSOperation to be invoked later since the layout manager will not
 * be invoked when the text is first set.
 *
 * @see didChangeText
 * @see updateContentRect
 */
- (void)setString:(NSString *)string
{
    [super setString:string];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateContentRect];
    }];
}

/** Overriden to perform extra operation on text change.
 *
 * Updates content height, and invoke the resizing method to apply it.
 *
 * @see updateContentRect
 */
- (void)didChangeText
{
    [super didChangeText];
    [self updateContentRect];
}

- (void)updateContentRect
{
    self.contentRect =
        [self.layoutManager usedRectForTextContainer:self.textContainer];
    [self setFrameSize:self.frame.size];    // Force -setFrameSize.
}

@end
