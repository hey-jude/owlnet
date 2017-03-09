module owlnet.cli.create;

import owlnet.cli.options : CreateOptions, GlobalOptions;

import io.text, io.file;

import owlnet.textcolor;
import owlnet.log;

Logger createLogger(in CreateOptions opts)
{
    import owlnet.log.file;
    return new FileLogger(stdout, opts.verbose);
}

int createCommand(CreateOptions opts, GlobalOptions globalOpts)
{
    import std.path : dirName, absolutePath;

    auto logger = createLogger(opts);

    immutable color = TextColor(colorOutput(opts.color));

    return 0;
}
