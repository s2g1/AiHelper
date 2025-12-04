#!/bin/bash

# -----------------------------
# Usage:
# Step 1: ./business_ideation.sh --step 1 --sector "Industrial IoT" --num_options 4 --geo_market US --notes "Focus on low-power sensors"
# Step 2: ./business_ideation.sh --step 2 --selected_option "Option 1: AI-driven Vibration Sensors" --geo_market US --stage Seed --funding_goal "$500k"
# -----------------------------

# Default values
STEP=""
SECTOR=""
NUM_OPTIONS=4
GEO_MARKET="US"
NOTES=""
SELECTED_OPTION=""
STAGE="Seed"
FUNDING_GOAL="$500k"
ADDITIONAL_REQS=""

# Read API key from file
API_KEY_FILE="./api_key.txt"
if [[ ! -f "$API_KEY_FILE" ]]; then
    echo "Error: api_key.txt not found in current directory"
    exit 1
fi
API_KEY=$(<"$API_KEY_FILE")

# Parse CLI arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --step) STEP="$2"; shift 2 ;;
    --sector) SECTOR="$2"; shift 2 ;;
    --num_options) NUM_OPTIONS="$2"; shift 2 ;;
    --geo_market) GEO_MARKET="$2"; shift 2 ;;
    --notes) NOTES="$2"; shift 2 ;;
    --selected_option) SELECTED_OPTION="$2"; shift 2 ;;
    --stage) STAGE="$2"; shift 2 ;;
    --funding_goal) FUNDING_GOAL="$2"; shift 2 ;;
    --additional_reqs) ADDITIONAL_REQS="$2"; shift 2 ;;
    *) echo "Unknown parameter $1"; exit 1 ;;
  esac
done

if [[ -z "$API_KEY" ]]; then
  echo "Error: API key is empty"
  exit 1
fi

if [[ "$STEP" == "1" ]]; then
  # Step 1: Generate sector analysis
  PROMPT=$(cat <<EOF
Step 1: Sector / Topic Analysis

Sector / Industry: $SECTOR
Number of Options to Generate: $NUM_OPTIONS
Geography / Market Focus: $GEO_MARKET
Additional Notes: $NOTES

Task:
1. Identify $NUM_OPTIONS high-growth potential sub-sectors or technology opportunities within this sector.
2. For each option, provide:
   - Market size and growth trends
   - Key technological innovations
   - Target customers / buyers
   - Potential challenges / risks
   - Short business opportunity statement

Output Format: Table

Important:
- Do NOT generate any business plan yet.
- Wait for user review and selection of one option for Step 2.
EOF
)

elif [[ "$STEP" == "2" ]]; then
  # Step 2: Generate full business plan
  if [[ -z "$SELECTED_OPTION" ]]; then
    echo "Error: --selected_option is required for Step 2"
    exit 1
  fi

  PROMPT=$(cat <<EOF
Step 2: Generate Business Products

Selected Option: $SELECTED_OPTION
Geography / Market: $GEO_MARKET
Company Stage: $STAGE
Funding Goal: $FUNDING_GOAL
Additional Requirements: $ADDITIONAL_REQS

Task:
Develop a complete business package including:
- Product concept and technology stack
- Target customer profile
- Go-to-market strategy
- Business model and pricing
- Pitch deck outline
- 12-month engineering roadmap
- Founding team profile and roles
- Prototype architecture
- Cost breakdown and unit economics
- Fundraising narrative

Output Format: detailed text suitable for documentation, spreadsheets, and presentation slides.
EOF
)

else
  echo "Error: --step must be 1 or 2"
  exit 1
fi

# Call OpenAI API using curl
curl https://api.openai.com/v1/chat/completions \
  -s \
  -H "Con
