const std = @import("std");

const out = std.io.getStdOut();
var buf = std.io.bufferedWriter(out.writer());
var w = buf.writer();

const reset = "\x1b[0m";
const blue = "\x1b[34m";
const cyan = "\x1b[36m";

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    if (args.len > 1) {
        const arg = args[1];
        if (std.mem.eql(u8, arg, "-h") or std.mem.eql(u8, arg, "--help")) {
            try help();
        } else if (std.mem.eql(u8, arg, "-s") or std.mem.eql(u8, arg, "--short")) {
            try short();
        } else if (std.mem.eql(u8, arg, "-l") or std.mem.eql(u8, arg, "--long")) {
            try long();
        } else {
            try w.print("Unknown option: {s}\n", .{arg});
            try help();
            return try buf.flush();
        }
    } else {
        try short();
    }
    return try buf.flush();
}

fn help() !void {
    try w.print("Usage:\n" ++
        " -h, --help  Show this help message\n" ++
        " -s, --short Show short output (default)\n" ++
        " -l, --long Show long output\n", .{});
}

fn short() !void {
    // Colors
    try w.print("{s}COLORS:\n  ", .{blue});
    inline for (31..38) |i| {
        try w.print("\x1b[{d};1m{d} ", .{ i, i });
    }
    try w.print("{s}\n", .{reset});
}

fn long() !void {
    try w.print("{s}FORMATTING:\n" ++
        "  {s}printing:{s}  \\x1b[<COLORS>;<MODIFIERS>m\n", .{ blue, cyan, reset });

    try short();

    // Modifiers
    try w.print("{s}MODIFIERS:\n" ++
        "  \x1b[36;0mNormal:{s}       0\n" ++
        "  \x1b[36;1mBold:{s}         1\n" ++
        "  \x1b[36;3mItalicized:{s}   3\n" ++
        "  \x1b[36;4mUnderlined:{s}   4\n" ++
        "  \x1b[36;7mInverse:{s}      7\n" ++
        "  \x1b[36;9mCrosssed-out:{s} 9\n", .{ blue, reset, reset, reset, reset, reset, reset });
}
