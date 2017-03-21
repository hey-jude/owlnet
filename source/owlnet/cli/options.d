module owlnet.cli.options;

import std.meta : AliasSeq;

import darg;

struct Command
{
    string name;
}

struct Description
{
    string description;
}

struct GlobalOptions
{
    @Option("help")
    @Help("Prints help on command line usage.")
    OptionFlag help;

    @Option("dryrun", "n")
    @Help("Don't make any functional changes. Just print what might happen.")
    OptionFlag dryRun;
    
    @Argument("command", Multiplicity.optional)
    string command;

    @Argument("args", Multiplicity.zeroOrMore)
    const(string)[] args;
}

// Generate usage and help strings at compile-time.
immutable globalUsage = usageString!GlobalOptions("owlnet");
immutable globalHelp  = helpString!GlobalOptions();

@Command("help")
@Description("Displays help on a given command.")
struct HelpOptions
{
    @Argument("command", Multiplicity.optional)
    @Help("Command to get help on.")
    string command;
}

@Command("version")
@Description("Prints the current version of the program.")
struct VersionOptions
{
}

@Command("create")
@Description("Creates VMs.")
struct CreateOptions
{
    @Option("color")
    @Help("When to colorize the output.")
    @MetaVar("{auto,never,always}")
    string color = "auto";

    @Option("verbose", "v")
    @Help("Display additional information such as how long each task took to"~
          " complete.")
    OptionFlag verbose;

    @Argument("vmNames")
    @Help("VM names.")
    string vmNames;

    @Argument("args", Multiplicity.zeroOrMore)
    string[] args;
}

@Command("destroy")
@Description("Destroy VMs.")
struct DestroyOptions
{
    @Argument("vmNames")
    @Help("VM names.")
    string vmNames;
}

@Command("init")
@Description("Initializes a directory with an initial build description.")
struct InitOptions
{
    @Argument("dir", Multiplicity.optional)
    @Help("Directory to initialize")
    string dir = ".";

    @Option("file", "f")
    @Help("Path to the build description.")
    string path;
}

@Command("clean")
@Description("Deletes all test.")
struct CleanOptions
{
    @Option("file", "f")
    @Help("Path to the build description.")
    string path;

    @Option("color")
    @Help("When to colorize the output.")
    @MetaVar("{auto,never,always}")
    string color = "auto";

    @Option("purge")
    @Help("Delete the build state too.")
    OptionFlag purge;
}

@Command("start")
@Description("Start test.")
struct StartOptions
{
    @Option("file", "f")
    @Help("Path to the build description.")
    string path;

    @Option("verbose", "v")
    @Help("Display additional information such as how long each task took to"~
          " complete.")
    OptionFlag verbose;
}

@Command("stop")
@Description("Stop test.")
struct StopOptions
{
    @Option("file", "f")
    @Help("Path to the build description.")
    string path;

    @Option("verbose", "v")
    @Help("Display additional information such as how long each task took to"~
          " complete.")
    OptionFlag verbose;
}

@Command("restart")
@Description("Restart test.")
struct RestartOptions
{
    @Option("file", "f")
    @Help("Path to the build description.")
    string path;

    @Option("verbose", "v")
    @Help("Display additional information such as how long each task took to"~
          " complete.")
    OptionFlag verbose;
}

/**
 * List of all options structs.
 */
alias OptionsList = AliasSeq!(
        HelpOptions,
        VersionOptions,
        CreateOptions,
        DestroyOptions,
        InitOptions,
        CleanOptions,
        StartOptions,
        StopOptions,
        RestartOptions,
        );

/**
 * Thrown when an invalid command name is given to $(D runCommand).
 */
class InvalidCommand : Exception
{
    this(string msg)
    {
        super(msg);
    }
}

/**
 * Using the list of command functions, runs a command from the specified
 * string.
 *
 * Throws: InvalidCommand if the given command name is not valid.
 */
int runCommand(Funcs...)(string name, GlobalOptions opts)
{
    import std.traits : Parameters, getUDAs;
    import std.format : format;

    foreach (F; Funcs)
    {
        alias Options = Parameters!F[0];

        alias Commands = getUDAs!(Options, Command);

        foreach (C; Commands)
        {
            if (C.name == name)
                return F(parseArgs!Options(opts.args, Config.ignoreUnknown), opts);
        }
    }

    throw new InvalidCommand("owlnet: '%s' is not a valid command. See 'owlnet help'."
            .format(name));
}
