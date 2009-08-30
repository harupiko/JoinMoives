//
//  JoinMoviesAppDelegate.m
//  JoinMovies
//
//  Created by Kohichi Aoki on 8/23/09.
//  Copyright 2009 drikin.com. All rights reserved.
//

#import "JoinMoviesAppDelegate.h"

#define EXPORT_FILENAME @"export.mov"

@implementation JoinMoviesAppDelegate

@synthesize window,thumbNailImageArray;

- (id)init
{
  thumbNailImageArray = [[NSMutableArray alloc] init];
  return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (QTMovie*)addMovieTo:(QTMovie*)movie fromPath:(NSString*)path;
{
  QTMovie *srcMovie = [QTMovie movieWithFile:path error:nil];
  
  NSURL *fileURL = [NSURL fileURLWithPath:path];
  NSString *fileName = [fileURL lastPathComponent];
  
  [thumbNailArrayController addObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [srcMovie posterImage], @"image",
                                   fileName,@"name",
                                   nil]];
  [movie insertSegmentOfMovie:srcMovie timeRange:QTMakeTimeRange(QTZeroTime, [srcMovie duration]) atTime:[movie duration]];
  return movie;
}

- (void)exportMovie:(QTMovie*)movie to:(NSString*)path;
{
  NSDictionary *exportAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], QTMovieFlatten, nil];
  
  [movie writeToFile:path withAttributes:exportAttributes];
}

- (void)joinMovieFromPaths:(NSArray*)paths;
{
  [loadingView setHidden:NO];
  [spinningView startAnimation:self];
  [window display];
  QTMovie *exportMovie;
  BOOL    isFirst = YES;
  
  [thumbNailArrayController removeObjects:[thumbNailArrayController arrangedObjects]];
  
  for( NSString *path in paths ){
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSString *fileName = [fileURL lastPathComponent];
    NSLog(@"%@", path);
    if( isFirst ) {
      exportMovie = [QTMovie movieWithFile:path error:nil];
      [exportMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
      [thumbNailArrayController addObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [exportMovie posterImage], @"image",
                                       fileName,@"name",
                                       nil]];
      isFirst = NO;      
    } else {
      exportMovie = [self addMovieTo:exportMovie fromPath:path];
    }
  }
  
  NSString *exportPath = [NSString stringWithFormat:@"%@/Desktop/%@", NSHomeDirectory(), EXPORT_FILENAME];
  [self exportMovie:exportMovie to:exportPath];
  [loadingView setHidden:YES];
  [spinningView stopAnimation:self];
  [thumbNailView setNeedsDisplay:YES];
  [window display];
  
  [[NSWorkspace sharedWorkspace] openFile:exportPath];
}

@end
