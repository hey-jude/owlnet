// // import std.getopt;
// import std.stdio;

// import darg;
// import vibe.core.log;

// struct Options
// {
//     @Option("help", "h")
//     @Help("Prints this help.")
//     OptionFlag help;

//     // @Option("threads", "t")
//     // @Help("Number of threads to use.")
//     // size_t threads;

//     @Argument("command", Multiplicity.optional)
//     @Help("Commands")
//     string command;

//     // @Argument("file", Multiplicity.zeroOrMore)
//     // @Help("Input files")
//     // string[] files;
// }

// // Generate the usage and help string at compile time.
// immutable usage = usageString!Options("owlnet");
// immutable help = helpString!Options;


// int main(string[] args)
// {
// 	Options options;

//     try
//     {
//         options = parseArgs!Options(args[1 .. $]);
//     }
//     catch (ArgParseError e)
//     {
//         writeln(e.msg);
//         writeln(usage);
//         return 1;
//     }
//     catch (ArgParseHelp e)
//     {
//         // Help was requested
//         writeln(usage);
//         write(help);
//         return 0;
//     }

//     writeln("Command: " ~ options.command);

//     // foreach (f; options.files)
//     // {
//     //     // Use files
//     // }

//     return 0;
// }

static import backtrace;

import owlnet.cli;

import std.meta : AliasSeq;
import std.stdio : stderr;
import io.text;
import darg;

/**
 * List of command functions.
 */
alias Commands = AliasSeq!(
        helpCommand,
        displayVersion,
        createCommand,
        destroyCommand,
        initCommand,
        cleanCommand,
        startCommand,
        stopCommand,
        restartCommand,
        );

int main(const(string)[] args)
{
    version(linux) {
        backtrace.install(stderr);
    }

    GlobalOptions opts;

    try
    {
        opts = parseArgs!GlobalOptions(args[1 .. $], Config.ignoreUnknown);
    }
    catch (ArgParseError e)
    {
        println("Error parsing arguments: ", e.msg, "\n");
        println(globalUsage);
        return 1;
    }

    // Rewrite to "help" command.
    if (opts.help)
    {
        opts.args = (opts.command ? opts.command : "help") ~ opts.args;
        opts.command = "help";
    }

    if (opts.command == "")
    {
        helpCommand(parseArgs!HelpOptions(opts.args), opts);
        return 1;
    }

    try
    {
        return runCommand!Commands(opts.command, opts);
    }
    catch (InvalidCommand e)
    {
        println(e.msg);
        return 1;
    }
    catch (ArgParseError e)
    {
        println("Error parsing arguments: ", e.msg, "\n");
        displayHelp(opts.command);
        return 1;
    }
}