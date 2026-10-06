#!/usr/bin/env bash
set -e

# ==============================================================================
# Setup GitHub Secrets for ChargeEasy Android CI/CD Pipeline
# ==============================================================================

CREDENTIALS_DIR="$HOME/Downloads/credentials"
KEYSTORE_BASE64_FILE="$CREDENTIALS_DIR/keystore_base64.txt"

if [ ! -f "$KEYSTORE_BASE64_FILE" ]; then
    echo "❌ Error: Keystore base64 file not found at $KEYSTORE_BASE64_FILE"
    echo "Please ensure ~/Downloads/credentials/ contains keystore_base64.txt."
    exit 1
fi

KEYSTORE_BASE64=$(cat "$KEYSTORE_BASE64_FILE")
KEYSTORE_PASSWORD="ChargeEasy@2026!ReleaseKey"
KEY_PASSWORD="ChargeEasy@2026!ReleaseKey"
KEY_ALIAS="chargeeasy"

echo "=============================================================================="
echo "Configuring GitHub Secrets for ChargeEasy..."
echo "=============================================================================="

if command -v gh &> /dev/null; then
    if gh auth status &> /dev/null; then
        echo "✓ GitHub CLI authenticated."
        echo "Uploading secrets to current repository..."
        gh secret set KEYSTORE_BASE64 -b "$KEYSTORE_BASE64"
        gh secret set KEYSTORE_PASSWORD -b "$KEYSTORE_PASSWORD"
        gh secret set KEY_PASSWORD -b "$KEY_PASSWORD"
        gh secret set KEY_ALIAS -b "$KEY_ALIAS"
        echo "🎉 Successfully uploaded all 4 release secrets to GitHub Secrets!"
        exit 0
    else
        echo "⚠️  GitHub CLI (gh) is installed but not authenticated."
        echo "To authenticate, run: gh auth login"
        echo "After logging in, rerun this script to automatically push secrets."
    fi
else
    echo "⚠️  GitHub CLI (gh) not found in PATH."
fi

echo ""
echo "------------------------------------------------------------------------------"
echo "Manual GitHub Secrets Configuration (if not using GitHub CLI):"
echo "------------------------------------------------------------------------------"
echo "Navigate to your GitHub Repository -> Settings -> Secrets and variables -> Actions"
echo "Click 'New repository secret' and add the following 4 secrets:"
echo ""
echo "1. KEY_ALIAS:         $KEY_ALIAS"
echo "2. KEY_PASSWORD:      $KEY_PASSWORD"
echo "3. KEYSTORE_PASSWORD: $KEYSTORE_PASSWORD"
echo "4. KEYSTORE_BASE64:   (Copy contents of $KEYSTORE_BASE64_FILE or credentials.txt)"
echo "------------------------------------------------------------------------------"
