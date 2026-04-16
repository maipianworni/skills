#!/bin/bash
# aggregate-skills.sh
# Scans a directory for skills and outputs the aggregate command for skill-tree-generator.
# Run this script first, then Claude will use the output to invoke skill-tree-generator.
#
# Usage:
#   ./scripts/aggregate-skills.sh <skill-directory> [--domain <domain-name>]
#
# Examples:
#   ./scripts/aggregate-skills.sh .claude/skills
#   ./scripts/aggregate-skills.sh tasks/my-project/environment/skills --domain data-processing

set -euo pipefail

SKILL_DIR="${1:?Usage: $0 <skill-directory> [--domain <domain-name>]}"
shift

DOMAIN=""
if [[ $# -ge 2 && "$1" == "--domain" ]]; then
    DOMAIN="$2"
    shift 2
fi

echo "=== Skill Scanner ==="
echo "Scanning: $SKILL_DIR"
echo ""

# Find all SKILL.md files, skipping *-tree directories
SKILL_NAMES=()
while IFS= read -r -d '' file; do
    # Skip files inside *-tree directories (already structured)
    # Skip skill-tree-generator itself (meta skill, not a task skill)
    if [[ "$file" == *"-tree/"* ]] || [[ "$file" == *"skill-tree-generator"* ]]; then
        continue
    fi

    skill_dir=$(dirname "$file")

    # Skill name = directory name containing SKILL.md
    # Or filename if SKILL.md is directly in SKILL_DIR
    if [[ "$skill_dir" == "$SKILL_DIR" ]]; then
        skill_name=$(basename "$file" .md)
    else
        skill_name=$(basename "$skill_dir")
    fi

    echo "  - $skill_name"
    SKILL_NAMES+=("$skill_name")
done < <(find "$SKILL_DIR" -name "SKILL.md" -print0 2>/dev/null | sort -z)

count=${#SKILL_NAMES[@]}

if [[ $count -eq 0 ]]; then
    echo "No skills found in $SKILL_DIR"
    exit 1
fi

echo ""
echo "Found $count skill(s)"
echo ""

# Output the command for Claude to execute
if [[ $count -eq 1 ]]; then
    CMD="/skill-tree-generator ${SKILL_NAMES[0]}"
else
    AGGREGATE_LIST=$(IFS=,; echo "${SKILL_NAMES[*]}")
    CMD="/skill-tree-generator --aggregate $AGGREGATE_LIST"
fi

if [[ -n "$DOMAIN" ]]; then
    CMD="$CMD --domain $DOMAIN"
fi

echo "=== Next Step ==="
echo "Run this command in Claude to generate the skill-tree:"
echo ""
echo "  $CMD"
echo ""
