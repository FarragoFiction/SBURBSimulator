import 'dart:html';

enum LogLevel {
    ERROR,
    WARN,
    INFO,
    VERBOSE,
    DEBUG
}

/// Template for methods which print stuff
typedef void LoggerPrintFunction(Object arg);

class Logger {
    /// Whether .verbose messages should be shown at all.
    static bool printVerbose = false;

    /// Whether this Logger should display .debug messages.
    /// Debug messages are never shown in compiled js.
    bool printDebug;

    /// Section name displayed in output.
    final String name;

    /// A simple logger for controlling console output.
    ///
    /// printDebug specifies whether this logger prints .debug messages.
    /// Debug messages are never printed in compiled js.
    Logger(String this.name, [bool this.printDebug = false]);

    /// Convenience method for getting a logger.
    static Logger get(String name, [bool debug = true]) {
        return new Logger(name, debug);
    }

    /// Pretties up the output
    String _format(LogLevel level, Object arg) {
        return "(${this.name})[${level.toString().split(".").last}]: $arg";
    }

    /// Gets the console method for a LogLevel
    static LoggerPrintFunction _getPrintForLevel(LogLevel level) {
        if (level == LogLevel.ERROR) { return window.console.error; }
        if (level == LogLevel.WARN) { return window.console.warn; }
        if (level == LogLevel.VERBOSE) { return window.console.info; }
        return print;
    }

    /// Prefer one of the level specific methods
    void log(LogLevel level, Object arg) {
        _getPrintForLevel(level)(_format(level, arg));
    }

    /// NOW YOU FUCKED UP
    void error(Object arg) {
        this.log(LogLevel.ERROR, arg);
    }

    /// Yellow, for picking out mistakes
    void warn(Object arg) {
        this.log(LogLevel.WARN, arg);
    }

    /// Normal output
    void info(Object arg) {
        this.log(LogLevel.INFO, arg);
    }

    /// For extra info not shown in some cases
    void verbose(Object arg) {
        if (printVerbose) {
            this.log(LogLevel.VERBOSE, arg);
        }
    }

    /// For development
    void debug(Object arg) {
        if ((!(0.0 is int)) && this.printDebug) {
            this.log(LogLevel.DEBUG, arg);
        }
    }
}