module owlnet.cli.create;

import std.stdio : writeln;
import std.process;

import owlnet.cli.options : CreateOptions, GlobalOptions;

import io.text, io.file;

import owlnet.textcolor;
import owlnet.log;

Logger createLogger(in CreateOptions opts)
{
    import owlnet.log.file : FileLogger;
    return new FileLogger(stdout, opts.verbose);
}

int createCommand(CreateOptions opts, GlobalOptions globalOpts)
{
    writeln("commandline: " ~ opts.vmNames ~ opts.args);

    foreach(vm; opts.vmNames) {
        writeln("commandline: " ~ ["docker-machine", "create"] ~ vm);
        auto dmd = execute(["docker-machine", "create"] ~ vm);
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
