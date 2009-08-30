//
//  JoinMoviesAppDelegate.h
//  JoinMovies
//
//  Created by Kohichi Aoki on 8/23/09.
//  Copyright 2009 drikin.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface JoinMoviesAppDelegate : NSObject {
  NSWindow *window;
  IBOutlet id loadingView;
  IBOutlet id spinningView;
  IBOutlet id thumbNailView;
  IBOutlet id thumbNailArrayController;
  NSMutableArray *thumbNailImageArray;
}
@property (assign) IBOutlet NSWindow *window;
@property (retain) NSMutableArray *thumbNailImageArray;

- (QTMovie*)addMovieTo:(QTMovie*)movie fromPath:(NSString*)path;
- (void)exportMovie:(QTMovie*)movie to:(NSString*)path;
- (void)joinMovieFromPaths:(NSArray*)paths;

@end
