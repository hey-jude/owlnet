module owlnet.handler;

import owlnet.log;
import owlnet.resource;
import owlnet.context;

alias Handler = void function(
        ref BuildContext ctx,
        const(string)[] args,
        string workDir,
        ref Resources inputs,
        ref Resources outputs,
        TaskLogger logger
        );

immutable Handler[string] handlers;
shared static this()
{
    handlers = [
        "": null,
    ];
}

/**
 * Returns a handler appropriate for the given arguments.
 *
 * In general, this simply looks at the base name of the first argument and
 * determines the tool based on that.
 */
Handler selectHandler(const(string)[] args)
{
    import std.uni : toLower;
    import std.path : baseName, filenameCmp;

    if (args.length)
    {
        auto name = baseName(args[0]);

        // Need case-insensitive comparison on Windows.
        version (Windows)
            name = name.toLower;

        if (auto p = name in handlers)
            return *p;
    }

    return cast(Handler)null;
}

void execute(
        ref BuildContext ctx,
        const(string)[] args,
        string workDir,
        ref Resources inputs,
        ref Resources outputs,
        TaskLogger logger
        )
{
    auto handler = selectHandler(args);

    handler(ctx, args, workDir, inputs, outputs, logger);
}
