app "cu"
    packages { pf: "roc/examples/interactive/cli-platform/main.roc" }
    imports [pf.Arg, pf.Program.{ Program }, pf.Stdout]
    provides [main] to pf

main : Program
main = Program.withArgs \args ->
    when Arg.parseFormatted parser args is
        Ok command ->
            run command
            |> \{ stdout, exitCode } ->
                stdout
                |> Stdout.line
                |> Program.exit exitCode

        Err helpMenu ->
            helpMenu
            |> Stdout.line
            |> Program.exit 1

parser =
    echo =
        Arg.succeed (\text -> Echo text)
        |> Arg.withParser
            (
                Arg.str {
                    long: "text",
                    short: "t",
                    help: "the text to echo",
                }
            )
        |> Arg.subCommand "echo"

    Arg.choice [echo]
    |> Arg.program
        {
            name: "cu",
            help: "A Roc-based implementation of the GNU Core Utilities",
        }

run = \command ->
    when command is
        Echo text -> { stdout: text, exitCode: 0 }
