const std = @import("std");

pub fn main() !void {
    const out = std.io.getStdOut();
    var buf = std.io.bufferedWriter(out.writer());
    var w = buf.writer();

    // Add single space at start because it looks better
    try w.print(" ", .{});

    // Range not inclusive
    inline for (31..38) |i| {
        try w.print("\x1b[{d};1m{d} ", .{ i, i });
    }

    // Reset and print newline
    try w.print("\x1b[0m\n", .{});

    // Flush to stdout
    try buf.flush();
}
