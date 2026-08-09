import os
import re

def remove_comments_from_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove full line comments: any amount of whitespace followed by // and then anything until end of line
    content = re.sub(r'^\s*//.*$\n', '', content, flags=re.MULTILINE)
    
    # Remove inline comments: spaces followed by // (but not http://)
    # Negative lookbehind for colon to avoid matching http:// or https://
    content = re.sub(r'(?<!:)\s*//.*$', '', content, flags=re.MULTILINE)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                remove_comments_from_file(os.path.join(root, file))

if __name__ == '__main__':
    main()
