const std = @import("std");
const raylib = @import("raylib");

const Game = struct {
    const GameState = enum { start, running };

    var leftRect = raylib.Rectangle.init(50, 150, 50, 150);
    var rightRect = raylib.Rectangle.init(700, 150, 50, 150);

    var pong = raylib.Vector2.init(800 / 2, 600 / 2);

    var ballSpeed = raylib.Vector2.init(0, 0);
    var currState = GameState.start;

    pub fn inputHandler() void {
        const speed = 5;

        if (raylib.isKeyDown(raylib.KeyboardKey.key_w) and leftRect.y - speed >= 0) {
            leftRect.y -= speed;
        }
        if (raylib.isKeyDown(raylib.KeyboardKey.key_s) and leftRect.y + speed <= 450) {
            leftRect.y += speed;
        }
        if (raylib.isKeyDown(raylib.KeyboardKey.key_up) and rightRect.y - speed >= 0) {
            rightRect.y -= speed;
        }
        if (raylib.isKeyDown(raylib.KeyboardKey.key_down) and rightRect.y + speed <= 450) {
            rightRect.y += speed;
        }

        if (raylib.isKeyDown(raylib.KeyboardKey.key_space) and currState == GameState.start) {
            currState = GameState.running;
            const rand1: usize = @intCast(raylib.getRandomValue(0, 1));
            const rand2: usize = @intCast(raylib.getRandomValue(0, 1));

            const randArr = [2]f32{ -5, 5 };

            const ballSpeedX = randArr[rand1];
            const ballSpeedY = randArr[rand2];

            ballSpeed = raylib.Vector2.add(raylib.Vector2.init(ballSpeedX, ballSpeedY), ballSpeed);
        }
    }

    pub fn handleCollisions() void {
        if (pong.y > @as(f32, @floatFromInt(raylib.getScreenHeight())) - 15.0 or pong.y <= 15) {
        ballSpeed.y *= -1;
  } 

        if (raylib.checkCollisionCircleRec(pong, 15, leftRect) or raylib.checkCollisionCircleRec(pong, 15, rightRect)){
            ballSpeed.x *= -1;
        }

        //Pong went out of bounds
        if (pong.x > @as(f32, @floatFromInt(raylib.getScreenWidth())) - 15.0 or pong.x <= 15) {
            pong.x = @floatFromInt(@divFloor(raylib.getScreenWidth(), 2));
            pong.y = @floatFromInt(@divFloor(raylib.getScreenHeight(), 2));
            ballSpeed.x = 0;
            ballSpeed.y = 0;
            currState = GameState.start;
        }
    }

};

pub fn main() !void {
    initGame();
    const game = Game;
    while (!raylib.windowShouldClose()) {
        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.drawRectangleRec(Game.leftRect, raylib.Color.init(255, 255, 255, 255));
        raylib.drawRectangleRec(Game.rightRect, raylib.Color.init(255, 255, 255, 255));

        raylib.drawCircleV(Game.pong, 15, raylib.Color.init(255, 255, 255, 255));

        game.inputHandler();
        game.handleCollisions();
        if (game.currState == game.GameState.start) { 
            raylib.drawText("Press space to start!", 800/2-290, 550, 50, raylib.Color.init(255,255,255,255));
        }
        raylib.clearBackground(raylib.Color{
            .a = 0,
            .r = 0,
            .b = 0,
            .g = 0,
        });

        Game.pong = raylib.Vector2.add(Game.pong, Game.ballSpeed);

    }
    raylib.closeWindow();
}

fn initGame() void {
    const width = 800;
    const height = 600;
    raylib.initWindow(width, height, "Pong Game");
    raylib.hideCursor();
    //raylib.DisableCursor();
    raylib.setTargetFPS(60);
}
