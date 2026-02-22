import sys
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')

p = Path("prisma/schema.prisma")
b = p.read_bytes()

# Check for BOM
has_bom = b.startswith(b'\xef\xbb\xbf')
if has_bom:
    print("WARNING: UTF-8 BOM detected - removing...")
    b = b[3:]  # Remove BOM
    p.write_bytes(b)
    print("✓ BOM removed")
else:
    print("OK: No BOM")

# Decode
s = b.decode("utf-8")

# Comprehensive non-ASCII check
problematic_chars = {
    '\u2018': "'",   # Left single quote
    '\u2019': "'",   # Right single quote
    '\u201c': '"',   # Left double quote
    '\u201d': '"',   # Right double quote
    '\u2013': '-',   # En dash
    '\u2014': '--',  # Em dash
    '\u2026': '...', # Ellipsis
    '\u00a0': ' ',   # Non-breaking space
    '\u200b': '',    # Zero-width space
    '\u200c': '',    # Zero-width non-joiner
    '\u200d': '',    # Zero-width joiner
    '\u2192': '->',  # Right arrow
    '\u2190': '<-',  # Left arrow
    '\ufeff': '',    # Zero-width no-break space (BOM)
}

issues = []
for i, line in enumerate(s.splitlines(), 1):
    for j, ch in enumerate(line, 1):
        if ord(ch) > 127:
            issues.append((i, j, ch, ord(ch), line))

if issues:
    print(f"\nFound {len(issues)} non-ASCII characters:")
    
    # Group by character type
    char_counts = {}
    for i, j, ch, code, line in issues:
        char_counts[ch] = char_counts.get(ch, 0) + 1
    
    for ch, count in sorted(char_counts.items(), key=lambda x: -x[1]):
        code = ord(ch)
        replacement = problematic_chars.get(ch, '?')
        print(f"  U+{code:04X} '{ch}' ({count}x) -> replace with '{replacement}'")
    
    print("\nLocations:")
    for i, j, ch, code, line in issues[:10]:  # Show first 10
        print(f"  Line {i}:{j} U+{code:04X} '{ch}'")
        ctx_start = max(0, j-15)
        ctx_end = min(len(line), j+15)
        print(f"    ...{line[ctx_start:ctx_end]}...")
    
    if len(issues) > 10:
        print(f"  ... and {len(issues) - 10} more")
    
    # Auto-fix
    print("\nReplacing non-ASCII characters...")
    fixed = s
    for old, new in problematic_chars.items():
        if old in fixed:
            count = fixed.count(old)
            fixed = fixed.replace(old, new)
            print(f"  Replaced {count}x U+{ord(old):04X} '{old}' -> '{new}'")
    
    # Save fixed version
    p.write_bytes(fixed.encode('utf-8'))
    print(f"\n✓ Saved cleaned schema ({len(fixed)} chars, {len(fixed.encode('utf-8'))} bytes)")
    print("✓ Schema is now pure ASCII + UTF-8 (no BOM)")
else:
    print("OK: No non-ASCII characters found")
    print(f"Schema: {len(s)} chars, {len(b)} bytes, UTF-8 encoding")
