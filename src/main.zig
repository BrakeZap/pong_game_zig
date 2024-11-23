//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const raylib = @import("raylib");

pub fn main() !void {
    raylib.initWindow(800, 600, "Pong Game Zig");
    while (!raylib.windowShouldClose()) {
        raylib.clearBackground(raylib.Color{
            .a = 0,
            .r = 0,
            .b = 0,
            .g = 0,
        });
        raylib.beginDrawing();
        raylib.drawText("Hello World", 400, 200, 50, raylib.Color.init(255, 255, 255, 255));
        raylib.endDrawing();
    }
    raylib.closeWindow();
}
