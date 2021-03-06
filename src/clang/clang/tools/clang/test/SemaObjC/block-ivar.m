// RUN: clang-cc -fsyntax-only -verify %s -fblocks

@interface NSObject {
  struct objc_object *isa;
}
@end
@interface Foo : NSObject {
  int _prop;
}
@end

@implementation Foo
- (int)doSomething {
  int (^blk)(void) = ^{ return _prop; };
  return blk();
}

@end

