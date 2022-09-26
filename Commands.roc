interface Commands
    exposes [echo, run]
    imports []

run = \command ->
    when command is
        Echo text -> echo.runner text
        False -> false.runner
        True -> true.runner

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

false = {
    name: "false",
    mapper: False,
    runner: { stdout: "", exitCode: 1 },
    arg: ArgNone,
}

true = {
    name: "true",
    mapper: True,
    runner: { stdout: "", exitCode: 0 },
    arg: ArgNone,
}
