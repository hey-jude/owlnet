module owlnet.cli.init;

import std.stdio;
import std.process;

import io;

import owlnet.cli.options : InitOptions, GlobalOptions;

int initCommand(InitOptions opts, GlobalOptions globalOpts)
{
    auto dmd = execute(["ls", "dscanner.ini"] ~ [opts.dir]);
    writeln("commandline: " ~ ["ls", "dscanner.ini"] ~ opts.dir);
    if (dmd.status != 0)
    {
        writeln("Execution failed:\n", dmd.output);
    }
    else
    {
        writeln("Execution succeeded:\n", dmd.output);
    }
    return dmd.status;
}
