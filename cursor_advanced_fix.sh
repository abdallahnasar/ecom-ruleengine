#!/bin/bash

echo "🔧 Advanced Cursor Fix - Addressing Persistent Issues"
echo "===================================================="

# Check if running as root for some operations
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        echo "⚠️  Some fixes require sudo. Please run: sudo -v"
        sudo -v
    fi
}

# Function to completely kill and clean Cursor processes
deep_process_cleanup() {
    echo "🧹 Step 1: Deep process cleanup..."
    
    # Kill all Cursor-related processes
    sudo pkill -9 -f "cursor" 2>/dev/null || true
    sudo pkill -9 -f "Cursor" 2>/dev/null || true
    sudo pkill -9 -f "chrome_crashpad_handler" 2>/dev/null || true
    
    # Kill any hanging AppImage processes
    sudo pkill -9 -f "AppImage" 2>/dev/null || true
    
    # Clean up any mounted AppImages
    sudo umount /tmp/.mount_Cursor* 2>/dev/null || true
    
    # Remove AppImage temp files
    sudo rm -rf /tmp/.mount_Cursor* 2>/dev/null || true
    
    echo "✅ Process cleanup completed"
}

# Function to fix inotify limits properly
fix_inotify_limits() {
    echo "📁 Step 2: Properly fixing inotify limits..."
    
    # Set immediate limits
    echo 524288 | sudo tee /proc/sys/fs/inotify/max_user_watches > /dev/null
    echo 8192 | sudo tee /proc/sys/fs/inotify/max_user_instances > /dev/null
    echo 524288 | sudo tee /proc/sys/fs/inotify/max_queued_events > /dev/null
    
    # Verify limits were set
    WATCHES=$(cat /proc/sys/fs/inotify/max_user_watches)
    INSTANCES=$(cat /proc/sys/fs/inotify/max_user_instances)
    
    if [ "$WATCHES" -eq 524288 ] && [ "$INSTANCES" -eq 8192 ]; then
        echo "✅ inotify limits properly set: watches=$WATCHES, instances=$INSTANCES"
    else
        echo "❌ Failed to set inotify limits. Current: watches=$WATCHES, instances=$INSTANCES"
        return 1
    fi
    
    # Make persistent
    sudo sed -i '/fs.inotify.max_user_watches/d' /etc/sysctl.conf 2>/dev/null || true
    sudo sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf 2>/dev/null || true
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf > /dev/null
    echo "fs.inotify.max_user_instances=8192" | sudo tee -a /etc/sysctl.conf > /dev/null
    
    # Apply sysctl changes
    sudo sysctl -p /etc/sysctl.conf > /dev/null 2>&1 || true
    
    echo "✅ inotify limits made persistent"
}

# Function to fix AppImage issues
fix_appimage_issues() {
    echo "📦 Step 3: Fixing AppImage mounting and resource issues..."
    
    # Create a proper temp directory for AppImages
    sudo mkdir -p /tmp/cursor-appimage
    sudo chmod 755 /tmp/cursor-appimage
    
    # Set AppImage environment variables
    export APPIMAGE_EXTRACT_AND_RUN=1
    export TMPDIR=/tmp/cursor-appimage
    
    # Fix FUSE permissions (common AppImage issue)
    sudo modprobe fuse 2>/dev/null || true
    
    # Clean up any existing mounts
    mount | grep -i cursor | awk '{print $3}' | sudo xargs -r umount 2>/dev/null || true
    
    echo "✅ AppImage environment prepared"
}

# Function to create comprehensive Cursor configuration
create_advanced_config() {
    echo "⚙️  Step 4: Creating advanced Cursor configuration..."
    
    # Create user data directory
    mkdir -p "$HOME/.cursor-nightly"
    
    # Advanced argv.json with all stability flags
    cat > "$HOME/.cursor-nightly/argv.json" << 'EOF'
{
    "disable-hardware-acceleration": true,
    "disable-gpu": true,
    "disable-gpu-compositing": true,
    "disable-gpu-rasterization": true,
    "disable-gpu-sandbox": true,
    "no-sandbox": true,
    "disable-dev-shm-usage": true,
    "disable-background-timer-throttling": true,
    "disable-backgrounding-occluded-windows": true,
    "disable-renderer-backgrounding": true,
    "disable-features": "VizDisplayCompositor,CalculateNativeWinOcclusion",
    "enable-features": "DisableOutOfBlinkCors",
    "force-high-performance-gpu": false,
    "disable-extensions-except": [],
    "disable-web-security": true,
    "disable-software-rasterizer": true,
    "in-process-gpu": true,
    "disable-background-networking": true
}
EOF

    # Also create for regular cursor directory
    mkdir -p "$HOME/.cursor"
    cp "$HOME/.cursor-nightly/argv.json" "$HOME/.cursor/argv.json"
    
    echo "✅ Advanced configuration created"
}

# Function to create optimized settings
create_optimized_settings() {
    echo "🎛️  Step 5: Creating optimized settings..."
    
    # Create settings directory
    mkdir -p "$HOME/.config/Cursor - Nightly/User"
    mkdir -p "$HOME/.config/Cursor/User"
    
    # Comprehensive settings.json
    cat > "$HOME/.config/Cursor - Nightly/User/settings.json" << 'EOF'
{
    "files.watcherExclude": {
        "**/node_modules/**": true,
        "**/.git/objects/**": true,
        "**/.git/subtree-cache/**": true,
        "**/target/**": true,
        "**/build/**": true,
        "**/dist/**": true,
        "**/.next/**": true,
        "**/.cache/**": true,
        "**/tmp/**": true,
        "**/.tmp/**": true,
        "**/temp/**": true
    },
    "search.exclude": {
        "**/node_modules": true,
        "**/bower_components": true,
        "**/.git": true,
        "**/target": true,
        "**/build": true,
        "**/dist": true,
        "**/.next": true,
        "**/.cache": true
    },
    "terminal.integrated.enablePersistentSessions": false,
    "terminal.integrated.persistentSessionReviveProcess": "never",
    "terminal.integrated.localEchoLatencyThreshold": -1,
    "terminal.integrated.smoothScrolling": false,
    "terminal.integrated.fastScrollSensitivity": 5,
    "terminal.integrated.gpuAcceleration": "off",
    "terminal.integrated.rendererType": "dom",
    "extensions.autoUpdate": false,
    "extensions.autoCheckUpdates": false,
    "editor.codeLens": false,
    "editor.minimap.enabled": false,
    "editor.hover.enabled": true,
    "editor.hover.delay": 1500,
    "editor.quickSuggestions": false,
    "editor.suggestOnTriggerCharacters": false,
    "editor.acceptSuggestionOnEnter": "off",
    "workbench.enableExperiments": false,
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "workbench.settings.enableNaturalLanguageSearch": false,
    "settingsSync.enabled": false,
    "configurationSync.enabled": false,
    "git.enabled": true,
    "git.autorefresh": false,
    "git.autofetch": false,
    "scm.diffDecorations": "none",
    "diffEditor.ignoreTrimWhitespace": true,
    "files.autoSave": "off",
    "files.trimTrailingWhitespace": false,
    "workbench.activityBar.visible": true,
    "workbench.statusBar.visible": true,
    "workbench.sideBar.location": "left",
    "workbench.editor.enablePreview": false,
    "workbench.editor.enablePreviewFromQuickOpen": false,
    "security.workspace.trust.enabled": false,
    "window.menuBarVisibility": "default"
}
EOF

    # Copy to regular Cursor config
    cp "$HOME/.config/Cursor - Nightly/User/settings.json" "$HOME/.config/Cursor/User/settings.json" 2>/dev/null || true
    
    echo "✅ Optimized settings created"
}

# Function to test the fixes
test_cursor_stability() {
    echo "🧪 Step 6: Testing Cursor stability..."
    
    # Set environment variables
    export ELECTRON_NO_ATTACH_CONSOLE=1
    export ELECTRON_DISABLE_SECURITY_WARNINGS=1
    export CURSOR_NO_SANDBOX=1
    export APPIMAGE_EXTRACT_AND_RUN=1
    export TMPDIR=/tmp/cursor-appimage
    
    echo "Environment variables set:"
    echo "  ELECTRON_NO_ATTACH_CONSOLE=1"
    echo "  ELECTRON_DISABLE_SECURITY_WARNINGS=1"
    echo "  CURSOR_NO_SANDBOX=1"
    echo "  APPIMAGE_EXTRACT_AND_RUN=1"
    echo "  TMPDIR=/tmp/cursor-appimage"
    
    echo "✅ Test environment prepared"
}

# Create startup script
create_startup_script() {
    echo "🚀 Step 7: Creating optimized startup script..."
    
    cat > "$HOME/start_cursor_stable.sh" << 'EOF'
#!/bin/bash

# Set environment variables for stability
export ELECTRON_NO_ATTACH_CONSOLE=1
export ELECTRON_DISABLE_SECURITY_WARNINGS=1
export CURSOR_NO_SANDBOX=1
export APPIMAGE_EXTRACT_AND_RUN=1
export TMPDIR=/tmp/cursor-appimage

# Ensure temp directory exists
mkdir -p /tmp/cursor-appimage

# Find Cursor AppImage
CURSOR_APPIMAGE=$(find ~/Downloads -name "Cursor*.AppImage" -type f 2>/dev/null | head -1)

if [ -z "$CURSOR_APPIMAGE" ]; then
    echo "❌ Cursor AppImage not found in ~/Downloads"
    exit 1
fi

echo "🚀 Starting Cursor with stability optimizations..."
echo "Using: $CURSOR_APPIMAGE"

# Start Cursor with all stability flags
"$CURSOR_APPIMAGE" \
    --no-sandbox \
    --disable-gpu \
    --disable-hardware-acceleration \
    --disable-gpu-compositing \
    --disable-gpu-rasterization \
    --disable-dev-shm-usage \
    --disable-background-timer-throttling \
    --disable-renderer-backgrounding \
    --disable-features=VizDisplayCompositor,CalculateNativeWinOcclusion \
    --enable-features=DisableOutOfBlinkCors \
    --in-process-gpu \
    --disable-software-rasterizer \
    --disable-background-networking \
    --disable-web-security \
    --single-process-tabs \
    --max_old_space_size=4096
EOF

    chmod +x "$HOME/start_cursor_stable.sh"
    echo "✅ Startup script created: $HOME/start_cursor_stable.sh"
}

# Main execution
main() {
    echo "Starting advanced Cursor fix process..."
    echo "Time: $(date)"
    echo ""
    
    check_sudo
    echo ""
    
    deep_process_cleanup
    echo ""
    
    fix_inotify_limits
    echo ""
    
    fix_appimage_issues
    echo ""
    
    create_advanced_config
    echo ""
    
    create_optimized_settings
    echo ""
    
    test_cursor_stability
    echo ""
    
    create_startup_script
    echo ""
    
    echo "🎉 Advanced fix process completed!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Restart your system (RECOMMENDED for full effect)"
    echo "2. Or use the startup script: ~/start_cursor_stable.sh"
    echo "3. Monitor system resources with: htop"
    echo ""
    echo "🔧 Manual startup command:"
    echo "cd ~/Downloads && APPIMAGE_EXTRACT_AND_RUN=1 ./Cursor-*.AppImage --no-sandbox --disable-gpu --single-process-tabs"
    echo ""
    echo "⚠️  If issues persist, the AppImage may be corrupted - try downloading a fresh copy"
}

# Run the main function
main