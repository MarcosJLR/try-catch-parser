# try-catch-parser
A basic LL(1) Parser with attributes to parse try catch expressions

## Instructions

Compile with `stack build` and run with `stack run`.
Input is received through standard input.

Tokens are:
* `try`
* `catch`
* `finally`
* `;`
* `instr_<type>:`  where `type` is a non-empty alphaNumeric string.

All tokens in input must be separated by whitespaces.

Samples:
```bash
stack run <<< "try instr_t catch instr_c1 ; instr_c2"
```

```bash
stack run <<< "try instr_t catch instr_c finally instr_f"
```

```bash
stack run <<< "instr_1 ; instr_2"
```
