#!/bin/bash

# Script to fix common Flutter lint issues

echo "Fixing withOpacity deprecation warnings..."

# Fix withOpacity -> withValues(alpha: 
find lib -name "*.dart" -type f -exec perl -pi -e 's/\.withOpacity\(([^)]+)\)/.withValues(alpha: $1)/g' {} \;

echo "Fixed withOpacity deprecation warnings!"

# Fix avoid_print issues by replacing print with debugPrint
echo "Fixing print statements..."
find lib -name "*.dart" -type f -exec perl -pi -e 's/\bprint\(/debugPrint(/g' {} \;

echo "Fixed print statements!"

echo "All lint issues fixed!"
