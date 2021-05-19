# Python program to print
# colored text and background
import sys

try:
    tabs = int(sys.argv[1])
except IndexError:
    tabs = 0
try:
    spaces = int(sys.argv[2])
except IndexError:
    spaces = 0

sp = '\t'*tabs + ' '*spaces

class c:

    """Colors class:reset all colors with colors.reset; two
    sub classes fg for foreground
    and bg for background; use as colors.subclass.colorname.
    i.e. colors.fg.red or colors.bg.greenalso, the generic bold, disable,
    underline, reverse, strike through,
    and invisible work with the main class i.e. colors.bold"""
    reset = '\033[0m'
    bold = '\033[01m'
    disable = '\033[02m'
    underline = '\033[04m'
    reverse = '\033[07m'
    strikethrough = '\033[09m'
    invisible = '\033[08m'

    class fg:
        black = '\033[30m'
        red = '\033[31m'
        green = '\033[32m'
        yellow = '\033[33m'
        blue = '\033[34m'
        magenta = '\033[35m'
        cyan = '\033[36m'
        white = '\033[37m'

        brblack = '\033[90m'
        brred = '\033[91m'
        brgreen = '\033[92m'
        bryellow = '\033[93m'
        brblue = '\033[94m'
        brmagenta = '\033[95m'
        brcyan = '\033[96m'
        brwhite = '\033[97m'

    class bg:
        black = '\033[40m'
        red = '\033[41m'
        green = '\033[42m'
        yellow = '\033[43m'
        blue = '\033[44m'
        magenta = '\033[45m'
        cyan = '\033[46m'
        white = '\033[47m'

        brblack = '\033[100m'
        brred = '\033[101m'
        brgreen = '\033[102m'
        bryellow = '\033[103m'
        brblue = '\033[104m'
        brmagenta = '\033[105m'
        brcyan = '\033[106m'
        brwhite = '\033[107m'


print(sp + c.bg.black + c.fg.brwhite + "black        " + c.reset, end=' ')
print(c.bg.brblack + c.fg.brwhite + "brblack      " + c.reset)

print(sp + c.bg.red + c.fg.black + "red          " + c.reset, end=' ')
print(c.bg.brred + c.fg.black + "brred        " + c.reset)

print(sp + c.bg.green + c.fg.black + "green        " + c.reset, end=' ')
print(c.bg.brgreen + c.fg.black + "brgreen      " + c.reset)

print(sp + c.bg.yellow + c.fg.black + "yellow       " + c.reset, end=' ')
print(c.bg.bryellow + c.fg.black + "bryellow     " + c.reset)

print(sp + c.bg.blue + c.fg.black + "blue         " + c.reset, end=' ')
print(c.bg.brblue + c.fg.black + "brblue       " + c.reset)

print(sp + c.bg.magenta + c.fg.black + "magenta      " + c.reset, end=' ')
print(c.bg.brmagenta + c.fg.black+"brmagenta    " + c.reset)

print(sp + c.bg.cyan + c.fg.black + "cyan         " + c.reset, end=' ')
print(c.bg.brcyan + c.fg.black + "brcyan       " + c.reset)

print(sp + c.bg.white + c.fg.black + "white        " + c.reset, end=' ')
print(c.bg.brwhite + c.fg.black + "brwhite      " + c.reset,)
