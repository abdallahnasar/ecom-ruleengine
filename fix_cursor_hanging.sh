#!/bin/bash

echo "🔧 Cursor Hanging Issues Fix Script"
echo "=================================="

# Function to safely kill Cursor processes
kill_cursor_processes() {
    echo "📋 Step 1: Killing existing Cursor processes..."
    pkill -f "cursor" 2>/dev/null || true
    pkill -f "Cursor" 2>/dev/null || true
    sleep 3
    
    # Force kill if still running
    pkill -9 -f "cursor" 2>/dev/null || true
    pkill -9 -f "Cursor" 2>/dev/null || true
    echo "✅ Cursor processes terminated"
}

# Function to clean cache and temporary files
clean_cursor_cache() {
    echo "🧹 Step 2: Cleaning Cursor cache and temporary files..."
    
    # Clean VM daemon cursor data cache
    if [ -d "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data" ]; then
        echo "Cleaning VM daemon cursor data..."
        rm -rf "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/Cache" 2>/dev/null || true
        rm -rf "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/Code Cache" 2>/dev/null || true
        rm -rf "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/GPUCache" 2>/dev/null || true
        rm -rf "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/DawnGraphiteCache" 2>/dev/null || true
        rm -rf "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/DawnWebGPUCache" 2>/dev/null || true
        rm -rf "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/Crashpad" 2>/dev/null || true
        rm -rf "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/logs" 2>/dev/null || true
        echo "✅ VM daemon cache cleaned"
    fi
    
    # Clean cursor server extensions
    if [ -d "/home/ubuntu/.cursor-server" ]; then
        echo "Cleaning cursor server cache..."
        rm -rf "/home/ubuntu/.cursor-server/extensions" 2>/dev/null || true
        mkdir -p "/home/ubuntu/.cursor-server/extensions" 2>/dev/null || true
        echo "✅ Cursor server cache cleaned"
    fi
    
    # Clean system temporary files
    echo "Cleaning system temporary files..."
    rm -rf /tmp/.mount_Cursor* 2>/dev/null || true
    rm -rf /tmp/cursor* 2>/dev/null || true
    find /tmp -name "*cursor*" -type f -delete 2>/dev/null || true
    echo "✅ System temporary files cleaned"
}

# Function to fix file watcher issues
fix_file_watcher() {
    echo "📁 Step 3: Fixing file watcher issues..."
    
    # Increase inotify limits
    echo "Increasing inotify limits..."
    echo 524288 | sudo tee /proc/sys/fs/inotify/max_user_watches > /dev/null 2>&1 || true
    echo 8192 | sudo tee /proc/sys/fs/inotify/max_user_instances > /dev/null 2>&1 || true
    
    # Make the changes persistent
    if [ -w /etc/sysctl.conf ]; then
        grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf || echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
        grep -q "fs.inotify.max_user_instances" /etc/sysctl.conf || echo "fs.inotify.max_user_instances=8192" >> /etc/sysctl.conf
    fi
    
    echo "✅ File watcher limits increased"
}

# Function to create optimized Cursor settings
create_optimized_settings() {
    echo "⚙️  Step 4: Creating optimized Cursor settings..."
    
    # Create settings directory if it doesn't exist
    mkdir -p "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/User" 2>/dev/null || true
    
    # Create optimized settings.json
    cat > "/home/ubuntu/.vm-daemon/vm-daemon-cursor-data/User/settings.json" << 'EOF'
{
    // Performance optimizations
    "files.watcherExclude": {
        "**/node_modules/**": true,
        "**/.git/objects/**": true,
        "**/.git/subtree-cache/**": true,
        "**/target/**": true,
        "**/build/**": true,
        "**/dist/**": true,
        "**/.next/**": true,
        "**/.cache/**": true
    },
    "search.exclude": {
        "**/node_modules": true,
        "**/bower_components": true,
        "**/.git": true,
        "**/target": true,
        "**/build": true,
        "**/dist": true,
        "**/.next": true
    },
    
    // Terminal optimizations
    "terminal.integrated.enablePersistentSessions": false,
    "terminal.integrated.persistentSessionReviveProcess": "never",
    "terminal.integrated.localEchoLatencyThreshold": -1,
    "terminal.integrated.smoothScrolling": false,
    "terminal.integrated.fastScrollSensitivity": 5,
    
    // Extension optimizations
    "extensions.autoUpdate": false,
    "extensions.autoCheckUpdates": false,
    
    // Editor optimizations
    "editor.codeLens": false,
    "editor.minimap.enabled": false,
    "editor.hover.enabled": true,
    "editor.hover.delay": 1500,
    "editor.quickSuggestions": {
        "other": false,
        "comments": false,
        "strings": false
    },
    
    // Disable problematic features
    "workbench.enableExperiments": false,
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "workbench.settings.enableNaturalLanguageSearch": false,
    
    // File sync optimizations
    "settingsSync.enabled": false,
    "configurationSync.enabled": false,
    
    // Git optimizations
    "git.enabled": true,
    "git.autorefresh": false,
    "git.autofetch": false,
    "scm.diffDecorations": "none"
}
EOF
    
    echo "✅ Optimized settings created"
}

# Function to fix AppImage permissions
fix_appimage_permissions() {
    echo "🔐 Step 5: Fixing AppImage permissions..."
    
    # Find AppImage file
    APPIMAGE_PATH=$(find ~/Downloads -name "Cursor*.AppImage" -type f 2>/dev/null | head -1)
    
    if [ -n "$APPIMAGE_PATH" ]; then
        echo "Found AppImage: $APPIMAGE_PATH"
        chmod +x "$APPIMAGE_PATH"
        echo "✅ AppImage permissions fixed"
    else
        echo "⚠️  No AppImage found in ~/Downloads"
    fi
}

# Function to disable hardware acceleration
disable_hardware_acceleration() {
    echo "🎮 Step 6: Disabling hardware acceleration for stability..."
    
    # Create argv.json to disable hardware acceleration
    mkdir -p "/home/ubuntu/.cursor-nightly" 2>/dev/null || true
    cat > "/home/ubuntu/.cursor-nightly/argv.json" << 'EOF'
{
    "disable-hardware-acceleration": true,
    "disable-gpu": true,
    "disable-gpu-compositing": true,
    "disable-gpu-rasterization": true,
    "disable-gpu-sandbox": true,
    "no-sandbox": true,
    "disable-dev-shm-usage": true,
    "disable-extensions-except": [],
    "disable-background-timer-throttling": true,
    "disable-backgrounding-occluded-windows": true,
    "disable-renderer-backgrounding": true
}
EOF
    
    echo "✅ Hardware acceleration disabled"
}

# Main execution
main() {
    echo "Starting Cursor fix process..."
    echo "Time: $(date)"
    echo ""
    
    kill_cursor_processes
    echo ""
    
    clean_cursor_cache
    echo ""
    
    fix_file_watcher
    echo ""
    
    create_optimized_settings
    echo ""
    
    fix_appimage_permissions
    echo ""
    
    disable_hardware_acceleration
    echo ""
    
    echo "🎉 Fix process completed!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Wait 10 seconds before starting Cursor"
    echo "2. Start Cursor with: ./Cursor-*.AppImage --no-sandbox --disable-gpu"
    echo "3. If issues persist, restart your system"
    echo ""
    echo "💡 Pro tips:"
    echo "- Close unnecessary browser tabs and applications"
    echo "- Avoid opening large projects initially"
    echo "- Use 'htop' to monitor system resources"
}

# Run the main function
main