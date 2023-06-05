// MIT License
//
// Copyright (c) 2023 Ferhat Geçdoğan All Rights Reserved.
// Distributed under the terms of the MIT License.
//
//

const std = @import("std");
const os = std.os;
const allocator = std.heap.page_allocator;

pub const FPaper = struct {
    raw_data: []u8,

    pub fn init_empty() FPaper {
        return FPaper{
            .raw_data = undefined,
        };
    }

    pub fn init(file_data: *[]u8) FPaper {
        return FPaper{
            .raw_data = *file_data,
        };
    }

    pub fn init_by_file(self: *FPaper, file_name: []const u8) !void {
        var file = try std.fs.cwd().openFile(file_name, .{});
        defer file.close();

        const file_size = (try file.stat()).size;
        var buffer = try allocator.alloc(u8, file_size);

        const bytes_read = try file.read(buffer[0..buffer.len]);

        self.raw_data = buffer[0..bytes_read];
    }
};
