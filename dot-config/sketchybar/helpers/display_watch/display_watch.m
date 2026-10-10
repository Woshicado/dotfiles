// display_watch — run a command whenever the display topology changes.
//
// AeroSpace has no display added/removed hook and sketchybar's own
// display_change event only reports the *focused* display, so this registers
// for the CoreGraphics reconfiguration callbacks directly. It replaces the
// yabai display_* signals that used to drive display_guard.sh.
//
// Usage: display_watch <command>

#import <Cocoa/Cocoa.h>
#include <spawn.h>
#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>

extern char** environ;

// The changes yabai reported as display_added/removed/moved/resized. The
// begin-configuration callback and pure main-display/focus changes carry none
// of these and are ignored.
#define TOPOLOGY_FLAGS (kCGDisplayAddFlag                 \
                        | kCGDisplayRemoveFlag            \
                        | kCGDisplayMovedFlag             \
                        | kCGDisplaySetModeFlag           \
                        | kCGDisplayEnabledFlag           \
                        | kCGDisplayDisabledFlag          \
                        | kCGDisplayMirrorFlag            \
                        | kCGDisplayUnMirrorFlag          \
                        | kCGDisplayDesktopShapeChangedFlag)

static void display_handler(CGDirectDisplayID did, CGDisplayChangeSummaryFlags flags, void* context) {
  if (!(flags & TOPOLOGY_FLAGS)) return;

  char* command = context;
  char* argv[] = { command, NULL };
  pid_t pid;
  // The command is expected to return immediately (display_guard.sh detaches
  // its own debouncer), so reaping it synchronously is fine.
  if (posix_spawn(&pid, command, NULL, NULL, argv, environ) == 0) {
    waitpid(pid, NULL, 0);
  }
}

int main (int argc, char** argv) {
  if (argc < 2) {
    printf("Usage: %s \"<command>\"\n", argv[0]);
    exit(1);
  }

  // Leave sketchybar's process group: the command ends up killing sketchybar,
  // and launchd would otherwise take this process down with it.
  setsid();

  CGDisplayRegisterReconfigurationCallback(display_handler, argv[1]);

  // The callbacks for changes made by *other* processes (i.e. all real ones)
  // are only delivered by a running NSApplication; a bare CFRunLoop never sees
  // them. Prohibited keeps it out of the Dock and the app switcher.
  [NSApplication sharedApplication];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
  [NSApp run];
  return 0;
}
