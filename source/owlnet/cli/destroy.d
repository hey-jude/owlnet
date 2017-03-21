module owlnet.cli.destroy;

import std.stdio : writeln;
import std.process;

import io;

import owlnet.cli.options : DestroyOptions, GlobalOptions;

int destroyCommand(DestroyOptions opts, GlobalOptions globalOpts)
{
    if (globalOpts.dryRun) {
        writeln("opts: " ~ opts.vmNames);
    }
    else
    {
        auto vm = opts.vmNames;
        auto cmdline = ["docker-machine", "rm", "-y"] ~ vm;
        writeln("commandline: " ~ cmdline);
        auto dmd = execute(cmdline);
        if (dmd.status != 0)
        {
            writeln("Execution failed:\n", dmd.output);
        }
        else
        {
            writeln("Execution succeeded:\n", dmd.output);
        }
    }
    return 0; //dmd.status;
}
