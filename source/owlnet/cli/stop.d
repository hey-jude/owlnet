module owlnet.cli.stop;

import owlnet.cli.options : StopOptions, GlobalOptions;

import io.text, io.file;

import owlnet.log;

Logger stopLogger(in StopOptions opts)
{
    import owlnet.log.file;
    return new FileLogger(stdout, opts.verbose);
}

int stopCommand(StopOptions opts, GlobalOptions globalOpts)
{
    import std.path : dirName, absolutePath;

    auto logger = stopLogger(opts);

    return 0;
}
