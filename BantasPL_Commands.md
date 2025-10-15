# Bantas Programming Language Command Reference

This document provides a reference for all available commands in the Bantas programming language.

---

## General Syntax Notes

### Stack Referencing
Bantas uses the `@` sigil to reference values from other stacks.

*   **Direct Referencing (`@`):** `@<index>` refers to the value in the stack at the given index. For example, `?,@1` prints the value from stack 1.
*   **Indirect Referencing (`@@`):** `@@<index_stack>` provides a second level of indirection. The interpreter first gets a number from `<index_stack>`, then uses that number as the index to get the final value.
    *   **Example:** If stack `2` contains the number `11`, and stack `11` contains the value `88`, the argument `@@2` will resolve to `88`.

### Use of Quotes (`"`)
In Bantas, whitespace is always preserved, whether you use quotes or not. However, quotes are essential for forcing a literal string interpretation for a value that might otherwise look like a number or a stack reference.

*   `<,123` stores a **number**, but `<,"123"` stores a **string**.
*   `?,@1` prints the value from stack 1, but `?,"@1"` prints the literal string `@1`.
*   `<,  hello  ` and `<,"  hello  "` both store the string "  hello  " with spaces.

---

## Core Commands

### `@` - Set Active Stack
*   **Description:** Sets the active stack pointer to a specific position. Most commands operate on the active stack.
*   **Syntax:** `@,<position>`
*   **Details:** The `<position>` argument can be a literal number (e.g., `@,5`), a reference to another stack (`@,@2`), or the special value `0` (`@,0`) to refer to the current loop's counter variable (only valid inside a loop).
*   **Example:** `@,5` sets the active stack to position 5.
*   **Example:** If stack 2 contains the number 8, `@,@2` sets the active stack to position 8.

### `<` - Store Value
*   **Description:** Stores a value into the active stack.
*   **Syntax:** `<,<value>`
*   **Example:** `<,100` stores the number 100. `<,"hello"` stores the string "hello".

### `>` - User Input
*   **Description:** Prompts the user for input and stores the result in the active stack. The prompt message itself is interpreted, allowing for dynamic prompts.
*   **Syntax:** `>,<prompt_message>`
*   **Details:** The `<prompt_message>` is processed the same way as values in other commands. This means quoted strings will have their quotes removed, and you can use a stack reference (e.g., `>,@1`) to use the content of another stack as the prompt.
*   **Example (Literal Prompt):** `>,"Enter your age:"` will display the prompt `Enter your age:` and store the user's entry.
*   **Example (Dynamic Prompt):** If stack 1 contains "Your quest?", `>,@1` will display `Your quest?` as the prompt.

### `?` - Print
*   **Description:** Prints the specified value to the console, followed by a newline.
*   **Syntax:** `?,<value>`
*   **Example:** `?,@1` prints the value from stack 1. `?,Hello World` prints the string "Hello World".

### `??` - Print Without Newline
*   **Description:** Prints the specified value to the console without appending a newline character.
*   **Syntax:** `??,<value>`
*   **Example:** `??,"Hello "` followed by `??,"World!"` will print `Hello World!` on a single line.

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

### `//` - Integer Divide
*   **Description:** Performs integer division on the active stack's value with the argument's value.
*   **Syntax:** `//,<value>`
*   **Example:** If stack 1 has 10, `//,3` will change it to 3.

### `///` - Modulo
*   **Description:** Performs modulo division on the active stack's value with the argument's value.
*   **Syntax:** `///,<value>`
*   **Example:** If stack 1 has 10, `///,3` will change it to 1.

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

### `><` - Trim Whitespace
*   **Description:** Removes leading and trailing whitespace from a string.
*   **Syntax:** `><,<string_value>`
*   **Example:** If stack 1 contains "  hello  ", `><,@1` will change it to "hello".

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
*   **Description:** Creates a `for`-style or `while`-style loop.
*   **Syntax (For-style):** `[,<start_value>` ... loop body ... `],<end_value>`
*   **Syntax (While-style):** `[,<start_value>` ... loop body ... `],<operator><end_value>`
*   **Details:** The `[` command starts the loop and initializes a counter. The `]` command marks the end.
*   **For-style loops:** When no operator is given, the loop behaves like a traditional `for` loop. It implicitly checks for `<=` for increasing loops and `>=` for decreasing loops.
*   **While-style Loops:** By providing a single-character relational operator (`<`, `>`, `=`) in the `]` command, the loop will continue only as long as the condition is true.
*   **For-style Example (Step by 2):
    ```
    [,2      'Start loop at 2
      ?,@0    'or ?,@ - Prints the loop counter (2, 4, 6, 8, 10)
      @,0     'or @, -Activate virtual loop counter
      +,2    'Increment counter by 2
    ],10     'Loop continues until counter is > 10
    ```
*   **While-style Example:
    ```
    @,1
    <,5
    [,1      'Initialize counter to 1
      ?,@1
      @,1
      *,2    'Multiply stack 1 by 2 in each iteration
    ],<100   'Continue WHILE the loop counter is LESS THAN 100
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
    #,=10 'or #,10
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
*   **Description:** Loads stack values from a specified file. Supports two formats: explicit (`number=>value`) to load a value into a specific stack, and implicit (a plain list of values) to load values into consecutive stacks starting from the active one.
*   **Syntax:** `|,<filename>`
*   **Example:** `|,my_data.txt`

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
