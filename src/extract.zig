// MIT License
//
// Copyright (c) 2023 Ferhat Geçdoğan All Rights Reserved.
// Distributed under the terms of the MIT License.
//
//

const fpaper_init = @import("file.zig");
const markers = @import("fpaper.zig");
const std = @import("std");

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

const fpaper_enum = markers.FPaperMarkers;
pub const FPaperExtract = struct {
    clone: fpaper_init.FPaper,
    extracted_text: []u8,

    is_start_marker: bool,
    is_start_marker_2: bool,
    is_start_marker_3: bool,
    is_start_marker_4: bool,
    is_start_marker_5: bool,
    is_start_marker_6: bool,

    is_start_of_text: bool,
    is_end_of_text: bool,

    is_style_marker: bool,

    is_left_align: bool,
    is_center_align: bool,
    is_right_align: bool,
    is_reset_align: bool,

    pub fn init_empty() FPaperExtract {
        return FPaperExtract{
            .clone = fpaper_init.FPaper.init_empty(),
            .extracted_text = "",

            .is_start_marker = false,
            .is_start_marker_2 = false,
            .is_start_marker_3 = false,
            .is_start_marker_4 = false,
            .is_start_marker_5 = false,
            .is_start_marker_6 = false,

            .is_start_of_text = false,
            .is_end_of_text = false,

            .is_style_marker = false,

            .is_left_align = false,
            .is_center_align = false,
            .is_right_align = false,
            .is_reset_align = false,
        };
    }

    pub fn detect_style(self: *FPaperExtract, ch: u8) !void {
        if (fpaper_enum.is_valid_marker(ch)) {
            const data: fpaper_enum = fpaper_enum.return_marker(ch);

            if (fpaper_enum.is_light_marker(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, "{s}\x1b[0m", .{self.extracted_text});
            } else if (fpaper_enum.is_bold_marker(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[1m", .{self.extracted_text});
            } else if (fpaper_enum.is_dim_marker(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[2m", .{self.extracted_text});
            } else if (fpaper_enum.is_italic_marker(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[3m", .{self.extracted_text});
            } else if (fpaper_enum.is_underlined_marker(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[4m", .{self.extracted_text});
            } else if (fpaper_enum.is_blink_marker(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[5m", .{self.extracted_text});
            } else if (fpaper_enum.is_rapid_blink_marker(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[6m", .{self.extracted_text});
            } else if (fpaper_enum.is_left_align(data)) {
                self.is_right_align = false;
                self.is_center_align = false;
                self.is_reset_align = false;
                self.is_left_align = true;
            } else if (fpaper_enum.is_center_align(data)) {
                self.is_right_align = false;
                self.is_reset_align = false;
                self.is_left_align = false;
                self.is_center_align = true;
            } else if (fpaper_enum.is_right_align(data)) {
                self.is_center_align = false;
                self.is_reset_align = false;
                self.is_left_align = false;
                self.is_right_align = true;
            } else if (fpaper_enum.is_reset_align(data)) {
                self.is_center_align = false;
                self.is_right_align = false;
                self.is_left_align = false;
                self.is_reset_align = false;
            } else if (fpaper_enum.is_color_reset(data)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[0m", .{self.extracted_text});
            } else {
                var val: u32 = @as(u32, @enumToInt(data));

                if ((val >= 40 and val <= 49) or (val >= 100 and val <= 109)) {
                    self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[{d}m", .{ self.extracted_text, val - 10 });
                }
            }
        } else {
            if ((ch >= 40 and ch <= 49) or (ch >= 100 and ch <= 109)) {
                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}\x1b[{d}m", .{ self.extracted_text, ch - 10 });
            }
        }
    }

    fn detect(self: *FPaperExtract, ch: u8) !void {
        if (self.is_style_marker) {
            try self.detect_style(ch);
            self.is_style_marker = false;
            return;
        }

        if (fpaper_enum.is_valid_marker(ch)) {
            const data: fpaper_enum = fpaper_enum.return_marker(ch);

            if (!self.is_start_marker) {
                self.is_start_marker = fpaper_enum.is_start_marker(data);
            } else if (!self.is_start_marker_2) {
                self.is_start_marker_2 = fpaper_enum.is_start_marker_2(data);
            } else if (!self.is_start_marker_3) {
                self.is_start_marker_3 = fpaper_enum.is_start_marker_3(data);
            } else if (!self.is_start_marker_4) {
                self.is_start_marker_4 = fpaper_enum.is_start_marker_4(data);
            } else if (!self.is_start_marker_5) {
                self.is_start_marker_5 = fpaper_enum.is_start_marker_5(data);
            } else if (!self.is_start_marker_6) {
                self.is_start_marker_6 = fpaper_enum.is_start_marker_6(data);
            } else if (!self.is_start_of_text) {
                self.is_start_of_text = fpaper_enum.is_start_of_text(data);
            } else {
                if (fpaper_enum.is_style_marker(data)) {
                    self.is_style_marker = true;
                    return;
                }

                if (fpaper_enum.is_end_of_text(data)) {
                    self.is_end_of_text = true;
                    return;
                }

                self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}{c}", .{ self.extracted_text, ch });
            }
        } else { // char
            self.extracted_text = try std.fmt.allocPrint(allocator, comptime "{s}{c}", .{ self.extracted_text, ch });
        }
    }

    pub fn compile(self: *FPaperExtract) !void {
        for (self.clone.raw_data[0..]) |ch| {
            if (self.is_end_of_text) {
                break;
            }

            try self.detect(ch);
        }
    }

    pub fn extract(self: *FPaperExtract) !void {
        try self.compile();
        try stdout.print("{s}\n", .{self.extracted_text});
    }
};
