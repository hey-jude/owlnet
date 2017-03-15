module owlnet.cli.destroy;

import std.stdio : writeln;
import std.process;

import io;

import owlnet.cli.options : DestroyOptions, GlobalOptions;

int destroyCommand(DestroyOptions opts, GlobalOptions globalOpts)
{
    foreach(vm; opts.vmNames) {
        writeln("commandline: " ~ ["docker-machine", "rm", "-y"] ~ vm);
        auto dmd = execute(["docker-machine", "rm", "-y"] ~ vm);
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
