# Bantas Programming Language Command Reference

This document provides a reference for all available commands in the Bantas programming language.

---

## General Syntax Notes

### Use of Quotes (`"`)
While many commands can accept unquoted strings, using double quotes (`"`) is a good practice for clarity and safety. Quotes are **required** if you want to force a literal string interpretation for a value that might otherwise look like a number or a stack reference.

*   `<,123` stores a **number**, but `<,"123"` stores a **string**.
*   `?,@1` prints the value from stack 1, but `?`,"@1"` prints the literal string `@1`.
*   Leading and trailing spaces are preserved in unquoted arguments, but using quotes makes the intent clear (e.g., `<," hello ">`).

---

## Core Commands

### `@` - Set Active Stack
*   **Description:** Sets the active stack pointer to a specific position. Most commands operate on the active stack.
*   **Syntax:** `@,<position>`
*   **Example:** `@,5` sets the active stack to position 5. `@,@2` sets the active stack to the position indicated by the value in stack 2.

### `<` - Store Value
*   **Description:** Stores a value into the active stack.
*   **Syntax:** `<,<value>`
*   **Example:** `<,100` stores the number 100. `<,"hello">` stores the string "hello".

### `>` - User Input
*   **Description:** Prompts the user for input and stores the result in the active stack.
*   **Syntax:** `>,<prompt_message>`
*   **Example:** `>,Enter your age` will display the prompt and store the user's entry.

### `?` - Print
*   **Description:** Prints the specified value to the console.
*   **Syntax:** `?,<value>`
*   **Example:** `?,@1` prints the value from stack 1. `?,Hello World` prints the string "Hello World".

---

## Arithmetic Commands

*Note: These commands require the active stack and the argument to be numbers.*

### `+` - Add
*   **Description:** Adds the argument's value to the active stack's value.
*   **Syntax:** `+,<value>`
*   **Example:** `+,10` adds 10 to the active stack.

### `-` - Subtract
*   **Description:** Subtracts the argument's value from the active stack's value.
*   **Syntax:** `-,<value>`
*   **Example:** `-,5` subtracts 5 from the active stack.

### `*` - Multiply
*   **Description:** Multiplies the active stack's value by the argument's value.
*   **Syntax:** `*,<value>`
*   **Example:** `*,2` doubles the value in the active stack.

### `/` - Divide
*   **Description:** Divides the active stack's value by the argument's value.
*   **Syntax:** `/,<value>`
*   **Example:** `/,2` halves the value in the active stack.

### `^` - Exponent
*   **Description:** Raises the active stack's value to the power of the argument's value.
*   **Syntax:** `^,<exponent>`
*   **Example:** `^,3` cubes the value in the active stack.

### `$` - Random Number
*   **Description:** Generates a random integer between 1 and the given value (inclusive) and stores it in the active stack.
*   **Syntax:** `$,<max_value>`
*   **Example:** `$,100` stores a random number between 1 and 100.

---

## String Manipulation

### `&` - Concatenate
*   **Description:** Appends the argument's string value to the active stack's string value. The argument can be a literal value or a reference to another stack.
*   **Syntax:** `&,<value>`
*   **Example:** If stack 1 contains "Hello", `&, World` changes it to "Hello World". If stack 2 contains "There", `&,@2` would change stack 1 to "HelloThere".

### `_` - String Length
*   **Description:** Measures the length of the argument string and stores the result (a number) in the active stack. The argument can be a literal value or a reference to another stack.
*   **Syntax:** `_,<string_value>`
*   **Example:** `_,Hello` stores the number 5. If stack 2 contains "Bantas", `_,@2` will store 6.

### `(` - Left Substring
*   **Description:** Takes a substring from the left of the string in the active stack.
*   **Syntax:** `(,<length>`
*   **Example:** If the active stack has "abcdef", `(,3` will change it to "abc".

### `)` - Right Substring
*   **Description:** Takes a substring from the right of the string in the active stack.
*   **Syntax:** `),<length>`
*   **Example:** If the active stack has "abcdef", `),2` will change it to "ef".

---

## Control Flow

### `[` and `]` - Loop
*   **Description:** Creates a `for`-style loop. The `[` command starts the loop with an initial counter value. The `]` command defines the termination value and jumps back to `[` if the condition is not met.
*   **Syntax:** `[,<start_value>` ... loop body ... `],<end_value>`
*   **Notes:**
    *   To control the loop's step, use the `+` or `-` commands on the virtual loop counter. The virtual counter is made active with `@,` inside the loop body.
*   **Incrementing Loop Example (Step by 2):**
    ```
    [,2      'Start loop at 2
      ?,@    'Prints the loop counter (2, 4, 6, 8, 10)
      @,     'Activate virtual loop counter
      +,2    'Increment counter by 2
    ],10     'End loop at 10
    ```
*   **Decrementing Loop Example (Step by 2):**
    ```
    [,10     'Start loop at 10
      ?,@    'Prints the loop counter (10, 8, 6, 4, 2)
      @,     'Activate virtual loop counter
      -,2    'Decrement counter by 2
    ],2      'End loop at 2
    ```

### `#`, `!`, `;` - If/Else/Endif
*   **Description:** Creates a conditional block.
    *   `#` (If): Executes the following block only if the condition is met.
    *   `!` (Else): Executes the following block if the `#` condition was not met.
    *   `;` (End If): Marks the end of the conditional block.
*   **Syntax:** `#,<condition>` ... `!` ... `;
*   **Example:**
    ```
    @,1
    <,10
    #,=10
      ?,Value is 10
    !
      ?,Value is not 10
    ;
    ```

---

## Trigonometry

*Note: These commands take an argument in degrees and store the result in the active stack.*

### `{` - Sine
*   **Syntax:** `{,<degrees>`
*   **Example:** `{,90` stores `1` (sin of 90 degrees).

### `}` - Cosine
*   **Syntax:** `},<degrees>`
*   **Example:** `},0` stores `1` (cos of 0 degrees).

### `\` - Tangent
*   **Syntax:** `\,<degrees>`
*   **Example:** `\,45` stores `1` (tan of 45 degrees).

---

## File and System Commands

### `~` - Dump Stacks
*   **Description:** Prints a range of stack values to the console and writes them to `out.txt`.
*   **Syntax:** `~,<number_of_stacks>`
*   **Example:** `~,10` dumps the first 10 stacks (or from the active stack onwards).

### `|` - Load Stacks from File
*   **Description:** Loads stack values from a specified file (e.g., `out.txt`).
*   **Syntax:** `|,<filename>`
*   **Example:** `|,out.txt`

### `` ` `` - Shell Execute
*   **Description:** Executes a shell command and stores the standard output in the active stack.
*   **Syntax:** `` `,<command>` ``
*   **Example:** `` `ls -l` `` (Linux) or `` `dir` `` (Windows) stores the file listing in the active stack.

---

## Type and Format Commands

### `.` - Character to Byte
*   **Description:** Converts a single character to its ASCII byte value.
*   **Syntax:** `.,<character>`
*   **Example:** `.,A` stores the number 65 in the active stack.

### `:` - Byte to Character
*   **Description:** Converts an ASCII byte value to its character representation.
*   **Syntax:** `:,<byte_value>`
*   **Example:** `:,65` stores the string "A" in the active stack.

### `%` - Format Value
*   **Description:** Applies formatting to a number or string in the active stack.
*   **Syntax:** `%,<format_code>`
*   **Notes on Template Formatting:**
    *   When using a template for numbers (e.g., `%,##0.00`), the `0` is a digit placeholder that pads with leading/trailing zeros.
    *   The `#` is a digit placeholder that does **not** pad with extra zeros. It's useful for defining a minimum number of digits without forcing zero-padding. For example, with a value of `7.5`, a format of `0.00` yields `7.50`, while `#.#` would yield `7.5`.
*   **Examples:**
    *   **String (in active stack):** `%,U` (UPPERCASE), `%,L` (lowercase), `%,C` (Capital Case).
    *   **Number (in active stack):** `%,I` (Integer), `%,F2` (Float with 2 decimals), `%,M` (Money format with commas), `%,000.00` (Template-based padding).

---

(c) 2025 Jon Velasco a.k.a. muthym  
Facebook : MUTHYM's Code  
e-mail : muthym2020@gmail.com
