// MIT License
//
// Copyright (c) 2023 Ferhat Geçdoğan All Rights Reserved.
// Distributed under the terms of the MIT License.
//
//

const std = @import("std");
const fpaper = @import("file.zig");
const extract = @import("extract.zig");

pub const FPaperMarkers = enum(u8) {
    StartMarker = 0x02,
    StartMarker2 = 0x46,
    StartMarker3 = 0x50,
    StartMarker4 = 0x61,
    StartMarker5 = 0x67,
    StartMarker6 = 0x65,

    StartOfText = 0x26,
    EndOfText = 0x15,

    StyleMarker = 0x1A,
    LightSet = 0x30,
    BoldSet = 0x31,
    DimSet = 0x32,
    ItalicSet = 0x33,
    UnderlinedSet = 0x34,
    BlinkSet = 0x35,
    RapidBlinkSet = 0x36,

    ColorReset = 0x72,

    // These styles must be rendered by renderer implementation
    AlignLeftSet = 0x7B,
    AlignCenterSet = 0x7C,
    AlignRightSet = 0x7D,
    AlignReset = 0x7E,

    pub fn is_valid_marker(ch: u8) bool {
        return (ch == 0x02 or
            ch == 0x46 or
            ch == 0x50 or
            ch == 0x61 or
            ch == 0x67 or
            ch == 0x65 or
            ch == 0x26 or
            ch == 0x15 or
            ch == 0x1A or
            ((ch >= 0x30) and (ch <= 0x36)) or
            ch == 0x72 or
            ch == 0x7B or
            ch == 0x7C or
            ch == 0x7D or
            ch == 0x7E);
    }

    pub fn return_marker(ch: u8) FPaperMarkers {
        return switch (ch) {
            0x02 => FPaperMarkers.StartMarker,
            0x46 => FPaperMarkers.StartMarker2,
            0x50 => FPaperMarkers.StartMarker3,
            0x61 => FPaperMarkers.StartMarker4,
            0x67 => FPaperMarkers.StartMarker5,
            0x65 => FPaperMarkers.StartMarker6,
            0x26 => FPaperMarkers.StartOfText,
            0x15 => FPaperMarkers.EndOfText,
            0x1A => FPaperMarkers.StyleMarker,
            0x30 => FPaperMarkers.LightSet,
            0x31 => FPaperMarkers.BoldSet,
            0x32 => FPaperMarkers.DimSet,
            0x33 => FPaperMarkers.ItalicSet,
            0x34 => FPaperMarkers.UnderlinedSet,
            0x35 => FPaperMarkers.BlinkSet,
            0x36 => FPaperMarkers.RapidBlinkSet,
            0x72 => FPaperMarkers.ColorReset,
            0x7B => FPaperMarkers.AlignLeftSet,
            0x7C => FPaperMarkers.AlignCenterSet,
            0x7D => FPaperMarkers.AlignRightSet,
            0x7E => FPaperMarkers.AlignReset,

            else => FPaperMarkers.EndOfText,
        };
    }

    pub fn is_start_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StartMarker;
    }
    pub fn is_start_marker_2(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StartMarker2;
    }
    pub fn is_start_marker_3(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StartMarker3;
    }
    pub fn is_start_marker_4(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StartMarker4;
    }
    pub fn is_start_marker_5(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StartMarker5;
    }
    pub fn is_start_marker_6(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StartMarker6;
    }
    pub fn is_start_of_text(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StartOfText;
    }
    pub fn is_end_of_text(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.EndOfText;
    }
    pub fn is_style_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.StyleMarker;
    }
    pub fn is_light_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.LightSet;
    }
    pub fn is_bold_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.BoldSet;
    }
    pub fn is_dim_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.DimSet;
    }
    pub fn is_italic_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.ItalicSet;
    }
    pub fn is_underlined_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.UnderlinedSet;
    }
    pub fn is_blink_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.BlinkSet;
    }
    pub fn is_rapid_blink_marker(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.RapidBlinkSet;
    }
    pub fn is_color_reset(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.ColorReset;
    }
    pub fn is_left_align(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.AlignLeftSet;
    }
    pub fn is_center_align(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.AlignCenterSet;
    }
    pub fn is_right_align(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.AlignRightSet;
    }
    pub fn is_reset_align(ch: FPaperMarkers) bool {
        return ch == FPaperMarkers.AlignReset;
    }
};
