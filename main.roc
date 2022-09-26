app "rocbox"
    packages { pf: "roc/examples/interactive/cli-platform/main.roc" }
    imports [Commands, pf.Arg, pf.Program.{ Program }, pf.Stdout]
    provides [main] to pf

main : Program
main = Program.withArgs \args ->
    when Arg.parseFormatted parser args is
        Ok command ->
            # TODO: Support stdin
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
            # TODO: Add cat, cp, mv, rm, split, tee, etc.
            subcommand Commands.echo,
            subcommand Commands.false,
            subcommand Commands.true,
        ]
    |> Arg.program
        {
            name: "RocBox",
            help: "A Roc-based implementation of a subset of BusyBox",
        }

subcommand = \command ->
    Arg.succeed command.mapper
    |> \subparser ->
        # TODO: Support multiple arguments
        when command.arg is
            ArgNone -> subparser
            ArgStr config -> Arg.withParser subparser (Arg.str config)
    |> Arg.subCommand command.name
