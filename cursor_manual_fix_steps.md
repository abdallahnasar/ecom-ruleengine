# Manual Steps to Fix Cursor Hanging Issues

Based on your logs, here are the immediate steps you should take to resolve the hanging issues:

## 🚨 IMMEDIATE FIXES (Do these first)

### 1. Kill All Cursor Processes
```bash
# Kill all Cursor processes
pkill -f "cursor"
pkill -f "Cursor"
sleep 3
# Force kill if needed
pkill -9 -f "cursor"
pkill -9 -f "Cursor"
```

### 2. Clear Problematic Cache Files
```bash
# Clean VM daemon cache (main culprit)
rm -rf ~/.vm-daemon/vm-daemon-cursor-data/Cache
rm -rf ~/.vm-daemon/vm-daemon-cursor-data/Code\ Cache
rm -rf ~/.vm-daemon/vm-daemon-cursor-data/GPUCache
rm -rf ~/.vm-daemon/vm-daemon-cursor-data/Crashpad
rm -rf ~/.vm-daemon/vm-daemon-cursor-data/logs

# Clean cursor server cache
rm -rf ~/.cursor-server/extensions
mkdir -p ~/.cursor-server/extensions

# Clean system temp files
rm -rf /tmp/.mount_Cursor*
rm -rf /tmp/cursor*
```

### 3. Fix File Watcher Limits (Critical for ptyHost issues)
```bash
# Increase inotify limits (fixes ptyHost heartbeat failures)
echo 524288 | sudo tee /proc/sys/fs/inotify/max_user_watches
echo 8192 | sudo tee /proc/sys/fs/inotify/max_user_instances

# Make permanent (add to /etc/sysctl.conf)
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.inotify.max_user_instances=8192" | sudo tee -a /etc/sysctl.conf
```

## 🛠️ CONFIGURATION FIXES

### 4. Create Optimized Settings File
Create or replace `~/.vm-daemon/vm-daemon-cursor-data/User/settings.json`:

```json
{
    "files.watcherExclude": {
        "**/node_modules/**": true,
        "**/.git/objects/**": true,
        "**/target/**": true,
        "**/build/**": true,
        "**/dist/**": true,
        "**/.cache/**": true
    },
    "terminal.integrated.enablePersistentSessions": false,
    "terminal.integrated.persistentSessionReviveProcess": "never",
    "terminal.integrated.localEchoLatencyThreshold": -1,
    "extensions.autoUpdate": false,
    "extensions.autoCheckUpdates": false,
    "editor.codeLens": false,
    "editor.minimap.enabled": false,
    "workbench.enableExperiments": false,
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "settingsSync.enabled": false,
    "git.autorefresh": false,
    "git.autofetch": false
}
```

### 5. Disable Hardware Acceleration
Create `~/.cursor-nightly/argv.json`:

```json
{
    "disable-hardware-acceleration": true,
    "disable-gpu": true,
    "disable-gpu-compositing": true,
    "no-sandbox": true,
    "disable-dev-shm-usage": true
}
```

## 🚀 STARTUP FIXES

### 6. Use Optimized Startup Command
Instead of just `./Cursor-1.0.1-x86_64.AppImage --no-sandbox`, use:

```bash
./Cursor-1.0.1-x86_64.AppImage \
  --no-sandbox \
  --disable-gpu \
  --disable-gpu-compositing \
  --disable-hardware-acceleration \
  --disable-dev-shm-usage \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding
```

### 7. Set Environment Variables
```bash
export ELECTRON_NO_ATTACH_CONSOLE=1
export ELECTRON_DISABLE_SECURITY_WARNINGS=1
export CURSOR_NO_SANDBOX=1
```

## 🔍 ROOT CAUSE ANALYSIS

Your logs show these specific issues:

1. **Extension host crashes**: Process 848358 exited - fixed by cache clearing
2. **File watcher crashes**: UtilityProcess crashed with code 15 - fixed by inotify limits
3. **ptyHost heartbeat failures**: Terminal communication - fixed by disabling persistent sessions
4. **GPU issues**: Theme resource loading failures - fixed by disabling hardware acceleration
5. **Authentication failures**: "Not logged in" errors - fixed by disabling sync features

## 🎯 TESTING STEPS

After applying fixes:

1. Wait 10 seconds before starting Cursor
2. Start with the optimized command above
3. Open a small project first (not a large repository)
4. Monitor with `htop` to check resource usage
5. Check logs with: `tail -f ~/.vm-daemon/vm-daemon-cursor-data/logs/*/main.log`

## 🔧 IF ISSUES PERSIST

1. **Restart your system** - clears all hanging processes and memory
2. **Try a different Cursor version** - download latest stable
3. **Check disk space**: `df -h` (you need at least 2GB free)
4. **Monitor memory**: `free -h` during Cursor usage
5. **Check for conflicting software**: VS Code, other Electron apps

## 🆘 EMERGENCY RESET

If nothing works, complete reset:

```bash
# Backup any important settings first!
rm -rf ~/.vm-daemon
rm -rf ~/.cursor-server
rm -rf ~/.cursor-nightly
rm -rf ~/.config/Cursor*
```

Then reinstall Cursor with the optimized settings above.