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
    @Option("file", "f")
    @Help("Path to the build description.")
    string path;

    @Option("dryrun", "n")
    @Help("Don't make any functional changes. Just print what might happen.")
    OptionFlag dryRun;

    @Option("color")
    @Help("When to colorize the output.")
    @MetaVar("{auto,never,always}")
    string color = "auto";

    @Option("verbose", "v")
    @Help("Display additional information such as how long each task took to"~
          " complete.")
    OptionFlag verbose;

    @Argument("command", Multiplicity.oneOrMore)
    @Help("Command to get help on.")
    string command;
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

@Command("init")
@Description("Initializes a directory with an initial build description.")
struct InitOptions
{
    @Argument("dir", Multiplicity.optional)
    @Help("Directory to initialize")
    string dir = ".";
}

@Command("destroy")
@Description("Destroy a directory with an initial build description.")
struct DestroyOptions
{
    @Argument("dir", Multiplicity.optional)
    @Help("Directory to initialize")
    string dir = ".";
}

/**
 * List of all options structs.
 */
alias OptionsList = AliasSeq!(
        HelpOptions,
        VersionOptions,
        CreateOptions,
        StartOptions,
        CleanOptions,
        InitOptions,
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
                return F(parseArgs!Options(opts.args), opts);
        }
    }

    throw new InvalidCommand("owlnet: '%s' is not a valid command. See 'owlnet help'."
            .format(name));
}
