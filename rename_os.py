import os
import re

directory = r"c:\Users\Agung\Documents\AgungaOSNEW"

replacements = [
    # GitHub paths
    (r"Anakagung2009-bit/AgungOS", r"Anakagung2009-bit/AgungOS"),
    (r"Anakagung2009-bit-AgungOS", r"Anakagung2009-bit-AgungOS"),
    (r"ghcr\.io/Anakagung2009-bit/AgungOS", r"ghcr.io/Anakagung2009-bit/agungos"),
    (r"ghcr\.io/ublue-os", r"ghcr.io/Anakagung2009-bit"),
    
    # OS Names
    (r"AgungOS", r"AgungOS"),
    (r"agungos", r"agungos"),
    (r"AGUNGOS", r"AGUNGOS"),
]

def replace_in_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        return False
    
    new_content = content
    for pattern, replacement in replacements:
        new_content = re.sub(pattern, replacement, new_content)
        
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

modified_files = []
for root, dirs, files in os.walk(directory):
    # skip .git strictly
    if '\\.git\\' in root or root.endswith('\\.git'):
        continue
    if '\\.vscode' in root:
        continue
    for file in files:
        if file.endswith(('.png', '.svg', '.der', '.jpg', '.jpeg', '.iso', '.exe', '.svgz')):
            continue
        filepath = os.path.join(root, file)
        if replace_in_file(filepath):
            modified_files.append(filepath)

print(f"Modified {len(modified_files)} files:")
for f in modified_files:
    print(f)
