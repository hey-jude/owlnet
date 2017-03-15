module owlnet.cli.restart;

import owlnet.cli.options : RestartOptions, GlobalOptions;

import io.text, io.file;

import owlnet.log;

Logger restartLogger(in RestartOptions opts)
{
    import owlnet.log.file;
    return new FileLogger(stdout, opts.verbose);
}

int restartCommand(RestartOptions opts, GlobalOptions globalOpts)
{
    import std.path : dirName, absolutePath;

    auto logger = restartLogger(opts);

    return 0;
}
