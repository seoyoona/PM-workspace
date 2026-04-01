#!/bin/bash
# Deploy PM Telegram Bot to AWS Lambda
# Prerequisites: AWS CLI + SAM CLI installed, AWS account configured

set -euo pipefail

STACK_NAME="pm-telegram-bot"
REGION="${AWS_REGION:-ap-northeast-2}"
S3_BUCKET="${SAM_S3_BUCKET:-}"

echo "=== PM Telegram Bot Deploy ==="

# 1. Copy context data (clients + glossary) into deployment package
echo "Copying client context data..."
rm -rf context/data
mkdir -p context/data
cp -r ../clients context/data/
cp -r ../glossary context/data/

# 2. Build
echo "Building..."
sam build --use-container 2>/dev/null || sam build

# 3. Deploy
echo "Deploying to ${REGION}..."

if [ -z "$S3_BUCKET" ]; then
    sam deploy \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --resolve-s3 \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides \
            "TelegramToken=${TELEGRAM_TOKEN}" \
            "AllowedUserIds=${ALLOWED_USER_IDS:-}" \
            "AnthropicApiKey=${ANTHROPIC_API_KEY}" \
            "NotionToken=${NOTION_TOKEN:-}" \
            "GoogleClientId=${GOOGLE_CLIENT_ID:-}" \
            "GoogleClientSecret=${GOOGLE_CLIENT_SECRET:-}" \
            "GoogleRefreshToken=${GOOGLE_REFRESH_TOKEN:-}" \
            "TeamsFlowUrl=${TEAMS_FLOW_URL:-}" \
            "TeamsChatKoboomDev=${TEAMS_CHAT_KOBOOM_DEV:-}" \
            "TeamsChatRckDev=${TEAMS_CHAT_RCK_DEV:-}" \
            "TeamsChat21gramDev=${TEAMS_CHAT_21GRAM_DEV:-}" \
            "TeamsChatBooktailsDev=${TEAMS_CHAT_BOOKTAILS_DEV:-}" \
            "TeamsChatEverytalkDev=${TEAMS_CHAT_EVERYTALK_DEV:-}" \
        --no-confirm-changeset
else
    sam deploy \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --s3-bucket "$S3_BUCKET" \
        --capabilities CAPABILITY_IAM \
        --parameter-overrides \
            "TelegramToken=${TELEGRAM_TOKEN}" \
            "AllowedUserIds=${ALLOWED_USER_IDS:-}" \
            "AnthropicApiKey=${ANTHROPIC_API_KEY}" \
            "NotionToken=${NOTION_TOKEN:-}" \
            "GoogleClientId=${GOOGLE_CLIENT_ID:-}" \
            "GoogleClientSecret=${GOOGLE_CLIENT_SECRET:-}" \
            "GoogleRefreshToken=${GOOGLE_REFRESH_TOKEN:-}" \
            "TeamsFlowUrl=${TEAMS_FLOW_URL:-}" \
            "TeamsChatKoboomDev=${TEAMS_CHAT_KOBOOM_DEV:-}" \
            "TeamsChatRckDev=${TEAMS_CHAT_RCK_DEV:-}" \
            "TeamsChat21gramDev=${TEAMS_CHAT_21GRAM_DEV:-}" \
            "TeamsChatBooktailsDev=${TEAMS_CHAT_BOOKTAILS_DEV:-}" \
            "TeamsChatEverytalkDev=${TEAMS_CHAT_EVERYTALK_DEV:-}" \
        --no-confirm-changeset
fi

# 4. Get webhook URL
WEBHOOK_URL=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --query "Stacks[0].Outputs[?OutputKey=='WebhookUrl'].OutputValue" \
    --output text)

echo ""
echo "=== Deploy Complete ==="
echo "Webhook URL: $WEBHOOK_URL"
echo ""

# 5. Set Telegram webhook
echo "Setting Telegram webhook..."
curl -s "https://api.telegram.org/bot${TELEGRAM_TOKEN}/setWebhook?url=${WEBHOOK_URL}"
echo ""
echo ""
echo "Done! Send /help to your bot to test."
