# Password Generator
As a client facing member of IT, the ability to generate secure and complient passwords is a requirement. Relying in a basic password generator that creates an entirely randomized string of letters, numbers, and symbols would certainly be effective in a vacuum. When introducing the context of a user who is already frustrated at forgetting their password and having to complete identity verification, ease of use is also an important consideration.

This password generator was written with the objective of creating passwords that are secure and exceed minimum password requirements, but are also less challenging for a user to enter prior to changing it.

The script should be accompanied by a 3 column CSV. Each column should contain random words of a given category. The categories can follow a convention (e.g. noun/adverb/verb) to make the password more memorable, or they can be entirely random. The script will randomly pull one word per category and separate each word with a number or symbol. The password will then be copied to the clipboard for easy pasting.

When creating the accompanying CSV, be sure that the columns are labeled WordOne, WordTwo, and WordThree.