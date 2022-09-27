interface Commands
    exposes [echo, run]
    imports []

echo = {
    name: "echo",
    mapper: \text -> Echo text,
    runner: \text -> { stdout: text, exitCode: 0 },
    arg: ArgStr {
        long: "text",
        short: "t",
        help: "the text to echo",
    },
    # TODO: Add the real options:
    # -n      Suppress trailing newline
    # -e      Interpret backslash-escaped characters (i.e., \t=tab)
    # -E      Disable interpretation of backslash-escaped characters
}

run = \command ->
    when command is
        Echo text -> echo.runner text
