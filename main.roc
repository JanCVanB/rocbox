app "rocbox"
    packages { pf: "roc/examples/interactive/cli-platform/main.roc" }
    imports [Commands, pf.Arg, pf.Program.{ Program }, pf.Stdout]
    provides [main] to pf

main : Program
main = Program.withArgs \args ->
    when Arg.parseFormatted parser args is
        Ok command ->
            Commands.run command
            |> \{ stdout, exitCode } ->
                stdout
                |> Stdout.line
                |> Program.exit exitCode

        Err helpMenu ->
            helpMenu
            |> Stdout.line
            |> Program.exit 1

parser =
    Arg.choice
        [
            subcommand Commands.echo,
        ]
    |> Arg.program
        {
            name: "RocBox",
            help: "A Roc-based implementation of a subset of BusyBox",
        }

subcommand = \command ->
    Arg.succeed command.mapper
    |> \subparser ->
        List.walk command.args subparser \s, arg ->
            when arg is
                ArgStr config -> Arg.withParser s (Arg.str config)
    |> Arg.subCommand command.name

