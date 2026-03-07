#!/bin/env python3

import random
import string

import pyperclip


def generate_characters():
    all_chars = string.ascii_lowercase + string.digits  # lowercase letters + digits
    return "".join(
        random.choice(all_chars)  # noqa: S311
        for _ in range(5)
    )


characters = generate_characters()
pyperclip.copy(characters)

print(f"Generated: {characters}")
