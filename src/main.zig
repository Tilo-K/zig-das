const std = @import("std");

fn Queue(comptime T: type) !type {
    const q = struct {
        const Self = @This();
        data: std.ArrayList(T),

        pub fn enqueue(self: *Self, value: T) !void {
            try self.data.append(value);
        }

        pub fn pop(self: *Self) T {
            return self.data.orderedRemove(0);
        }

        pub fn peek(self: *Self) T {
            return self.data.items[0];
        }

        pub fn init(alloc: std.mem.Allocator) Self {
            const l = std.ArrayList(T);
            const list = l.init(alloc);

            return Self{ .data = list };
        }

        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }
    };

    return q;
}

pub fn main() !void {
    // Nothing here :)
}

test "Queue usage" {
    const test_alloc = std.testing.allocator;
    var q = (try Queue(u32)).init(test_alloc);
    defer q.deinit();

    try q.enqueue(1);
    try q.enqueue(2);
    try q.enqueue(3);
    try q.enqueue(4);

    try std.testing.expect(q.pop() == 1);
    try std.testing.expect(q.pop() == 2);
    try std.testing.expect(q.pop() == 3);
    try std.testing.expect(q.peek() == 4);
    try std.testing.expect(q.pop() == 4);
}
