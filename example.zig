const fpaper = @import("./src/file.zig");
const fpaper_extract = @import("./src/extract.zig");
const std = @import("std");

const allocator = std.heap.page_allocator;

pub fn main() !void {
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const stdout = std.io.getStdOut().writer();
    _ = stdout;

    if (args.len < 2) {
        std.os.exit(1);
    }

    var data: fpaper.FPaper = fpaper.FPaper.init_empty();
    try data.init_by_file(args[1]);
    var extract: fpaper_extract.FPaperExtract = fpaper_extract.FPaperExtract.init_empty();
    extract.clone = data;
    try extract.extract();
}
