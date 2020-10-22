#pragma once

/**
 * @brief The EXIT_CUSTOM_CODE enum
 *
 * https://tldp.org/LDP/abs/html/exitcodes.html
 * Standard Bash Exit Codes With Special Meanings
 * ExitCode Number	Meaning                                                     Example                     Comments
 * 1                Catchall for general errors	let                             "var1 = 1/0"                Miscellaneous errors, such as "divide by zero" and other impermissible operations
 * 2                Misuse of shell builtins (according to Bash documentation)  empty_function() {}         Missing keyword or command, or permission problem (and diff return code on a failed binary file comparison).
 * 126              Command invoked cannot execute                              /dev/null                   Permission problem or command is not an executable
 * 127              "command not found"                                         illegal_command             Possible problem with $PATH or a typo
 * 128              Invalid argument to exit                                    exit 3.14159                exit takes only integer args in the range 0 - 255 (see first footnote)
 * 128+n            Fatal error signal "n"                                      kill -9 $PPID of script     $? returns 137 (128 + 9)
 * 130              Script terminated by Control-C                              Ctl-C                       Control-C is fatal error signal 2, (130 = 128 + 2, see above)
 * 255*             Exit status out of range                                    exit -1	exit takes only     integer args in the range 0 - 255
 *
 * According to the above table, exit codes 1 - 2, 126 - 165, and 255 [1] have special meanings, and should therefore be avoided for user-specified exit parameters.
 * Ending a script with exit 127 would certainly cause confusion when troubleshooting (is the error code a "command not found" or a user-defined one?).
 * However, many scripts use an exit 1 as a general bailout-upon-error. Since exit code 1 signifies so many possible errors, it is not particularly useful in debugging.
 */

#include <QObject>

class ExitCodeCustom : public QObject
{
    Q_OBJECT
public:
    ExitCodeCustom() {}
    virtual ~ExitCodeCustom() {}

    enum EXIT_CUSTOM_CODE{
        ECC_NORMAL_EXIT,
        ECC_NORMAL_EXIT_RESTART_SBC = 5,
        ECC_NORMAL_EXIT_POWEROFF_SBC,
        ECC_NORMAL_EXIT_OPEN_SBCUPDATE,
        ECC_NORMAL_EXIT_DEV
    };
    Q_ENUM(EXIT_CUSTOM_CODE);
};
