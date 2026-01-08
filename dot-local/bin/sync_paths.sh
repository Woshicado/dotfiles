#!/usr/bin/env bash

# --- Configuration ---
# 1. The file containing your shortcuts (alias path)
INPUT_FILE="$HOME/.bookmarks"

# 2. The output file for Zsh to source
ZSH_OUTPUT="$HOME/.config/zsh/.zsh_hashes"

# 3. Your OMP Config location (Defaults to $OMPY environment variable)
OMP_CONFIG="${OMPY:-$HOME/omp.yaml}"

# 4. The base Unicode icon prefix (from your snippet)
ICON_PREFIX="\\U000F0725"

# --- Validation ---
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

if [[ ! -f "$OMP_CONFIG" ]]; then
    echo "Error: OMP config '$OMP_CONFIG' not found."
    exit 1
fi

# --- Step 1: Generate Zsh Hash File ---
echo "Generating Zsh hash file at $ZSH_OUTPUT..."

# Overwrite/Create the file
: > "$ZSH_OUTPUT"

while read -r alias path; do
    # Skip empty lines or comments
    [[ -z "$alias" || "$alias" =~ ^# ]] && continue

    # Write hash command: hash -d alias=path
    echo "hash -d $alias=$path" >> "$ZSH_OUTPUT"
done < "$INPUT_FILE"


# --- Step 2: Generate OMP YAML Fragment ---
echo "Updating Oh-My-Posh config at $OMP_CONFIG..."

# Create a temporary file to hold the new YAML content
TMP_YAML=$(mktemp)

while read -r alias path; do
    [[ -z "$alias" || "$alias" =~ ^# ]] && continue

    # Format: ~/path: "\U000F0725alias"
    # We use printf to safely handle the backslash in the icon
    printf "            %s: \"%s%s\"\n" "$path" "$ICON_PREFIX" "$alias" >> "$TMP_YAML"
done < "$INPUT_FILE"

# --- Step 3: Inject into OMP Config ---

# Check if markers exist
if ! grep -q "# START_MAPPINGS" "$OMP_CONFIG" || ! grep -q "# END_MAPPINGS" "$OMP_CONFIG"; then
    echo "Error: Markers '# START_MAPPINGS' and '# END_MAPPINGS' not found in $OMP_CONFIG."
    echo "Please add them under 'mapped_locations:' in your yaml file."
    rm "$TMP_YAML"
    exit 1
fi

# Use sed to delete everything between markers and read in the new content
# 1. Create a temp file for the final config
NEW_CONFIG=$(mktemp)

# 2. Read up to the start marker
sed -n '1,/# START_MAPPINGS/p' "$OMP_CONFIG" > "$NEW_CONFIG"

# 3. Append our generated YAML fragment
cat "$TMP_YAML" >> "$NEW_CONFIG"

# 4. Read from the end marker to the end of file
sed -n '/# END_MAPPINGS/,$p' "$OMP_CONFIG" >> "$NEW_CONFIG"

# 5. Move new config back to original
mv "$NEW_CONFIG" "$OMP_CONFIG"
rm "$TMP_YAML"

echo "Done! Mappings synced."
echo "1. Run 'source $ZSH_OUTPUT' to update current shell."
echo "2. Oh-My-Posh should update automatically (or restart shell)."
