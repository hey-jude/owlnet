module owlnet.cli.start;

import owlnet.cli.options : StartOptions, GlobalOptions;

import io.text, io.file;

import owlnet.log;

Logger startLogger(in StartOptions opts)
{
    import owlnet.log.file;
    return new FileLogger(stdout, opts.verbose);
}

int startCommand(StartOptions opts, GlobalOptions globalOpts)
{
    import std.path : dirName, absolutePath;

    auto logger = startLogger(opts);

    return 0;
}
