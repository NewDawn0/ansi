const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{
        .name = "ansi",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    b.installArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    run_step.dependOn(&run_cmd.step);
}
