module owlnet.cli.help;

import owlnet.cli.options;

import io.text, io.file.stdio;

import darg;

int displayHelp(string command)
{
    import io.text;
    import std.traits : getUDAs;

    foreach (Options; OptionsList)
    {
        alias commands = getUDAs!(Options, Command);
        foreach (c; commands)
        {
            if (c.name == command)
            {
                enum usage = usageString!Options("owlnet "~ commands[0].name);

                alias descriptions = getUDAs!(Options, Description);
                static if(descriptions.length > 0)
                    enum help = helpString!Options(descriptions[0].description);
                else
                    enum help = helpString!Options();

                static if (usage !is null)
                    println(usage);
                static if (help !is null)
                    println(help);

                return 0;
            }
        }
    }

    printfln("No help available for '%s'.", command);
    return 1;
}

private immutable string generalHelp = q"EOS
The most commonly used commands are:
 help            Prints help on a specific command.
 version         Prints the current version of the program.

Use 'owlnet help <command>' to get help on a specific command.
EOS";

/**
 * Display help information.
 */
int helpCommand(HelpOptions opts, GlobalOptions globalOpts)
{
    if (opts.command)
        return displayHelp(opts.command);

    println(globalUsage);
    println(globalHelp);
    println(generalHelp);
    return 0;
}

/**
 * Display version information.
 */
int displayVersion(VersionOptions opts, GlobalOptions globalOpts)
{
    stdout.println("owlnet version 0.1.0");
    return 0;
}
