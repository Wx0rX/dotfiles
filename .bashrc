#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f /home/funky.dir_colors   ]] && match_lhs="${match_lhs}$(</home/funky.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer /home/funky.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f /home/funky.dir_colors ]] ; then
			eval $(dircolors -b /home/funky.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias nano="nano -i"
alias lsa="ls -la"
alias cle="clear"
alias shut="sudo shutdown -h now"
alias vsc="code"
alias py="python3"
alias batall="bat -P"

alias gitstatus="git status"
alias gitlog="git log"
alias gitlogallgraph="git log --all --graph --abbrev-commit"
alias gitadd="git add"
alias gitcommit="git commit"
alias gitbranch="git branch"
alias gitpush="git push"
alias gitremote="git remote"
alias gitrestore="git restore"
alias gitdiff="git diff"
alias gitcheckout="git checkout"
alias gitpull="git pull"
alias gitfetch="git fetch"
alias gitfetchallprune="git fetch --all --prune"

alias flake8-exclude="flake8 . --count --show-source --statistics --exclude "

alias temp_monitor="sudo hddtemp -d /dev/sda && psensor"
alias xsc='xclip -sel clip'
alias sqlstudio="sqlitestudio"
alias youtube-dl-aria2c='youtube-dl -k -f best --external-downloader aria2c --external-downloader-args "-j 16 -x 16 -s 16 -k 1M"'
alias youtube-dl-mp3='youtube-dl -i --extract-audio --audio-format mp3 --audio-quality 0'

alias catproject="tree && find . -type f -exec printf '=%.0s' {1..126} \; -exec echo \; -exec echo {} \; -exec printf '=%.0s' {1..126} \; -exec echo \; -exec bat -P --color=always --decorations=never {} \; -exec echo \;"

alias pacmanupdatemirrors='sudo pacman-mirrors --geoip'

# only for xorg installations. requires imagemagick
# screenshow_root_window() {
#     if [[ $# -ne 1 ]]
#     then
#         echo "Please, provide one filename of destination screenshot image"
#         return 1
#     fi
#     import -window root $1
# }

mkcd() {
    if [[ $# -eq 1 ]]
    then
        mkdir -p $1 && cd $1
    fi
}

pip-list-package-dependencies() {
    if [[ $# -ne 1 ]]
    then
        echo "Please, provide one already installed package name, which dependencies you want to list"
        return 1
    fi
    python3 -c "(lambda pkg_name: print(*map(str, (wrkset.requires() if hasattr((wrkset := __import__('importlib').import_module('pip._vendor.pkg_resources', package='pip').working_set.by_key.get(pkg_name)), 'requires') else (f'Please install {pkg_name} to do this operation',))), sep='\n'))('$1'.lower())"
}

rm_pycache() {
    if [[ $# -ne 1 ]]
    then
        echo "Please, provide one positive integer, which will be passed to \"find\" as \"-maxdepth\" argument"
        return 1
    fi
    find . -mindepth 1 -maxdepth $1 -type d -name '__pycache__' -exec rm -r {} \; > /dev/null 2>&1
    echo "__pycache__ directories with depth <= $1 were successfully deleted!"
}

histdeln() {
    history -d -$(($1 + 1))--1
}

# SECTION "CAPSLOCK GSETTINGS" BEGIN
change_capslock_to() {
    if [[ $# -ne 1 ]]
    then
        echo "Please, provide one argument to change caps lock behaviour"
        evdev_lst="/usr/share/X11/xkb/rules/evdev.lst"
        if [[ -f $evdev_lst ]]
        then
            echo "These are the options for the replacement: (provide a key when the option is \"caps:{key}\")"
            grep -a "caps:" $evdev_lst
        fi
        return 1
    fi
    gsettings set org.gnome.desktop.input-sources xkb-options \[\'caps:$1\'\]
    echo "Caps lock behaviour was successfully changed!"
}

alias GSETTINGS_CHANGE_CAPS_TO_HYPER="change_capslock_to hyper"
alias GSETTINGS_CHANGE_CAPS_TO_DISABLED="change_capslock_to none"
alias GSETTINGS_CHANGE_CAPS_TO_CAPS="change_capslock_to caps"
# SECTION "CAPSLOCK GSETTINGS" END

# SECTION "FUNCTIONS FOR OLYMPIAD PROGRAMMING" BEGIN
PREPAREDIRS() {
    template_path="~/cppOlympTemplate.cpp"
    cptemplate=0; [[ -f $template_path ]] && cptemplate=1;
    for name in $@;
    do
        mkdir -p $name
        if [[ $cptemplate ]]
        then
            cp -n $template_path $name/$name.cpp
        else
            touch $name/$name.cpp
        fi
    done
}

TESTAOUT() {
    if [[ ! -f a.out ]]
    then
        echo "Sorry, there\'s nothing to test, \"a.out\" file is not provided"
        return 1
    fi
    if [[ $# -eq 0 ]]
    then
        echo "Please, provide a numeric argument \"i\", create file named \"in{i}\", then call \"TESTAOUT {i}\""
        return 1
    fi
    if [[ ! -f in$1 ]]
    then
        echo "Please, create \"in$1\" file, contents of which will be piped to your ./a.out execution"
        return 1
    fi
    echo -----INPUT$1.TXT-----
    cat in$1
    cat in$1 | ./a.out > out || return 1
    echo -----OUTPUT$1.TXT-----
    cat out
    if [[ -f out$1 ]]
    then
        echo -----DIFF$1.TXT-----
        diff out out$1
    fi
}

INRANGETEST() {
    for num in $(seq $1 $2 || return 1);
    do
        echo ----------TEST\ CASE\ $num----------
        TESTAOUT $num || return 0
    done
}
# SECTION "FUNCTIONS FOR OLYMPIAD PROGRAMMING" END

### WINE PROGRAMS

alias microsoft_paint='env WINEARCH=win32 WINEPREFIX=/home/funky.msoffice wine /home/funky.msoffice/drive_c/windows/mspaint.exe'

### MICROSOFT OFFICE

alias microsoft_excel='cd /home/funky.msoffice/drive_c/Program\ Files/Microsoft\ Office/Office15; env WINEARCH=win32 WINEPREFIX=/home/funky.msoffice wine EXCEL.EXE'
alias microsoft_word='cd /home/funky.msoffice/drive_c/Program\ Files/Microsoft\ Office/Office15; env WINEARCH=win32 WINEPREFIX=/home/funky.msoffice wine WINWORD.EXE'
alias microsoft_powerpoint='cd /home/funky.msoffice/drive_c/Program\ Files/Microsoft\ Office/Office15; env WINEARCH=win32 WINEPREFIX=/home/funky.msoffice wine POWERPNT.EXE'

### END WINE PROGRAMS

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export PATH=/home/funky/.local/bin:/usr/local/bin:/usr/bin:/var/lib/snapd/snap/bin:/usr/local/sbin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/Qt:/opt/Qt/Tools/QtCreator/bin:/opt/Qt/Tools/QtDesignStudio/bin:/opt/SQLiteStudio
