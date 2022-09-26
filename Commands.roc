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
}

run = \command ->
    when command is
        Echo text -> echo.runner text
