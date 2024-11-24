const std = @import("std");

pub fn main() !void {
    const out = std.io.getStdOut();
    var buf = std.io.bufferedWriter(out.writer());
    var w = buf.writer();

    const reset = "\x1b[0m";
    const blue = "\x1b[34m";
    const cyan = "\x1b[36m";

    // Fmt
    try w.print("{s}FORMATTING:\n", .{blue});
    try w.print("  {s}printing:{s}  \\x1b[<COLORS>;<MODIFIERS>m\n", .{ cyan, reset });

    // Colors
    try w.print("{s}COLORS:\n  ", .{blue});
    inline for (31..38) |i| {
        try w.print("\x1b[{d};1m{d} ", .{ i, i });
    }
    try w.print("{s}\n", .{reset});

    // Modifiers
    try w.print("{s}MODIFIERS:\n", .{blue});
    try w.print("  \x1b[36;0mNormal:{s}       0\n", .{reset});
    try w.print("  \x1b[36;1mBold:{s}         1\n", .{reset});
    try w.print("  \x1b[36;3mItalicized:{s}   3\n", .{reset});
    try w.print("  \x1b[36;4mUnderlined:{s}   4\n", .{reset});
    try w.print("  \x1b[36;7mInverse:{s}      7\n", .{reset});
    try w.print("  \x1b[36;9mCrosssed-out:{s} 9\n", .{reset});

    // Flush to stdout
    try buf.flush();
}
